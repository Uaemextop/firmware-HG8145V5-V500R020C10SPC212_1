import json
import os
import pathlib
import shutil
import subprocess
import sys

from . import config


def _get_chrome_user_data_dir():
    if sys.platform == "win32":
        return pathlib.Path(os.environ.get("LOCALAPPDATA", "")) / "Google" / "Chrome" / "User Data"
    elif sys.platform == "darwin":
        return pathlib.Path.home() / "Library" / "Application Support" / "Google" / "Chrome"
    return pathlib.Path.home() / ".config" / "google-chrome"


def _find_chrome_executable():
    candidates_win = [
        pathlib.Path(os.environ.get("PROGRAMFILES", "")) / "Google" / "Chrome" / "Application" / "chrome.exe",
        pathlib.Path(os.environ.get("PROGRAMFILES(X86)", "")) / "Google" / "Chrome" / "Application" / "chrome.exe",
        pathlib.Path(os.environ.get("LOCALAPPDATA", "")) / "Google" / "Chrome" / "Application" / "chrome.exe",
    ]
    candidates_linux = ["/usr/bin/google-chrome", "/usr/bin/chromium-browser", "/usr/bin/chromium"]
    candidates_mac = ["/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"]

    if sys.platform == "win32":
        candidates = candidates_win
    elif sys.platform == "darwin":
        candidates = [pathlib.Path(c) for c in candidates_mac]
    else:
        candidates = [pathlib.Path(c) for c in candidates_linux]

    for candidate in candidates:
        if candidate.exists():
            return str(candidate)

    chrome_in_path = shutil.which("chrome") or shutil.which("google-chrome") or shutil.which("chromium")
    return chrome_in_path


def create_proxy_profile():
    user_data_dir = _get_chrome_user_data_dir()
    profile_dir = user_data_dir / config.CHROME_PROFILE_NAME

    profile_dir.mkdir(parents=True, exist_ok=True)

    prefs = {
        "profile": {
            "name": f"ONT Proxy - {config.ISP_NAME}",
        },
        "proxy": {
            "mode": "fixed_servers",
            "server": f"https={config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT};http={config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT}",
            "bypass_list": "localhost,127.0.0.1",
        },
    }

    prefs_file = profile_dir / "Preferences"
    if prefs_file.exists():
        existing = json.loads(prefs_file.read_text(encoding="utf-8"))
        existing.update(prefs)
        prefs = existing

    prefs_file.write_text(json.dumps(prefs, indent=2), encoding="utf-8")
    return profile_dir


def launch_chrome_with_proxy():
    chrome_exe = _find_chrome_executable()
    if not chrome_exe:
        print("[chrome] Chrome executable not found")
        return None

    proxy_server = f"{config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT}"
    user_data_dir = _get_chrome_user_data_dir()

    args = [
        chrome_exe,
        f"--proxy-server=http://{proxy_server}",
        f"--user-data-dir={user_data_dir}",
        f"--profile-directory={config.CHROME_PROFILE_NAME}",
        "--ignore-certificate-errors",
        "--allow-insecure-localhost",
        f"--host-resolver-rules=MAP {config.ONT_HOST} {config.PROXY_LISTEN_HOST}",
        f"http://{config.ONT_HOST}/",
    ]

    print(f"[chrome] Launching: {' '.join(args)}")

    try:
        proc = subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return proc
    except FileNotFoundError:
        print(f"[chrome] Could not launch Chrome at: {chrome_exe}")
        return None


def generate_pac_file():
    pac_content = f"""function FindProxyForURL(url, host) {{
    if (host === "{config.ONT_HOST}" || dnsDomainIs(host, "{config.ONT_HOST}")) {{
        return "PROXY {config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT}";
    }}
    return "DIRECT";
}}
"""
    pac_path = config.BASE_DIR / "proxy.pac"
    pac_path.write_text(pac_content, encoding="utf-8")
    return pac_path


def configure_windows_proxy():
    if sys.platform != "win32":
        print("[chrome] Not on Windows, skipping system proxy configuration")
        pac_path = generate_pac_file()
        print(f"[chrome] PAC file generated: {pac_path}")
        return False

    proxy_addr = f"{config.PROXY_LISTEN_HOST}:{config.PROXY_LISTEN_PORT}"

    ps_commands = [
        f'Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" -Name ProxyEnable -Value 1',
        f'Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" -Name ProxyServer -Value "{proxy_addr}"',
        f'Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" -Name ProxyOverride -Value "localhost;127.0.0.1"',
    ]

    try:
        for cmd in ps_commands:
            subprocess.run(["powershell", "-Command", cmd], capture_output=True, check=True)
        print(f"[chrome] Windows proxy set to {proxy_addr}")
        return True
    except subprocess.CalledProcessError as exc:
        print(f"[chrome] Failed to configure Windows proxy: {exc.stderr}")
        return False


def reset_windows_proxy():
    if sys.platform != "win32":
        return False

    ps_cmd = 'Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" -Name ProxyEnable -Value 0'
    try:
        subprocess.run(["powershell", "-Command", ps_cmd], capture_output=True, check=True)
        print("[chrome] Windows proxy disabled")
        return True
    except subprocess.CalledProcessError:
        return False
