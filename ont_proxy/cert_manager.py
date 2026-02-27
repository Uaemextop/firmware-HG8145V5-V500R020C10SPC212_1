import datetime
import ipaddress
import subprocess
import sys

from cryptography import x509
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.x509.oid import NameOID

from . import config


def _ensure_dir(path):
    path.parent.mkdir(parents=True, exist_ok=True)


def generate_ca_key_and_cert():
    _ensure_dir(config.CA_KEY_FILE)

    ca_key = rsa.generate_private_key(public_exponent=65537, key_size=config.CA_KEY_SIZE)

    subject = issuer = x509.Name([
        x509.NameAttribute(NameOID.COUNTRY_NAME, "MX"),
        x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, "Jalisco"),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "ONT Proxy"),
        x509.NameAttribute(NameOID.COMMON_NAME, config.CA_COMMON_NAME),
    ])

    now = datetime.datetime.now(datetime.timezone.utc)
    ca_cert = (
        x509.CertificateBuilder()
        .subject_name(subject)
        .issuer_name(issuer)
        .public_key(ca_key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now)
        .not_valid_after(now + datetime.timedelta(days=config.CERT_DAYS_VALID))
        .add_extension(x509.BasicConstraints(ca=True, path_length=None), critical=True)
        .add_extension(
            x509.KeyUsage(
                digital_signature=True, key_cert_sign=True, crl_sign=True,
                content_commitment=False, key_encipherment=False,
                data_encipherment=False, key_agreement=False,
                encipher_only=False, decipher_only=False,
            ),
            critical=True,
        )
        .sign(ca_key, hashes.SHA256())
    )

    config.CA_KEY_FILE.write_bytes(
        ca_key.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.TraditionalOpenSSL, serialization.NoEncryption())
    )
    config.CA_CERT_FILE.write_bytes(ca_cert.public_bytes(serialization.Encoding.PEM))

    return ca_key, ca_cert


def generate_server_cert(ca_key, ca_cert):
    server_key = rsa.generate_private_key(public_exponent=65537, key_size=config.SERVER_KEY_SIZE)

    subject = x509.Name([
        x509.NameAttribute(NameOID.COMMON_NAME, config.SERVER_COMMON_NAME),
    ])

    san_entries = [x509.DNSName(config.ONT_HOST)]
    try:
        san_entries.append(x509.IPAddress(ipaddress.ip_address(config.ONT_HOST)))
    except ValueError:
        pass

    now = datetime.datetime.now(datetime.timezone.utc)
    server_cert = (
        x509.CertificateBuilder()
        .subject_name(subject)
        .issuer_name(ca_cert.subject)
        .public_key(server_key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now)
        .not_valid_after(now + datetime.timedelta(days=config.CERT_DAYS_VALID))
        .add_extension(x509.SubjectAlternativeName(san_entries), critical=False)
        .add_extension(
            x509.KeyUsage(
                digital_signature=True, key_encipherment=True,
                content_commitment=False, key_cert_sign=False, crl_sign=False,
                data_encipherment=False, key_agreement=False,
                encipher_only=False, decipher_only=False,
            ),
            critical=True,
        )
        .add_extension(
            x509.ExtendedKeyUsage([x509.oid.ExtendedKeyUsageOID.SERVER_AUTH]),
            critical=False,
        )
        .sign(ca_key, hashes.SHA256())
    )

    config.SERVER_KEY_FILE.write_bytes(
        server_key.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.TraditionalOpenSSL, serialization.NoEncryption())
    )
    config.SERVER_CERT_FILE.write_bytes(server_cert.public_bytes(serialization.Encoding.PEM))

    return server_key, server_cert


def ensure_certificates():
    if config.CA_CERT_FILE.exists() and config.SERVER_CERT_FILE.exists():
        ca_cert_pem = config.CA_CERT_FILE.read_bytes()
        ca_key_pem = config.CA_KEY_FILE.read_bytes()
        ca_key = serialization.load_pem_private_key(ca_key_pem, password=None)
        ca_cert = x509.load_pem_x509_certificate(ca_cert_pem)
        return ca_key, ca_cert

    ca_key, ca_cert = generate_ca_key_and_cert()
    generate_server_cert(ca_key, ca_cert)
    return ca_key, ca_cert


def _sanitize_path_for_ps(path_str):
    return path_str.replace("'", "''")


def install_ca_cert_windows():
    cert_path = _sanitize_path_for_ps(str(config.CA_CERT_FILE.resolve()))
    ps_script = (
        f"$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('{cert_path}'); "
        f"$store = New-Object System.Security.Cryptography.X509Certificates.X509Store('Root', 'LocalMachine'); "
        f"$store.Open('ReadWrite'); "
        f"$store.Add($cert); "
        f"$store.Close(); "
        f"Write-Host 'CA certificate installed successfully'"
    )

    if sys.platform != "win32":
        print(f"[cert_manager] Not on Windows. To install manually, run PowerShell as Admin:")
        print(f"  powershell -Command \"{ps_script}\"")
        return False

    try:
        result = subprocess.run(
            ["powershell", "-ExecutionPolicy", "Bypass", "-Command", ps_script],
            capture_output=True, text=True, check=True,
        )
        print(result.stdout.strip())
        return True
    except subprocess.CalledProcessError as exc:
        print(f"[cert_manager] Failed to install CA cert: {exc.stderr}")
        print(f"[cert_manager] Run PowerShell as Administrator and execute:")
        print(f"  powershell -ExecutionPolicy Bypass -Command \"{ps_script}\"")
        return False


def uninstall_ca_cert_windows():
    ps_script = (
        f'$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "LocalMachine"); '
        f'$store.Open("ReadWrite"); '
        f'$certs = $store.Certificates | Where-Object {{ $_.Subject -like "*{config.CA_COMMON_NAME}*" }}; '
        f'foreach ($c in $certs) {{ $store.Remove($c) }}; '
        f'$store.Close(); '
        f'Write-Host "CA certificate removed"'
    )

    if sys.platform != "win32":
        print(f"[cert_manager] Not on Windows. To remove manually, run PowerShell as Admin:")
        print(f"  powershell -Command \"{ps_script}\"")
        return False

    try:
        result = subprocess.run(
            ["powershell", "-ExecutionPolicy", "Bypass", "-Command", ps_script],
            capture_output=True, text=True, check=True,
        )
        print(result.stdout.strip())
        return True
    except subprocess.CalledProcessError as exc:
        print(f"[cert_manager] Failed to remove CA cert: {exc.stderr}")
        return False
