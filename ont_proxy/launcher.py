import argparse
import logging
import sys

from . import config
from . import cert_manager
from . import chrome_profile
from . import proxy_server


def setup_logging(verbose=False):
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(asctime)s [%(name)s] %(levelname)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def cmd_start(args):
    setup_logging(args.verbose)

    print(f"=== HuaweiONT Proxy for {config.ISP_NAME} ===")
    print(f"Target ONT: {config.ONT_SCHEME}://{config.ONT_HOST}:{config.ONT_PORT}")
    print()

    print("[1/4] Generating SSL certificates...")
    ca_key, ca_cert = cert_manager.ensure_certificates()
    print(f"  CA cert: {config.CA_CERT_FILE}")
    print(f"  Server cert: {config.SERVER_CERT_FILE}")
    print()

    if args.install_cert:
        print("[2/4] Installing CA certificate in Windows root store...")
        cert_manager.install_ca_cert_windows()
        print()
    else:
        print("[2/4] Skipping CA certificate installation (use --install-cert)")
        print()

    if args.chrome:
        print("[3/4] Configuring Chrome proxy profile...")
        profile_dir = chrome_profile.create_proxy_profile()
        print(f"  Profile: {profile_dir}")
        pac_path = chrome_profile.generate_pac_file()
        print(f"  PAC file: {pac_path}")
        print()
    else:
        print("[3/4] Skipping Chrome setup (use --chrome)")
        print()

    print("[4/4] Starting proxy server...")
    print(f"  Configure your browser proxy to: {config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT}")
    print(f"  Or navigate to: http://{config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT}/")
    print()

    if args.chrome and args.launch_chrome:
        chrome_profile.launch_chrome_with_proxy()

    proxy_server.start_proxy(use_ssl=args.ssl)


def cmd_cert(args):
    setup_logging(args.verbose)

    if args.action == "generate":
        ca_key, ca_cert = cert_manager.generate_ca_key_and_cert()
        cert_manager.generate_server_cert(ca_key, ca_cert)
        print(f"Certificates generated in {config.CERT_DIR}")

    elif args.action == "install":
        cert_manager.ensure_certificates()
        cert_manager.install_ca_cert_windows()

    elif args.action == "uninstall":
        cert_manager.uninstall_ca_cert_windows()


def cmd_chrome(args):
    setup_logging(args.verbose)

    if args.action == "profile":
        profile_dir = chrome_profile.create_proxy_profile()
        print(f"Chrome profile created: {profile_dir}")

    elif args.action == "launch":
        cert_manager.ensure_certificates()
        chrome_profile.create_proxy_profile()
        chrome_profile.launch_chrome_with_proxy()

    elif args.action == "pac":
        pac_path = chrome_profile.generate_pac_file()
        print(f"PAC file: {pac_path}")

    elif args.action == "set-proxy":
        chrome_profile.configure_windows_proxy()

    elif args.action == "reset-proxy":
        chrome_profile.reset_windows_proxy()


def cmd_cleanup(args):
    setup_logging(args.verbose)
    cert_manager.uninstall_ca_cert_windows()
    chrome_profile.reset_windows_proxy()
    print("Cleanup complete")


def main():
    parser = argparse.ArgumentParser(
        prog="ont_proxy",
        description=f"MITM Proxy for Huawei ONT ({config.ISP_NAME}) - Unlocks hidden admin menus",
    )
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument("--ont-host", default=None, help=f"ONT IP (default: {config.ONT_HOST})")
    parser.add_argument("--port", type=int, default=None, help=f"Proxy port (default: {config.PROXY_LISTEN_PORT})")

    subparsers = parser.add_subparsers(dest="command")

    p_start = subparsers.add_parser("start", help="Start the proxy server")
    p_start.add_argument("--install-cert", action="store_true", help="Install CA cert in Windows root store")
    p_start.add_argument("--chrome", action="store_true", help="Configure Chrome proxy profile")
    p_start.add_argument("--launch-chrome", action="store_true", help="Launch Chrome with proxy")
    p_start.add_argument("--ssl", action="store_true", help="Enable SSL on proxy listener")
    p_start.set_defaults(func=cmd_start)

    p_cert = subparsers.add_parser("cert", help="Manage SSL certificates")
    p_cert.add_argument("action", choices=["generate", "install", "uninstall"])
    p_cert.set_defaults(func=cmd_cert)

    p_chrome = subparsers.add_parser("chrome", help="Manage Chrome profile")
    p_chrome.add_argument("action", choices=["profile", "launch", "pac", "set-proxy", "reset-proxy"])
    p_chrome.set_defaults(func=cmd_chrome)

    p_cleanup = subparsers.add_parser("cleanup", help="Remove certificates and reset proxy settings")
    p_cleanup.set_defaults(func=cmd_cleanup)

    args = parser.parse_args()

    if args.ont_host:
        config.ONT_HOST = args.ont_host
        config.SERVER_COMMON_NAME = args.ont_host
    if args.port:
        config.PROXY_LISTEN_PORT = args.port

    if not args.command:
        parser.print_help()
        sys.exit(1)

    args.func(args)


if __name__ == "__main__":
    main()
