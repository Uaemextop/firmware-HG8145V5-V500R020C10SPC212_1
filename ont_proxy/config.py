import os
import pathlib

BASE_DIR = pathlib.Path(__file__).resolve().parent

ONT_HOST = os.environ.get("ONT_HOST", "192.168.100.1")
ONT_PORT = int(os.environ.get("ONT_PORT", "80"))
ONT_SCHEME = os.environ.get("ONT_SCHEME", "http")

PROXY_LISTEN_HOST = os.environ.get("PROXY_HOST", "127.0.0.1")
PROXY_LISTEN_PORT = int(os.environ.get("PROXY_PORT", "8443"))

CERT_DIR = BASE_DIR / "certs"
CA_KEY_FILE = CERT_DIR / "ca_key.pem"
CA_CERT_FILE = CERT_DIR / "ca_cert.pem"
SERVER_KEY_FILE = CERT_DIR / "server_key.pem"
SERVER_CERT_FILE = CERT_DIR / "server_cert.pem"

CA_COMMON_NAME = "HuaweiONT Proxy CA"
SERVER_COMMON_NAME = ONT_HOST

CERT_DAYS_VALID = 3650
CA_KEY_SIZE = 2048
SERVER_KEY_SIZE = 2048

CHROME_PROFILE_NAME = os.environ.get("CHROME_PROFILE", "ONTProxy")

LOG_DIR = BASE_DIR / "logs"
TRAFFIC_LOG_FILE = LOG_DIR / "traffic.log"

ISP_NAME = "Megacable"
MENU_XML = "MenuMegacablePwd.xml"

TARGET_USER_TYPE = "0"
ADMIN_USER_LEVEL = 0
