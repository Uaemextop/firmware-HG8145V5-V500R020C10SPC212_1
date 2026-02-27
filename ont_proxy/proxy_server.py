import datetime
import gzip
import http.server
import io
import logging
import socket
import ssl
import threading
import urllib.request
import urllib.error

from . import config
from . import traffic_modifier

logger = logging.getLogger("ont_proxy")


class TrafficLogger:
    def __init__(self):
        config.LOG_DIR.mkdir(parents=True, exist_ok=True)
        self._fh = open(config.TRAFFIC_LOG_FILE, "a", encoding="utf-8")
        self._lock = threading.Lock()

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.close()

    def log(self, direction, method, path, status=None, body_preview=None, headers=None):
        ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
        parts = [f"[{ts}] {direction} {method} {path}"]
        if status is not None:
            parts.append(f"status={status}")
        if headers:
            for k, v in headers.items():
                parts.append(f"  {k}: {v}")
        if body_preview:
            preview = body_preview[:500].replace("\n", "\\n")
            parts.append(f"  body_preview: {preview}")
        line = " | ".join(parts) + "\n"
        with self._lock:
            self._fh.write(line)
            self._fh.flush()

    def close(self):
        self._fh.close()


traffic_logger = None


def _decompress_body(raw_body, encoding):
    if encoding == "gzip":
        return gzip.decompress(raw_body)
    return raw_body


def _compress_body(body_bytes, encoding):
    if encoding == "gzip":
        buf = io.BytesIO()
        with gzip.GzipFile(fileobj=buf, mode="wb") as gz:
            gz.write(body_bytes)
        return buf.getvalue()
    return body_bytes


class ONTProxyHandler(http.server.BaseHTTPRequestHandler):
    server_version = "ONTProxy/1.0"

    def log_message(self, format, *args):
        logger.debug(format, *args)

    def _build_target_url(self):
        return f"{config.ONT_SCHEME}://{config.ONT_HOST}:{config.ONT_PORT}{self.path}"

    def _forward_request(self, method):
        global traffic_logger

        target_url = self._build_target_url()
        body_data = None

        if method in ("POST", "PUT", "PATCH"):
            content_length = int(self.headers.get("Content-Length", 0))
            if content_length > 0:
                body_data = self.rfile.read(content_length)

        fwd_headers = {}
        for key in self.headers:
            if key.lower() in ("host", "proxy-connection", "proxy-authorization"):
                continue
            fwd_headers[key] = self.headers[key]

        fwd_headers["Host"] = f"{config.ONT_HOST}:{config.ONT_PORT}" if config.ONT_PORT != 80 else config.ONT_HOST

        if traffic_logger:
            traffic_logger.log(
                "REQUEST", method, self.path,
                headers=fwd_headers,
                body_preview=body_data.decode("utf-8", errors="replace") if body_data else None,
            )

        try:
            req = urllib.request.Request(target_url, data=body_data, headers=fwd_headers, method=method)
            ctx = ssl.create_default_context()
            ctx.check_hostname = False
            ctx.verify_mode = ssl.CERT_NONE

            with urllib.request.urlopen(req, context=ctx, timeout=30) as resp:
                resp_status = resp.status
                resp_headers = dict(resp.headers)
                raw_body = resp.read()

        except urllib.error.HTTPError as exc:
            resp_status = exc.code
            resp_headers = dict(exc.headers)
            raw_body = exc.read()

        except (urllib.error.URLError, socket.timeout, ConnectionError) as exc:
            logger.error("Connection to ONT failed: %s", exc)
            self.send_error(502, f"ONT connection failed: {exc}")
            return

        content_encoding = resp_headers.get("Content-Encoding", "")
        content_type = resp_headers.get("Content-Type", "")

        modified_headers = traffic_modifier.modify_response_headers(resp_headers)

        if traffic_modifier.should_modify_response(self.path, content_type):
            try:
                decompressed = _decompress_body(raw_body, content_encoding)
                body_text = decompressed.decode("utf-8", errors="replace")

                modified_body = traffic_modifier.modify_response_body(self.path, body_text, content_type)

                modified_bytes = modified_body.encode("utf-8")
                raw_body = _compress_body(modified_bytes, content_encoding)

                if "Content-Length" in modified_headers:
                    modified_headers["Content-Length"] = str(len(raw_body))

            except Exception as exc:
                logger.warning("Body modification failed for %s: %s", self.path, exc)

        if traffic_logger:
            try:
                preview = _decompress_body(raw_body, content_encoding).decode("utf-8", errors="replace")
            except Exception:
                preview = "<binary>"
            traffic_logger.log(
                "RESPONSE", method, self.path,
                status=resp_status,
                headers=modified_headers,
                body_preview=preview,
            )

        self.send_response(resp_status)
        for key, value in modified_headers.items():
            if key.lower() in ("transfer-encoding",):
                continue
            self.send_header(key, value)
        self.end_headers()
        self.wfile.write(raw_body)

    def do_GET(self):
        self._forward_request("GET")

    def do_POST(self):
        self._forward_request("POST")

    def do_PUT(self):
        self._forward_request("PUT")

    def do_DELETE(self):
        self._forward_request("DELETE")

    def do_HEAD(self):
        self._forward_request("HEAD")

    def do_OPTIONS(self):
        self._forward_request("OPTIONS")

    def do_CONNECT(self):
        host_port = self.path.split(":")
        host = host_port[0]
        port = int(host_port[1]) if len(host_port) > 1 else 443

        if host != config.ONT_HOST:
            self.send_error(403, "Proxy only handles ONT traffic")
            return

        self.send_response(200, "Connection established")
        self.end_headers()

        ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        ssl_context.load_cert_chain(str(config.SERVER_CERT_FILE), str(config.SERVER_KEY_FILE))

        try:
            ssl_socket = ssl_context.wrap_socket(self.connection, server_side=True)
            self.connection = ssl_socket
            self.rfile = ssl_socket.makefile("rb")
            self.wfile = ssl_socket.makefile("wb")
            self.raw_requestline = self.rfile.readline(65537)
            if self.raw_requestline:
                self.parse_request()
                self._forward_request(self.command)
        except ssl.SSLError as exc:
            logger.warning("SSL handshake failed: %s", exc)
        except Exception as exc:
            logger.warning("CONNECT tunnel error: %s", exc)


def start_proxy(use_ssl=False):
    global traffic_logger

    traffic_logger = TrafficLogger()

    server = http.server.HTTPServer(
        (config.PROXY_LISTEN_HOST, config.PROXY_LISTEN_PORT),
        ONTProxyHandler,
    )

    if use_ssl and config.SERVER_CERT_FILE.exists():
        ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        ssl_context.load_cert_chain(str(config.SERVER_CERT_FILE), str(config.SERVER_KEY_FILE))
        server.socket = ssl_context.wrap_socket(server.socket, server_side=True)

    addr = f"{config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT}"
    proto = "HTTPS" if use_ssl else "HTTP"
    print(f"[proxy] {proto} proxy listening on {addr}")
    print(f"[proxy] Forwarding to {config.ONT_SCHEME}://{config.ONT_HOST}:{config.ONT_PORT}")
    print(f"[proxy] Traffic log: {config.TRAFFIC_LOG_FILE}")
    print(f"[proxy] ISP profile: {config.ISP_NAME} ({config.MENU_XML})")
    print(f"[proxy] Target user type: {config.TARGET_USER_TYPE} (admin)")

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n[proxy] Shutting down...")
    finally:
        server.server_close()
        if traffic_logger:
            traffic_logger.close()
