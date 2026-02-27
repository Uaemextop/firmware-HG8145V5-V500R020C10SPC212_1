# Copilot Instructions — Huawei ONT Firmware

## Reglas estrictas — SIEMPRE aplicar

- **NO** generes archivos de test ni scripts de prueba de ningún tipo.
- **NO** generes archivos de documentación (`.md`, `.txt`, `.rst`, `.adoc` ni ningún otro formato).
- **NO** agregues comentarios en el código (ni `#`, ni `//`, ni `/* */`).
- **NO** modifiques ni crees `README`, `CHANGELOG`, `CONTRIBUTING` ni ningún doc.
- Enfócate **exclusivamente en escribir y modificar código funcional**.
- **NO entres en bucle**: cada solicitud del usuario se resuelve en una sola pasada — ejecuta, entrega el resultado y detente. No repitas análisis, no re-verifiques, no re-confirmes sin que el usuario lo pida.
- **Usa los scripts existentes como herramientas**: si ya existe un script que hace lo que necesitas, impórtalo o ejecútalo directamente. No lo re-analices ni lo reimplementes.
- **Si creas un script nuevo**, úsalo directamente en el mismo paso como herramienta — no crees un script adicional para probarlo ni para validarlo.
- **Analiza antes de modificar**: antes de corregir cualquier error, lee el archivo completo, busca todas las referencias a la función o variable errónea en el resto del repositorio (`grep -r`), comprende qué hace esa función en contexto, identifica la causa raíz del fallo y valida mentalmente la corrección antes de aplicarla.
- **Las nuevas herramientas deben ser genéricas**: si creas una herramienta nueva, prográmala para recibir argumentos (ruta de archivo, parámetros) y funcionar en cualquier contexto o firmware — nunca hardcodees rutas, nombres o valores específicos de un solo caso.
- **Usa las tools nuevas como herramientas reales**: una vez creado un script, úsalo invocándolo con sus argumentos sobre los archivos reales. No lo re-analices en la siguiente sesión ni lo reimplementes; trátalo igual que cualquier otro script.

## Context

This repository contains **extracted content** from a Huawei ONT (Optical Network Terminal) firmware image. Firmware targets HiSilicon ARM Cortex-A9 routers (HG8145V5, EG8145V5, HN8145XR, HG8245C family). HWNP format with `whwh`-wrapped partitions (U-Boot, Linux kernel, SquashFS rootfs). V500 firmwares use musl libc; V300 use uClibc.

Extracted by [HuaweiFirmwareTool](https://github.com/Uaemextop/HuaweiFirmwareTool).

## Extracted Directory Structure

```
web/            → Router web interface (HTML/JS/CSS/ASP)
  frame_huawei/ → Main UI: login.asp, index.asp, main.asp, menuList.asp
  menu/         → Menu*.xml — per-carrier ISP customization flags
configs/        → /etc/wap/ device configuration
  hw_ctree.xml          ← Encrypted main config (AES-256-CBC, header: 01000000)
  hw_default_ctree.xml  ← Encrypted factory defaults
  hw_aes_tree.xml       ← Schema of all encrypted config field paths
  hw_flashcfg.xml       ← Flash/NAND partition layout (plaintext XML)
  hw_boardinfo          ← Board ID, hardware version, MAC addresses
  prvt.key              ← AES-256-CBC encrypted RSA private key
  kmc_store_A/B         ← KMC key material (V500 only; absent on HN8145XR)
  passwd                ← System user accounts and password hashes
bin/            → ARM Linux binaries (full extraction only)
sbin/           → System binaries (full extraction only)
lib/            → Shared libraries (full extraction only)
etc/            → Full /etc from rootfs (full extraction only)
```

## Analysis Tools

| Tool | Usage |
|------|-------|
| **Capstone** | ARM disassembly from Python — `import capstone; md = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)` |
| **radare2** | Interactive binary analysis — `r2 -qc 'aaa; afl' bin/aescrypt2` |
| **r2pipe** | Script radare2 — `import r2pipe; r2 = r2pipe.open('bin/aescrypt2')` |
| **qemu-arm-static** | Execute ARM binaries on x86 — required for `aescrypt2` chroot decryption |
| **unsquashfs** | Extract SquashFS — `unsquashfs -f -d rootfs -no-xattrs -ignore-errors fw.sqfs` |
| **arm-linux-gnueabi-objdump** | ARM disassembly — `arm-linux-gnueabi-objdump -d bin/aescrypt2` |
| **arm-linux-gnueabi-readelf** | ARM ELF inspection — `arm-linux-gnueabi-readelf -a bin/aescrypt2` |
| **xxd** | Hex dump — `xxd -s 0 -l 32 configs/hw_ctree.xml` |

### Capstone Example

```python
import capstone
with open('bin/aescrypt2', 'rb') as f:
    code = f.read()
md = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
md.detail = True
for insn in md.disasm(code[offset:offset+256], base_address + offset):
    print(f"0x{insn.address:08x}: {insn.mnemonic}\t{insn.op_str}")
```

### radare2 Examples

```bash
r2 -qc 'aaa; afl' bin/aescrypt2                                        # list functions
r2 -qc 'aaa; pdf @sym.main' bin/aescrypt2                              # disassemble main
r2 -qc 'aaa; axt @sym.HW_XML_CFGFileSecurity' lib/libhw_ssp_basic.so  # xrefs
r2 -qc 'izz~kmc_store' bin/aescrypt2                                   # search strings
r2 -qc 'aaa; ii' bin/cfgtool                                           # list imports
```

```python
import r2pipe
r2 = r2pipe.open('bin/aescrypt2')
r2.cmd('aaa')
for f in r2.cmdj('aflj'):
    print(f"{f['name']} at 0x{f['offset']:08x} ({f['size']} bytes)")
r2.quit()
```

## hw_ctree.xml Decryption

Encrypted with AES-256-CBC using mbedTLS `aescrypt2` format:
- **Header**: `AEST` magic (4B) + original size (4B) + IV (16B) + ciphertext + HMAC-SHA-256 (32B)
- **Key derivation**: Hardware e-fuse → work key (flash) → PBKDF2 → AES-256-CBC
- **V500** (HG8145V5, EG8145V5): Key from `kmc_store_A`/`kmc_store_B` in `configs/`
- **V300** (HG8145C, HG8245C): Key from `prvt.key` + `EquipKey`
- **HN8145XR**: No `kmc_store` at extraction time — use empty-file fallback (see below)

```bash
# Requires original firmware rootfs + qemu-arm-static chroot

# V500 with kmc_store:
sudo cp /usr/bin/qemu-arm-static rootfs/usr/bin/
sudo chroot rootfs qemu-arm-static /bin/aescrypt2 1 /etc/wap/hw_ctree.xml /tmp/out.xml
gunzip /tmp/out.xml.gz

# HN8145XR fallback — create empty kmc_store files:
mkdir -p rootfs/mnt/jffs2/
touch rootfs/mnt/jffs2/kmc_store_A rootfs/mnt/jffs2/kmc_store_B
sudo chroot rootfs qemu-arm-static /bin/aescrypt2 1 /etc/wap/hw_ctree.xml /tmp/out.xml
gunzip /tmp/out.xml.gz   # → 132,367 B plaintext XML
```

**SquashFS extraction flags** (`-no-xattrs -ignore-errors` required for V300 device nodes):
```bash
unsquashfs -f -d rootfs -no-xattrs -ignore-errors firmware.sqfs
```

## Private Key

All V500 firmwares share identical `prvt.key` (MD5: `0de20c81fc6cf1d0d3607a1bd600f935`, AES-256-CBC PEM, IV: `7EC546FB34CA7CD5599763D8D9AE6AC9`). **Passphrase is NOT a simple string** — derived via `KMC_GetAppointKey → CAC_Pbkdf2Api → PBKDF2` from `kmc_store` material.

## Configuration Files (`configs/` = rootfs `/etc/wap/`)

| File | Description |
|------|-------------|
| `hw_ctree.xml` | Main config tree — AES-encrypted, 1,021+ XML elements |
| `hw_default_ctree.xml` | Factory defaults — same encryption |
| `hw_aes_tree.xml` | Lists all config paths that are individually AES-encrypted |
| `hw_flashcfg.xml` | Flash/NAND partition layout (plaintext) |
| `hw_boardinfo` | Board ID, MAC addresses, hardware version |
| `prvt.key` | Encrypted RSA private key (PEM, AES-256-CBC) |
| `kmc_store_A`/`kmc_store_B` | KMC key material (V500 only) |
| `passwd` | System users — `$1$` = MD5-crypt, `$6$` = SHA-512 |

## Key Configuration XPaths (after decryption)

| XPath (under `/configuration/InternetGatewayDevice/`) | Description |
|-------------------------------------------------------|-------------|
| `X_HW_DEBUG/TelnetSwitch` | Telnet enable (0=off, 1=on) |
| `X_HW_DEBUG/SshSwitch` | SSH enable (0=off, 1=on) |
| `ManagementServer/URL` | TR-069 ACS server URL |
| `ManagementServer/Username` | TR-069 username |
| `WANDevice/.../PPPPassword` | WAN PPPoE password |
| `X_HW_TOKEN` | ISP authentication token |

**Only 17 parameters differ between the 6 firmware variants.** The config tree is otherwise identical.

## Key ARM Binaries

| Binary | Description | Analyze with |
|--------|-------------|--------------|
| `bin/aescrypt2` | Config encryption/decryption (mbedTLS AEST format) | `r2 -A bin/aescrypt2` |
| `bin/cfgtool` | Config management API | `r2 -qc 'aaa; afl' bin/cfgtool` |
| `lib/libhw_ssp_basic.so` | Core security — `HW_XML_CFGFileSecurity`, `HW_XML_GetEncryptedKey` | `arm-linux-gnueabi-readelf -s lib/libhw_ssp_basic.so` |
| `lib/libhw_swm_dll.so` | Firmware signature verification | `r2 -qc 'aaa; ii' lib/libhw_swm_dll.so` |
| `lib/libhw_ssp_ssl.so` | SSL/TLS + KMC key derivation (`CAC_Pbkdf2Api`) | `r2 -qc 'aaa; afl~KMC' lib/libhw_ssp_ssl.so` |
| `lib/libpolarssl.so` | PolarSSL/mbedTLS crypto library | `arm-linux-gnueabi-readelf -s lib/libpolarssl.so` |

## Web Interface

| Path | Description |
|------|-------------|
| `web/frame_huawei/login.asp` | Login page — default user `admin`, `telecomadmin` |
| `web/frame_huawei/index.asp` | Main dashboard |
| `web/frame_huawei/menuList.asp` | Menu structure (references `Menu*.xml`) |
| `web/menu/Menu*.xml` | ISP-specific feature flags and menu visibility |

```bash
# Find hidden/disabled features
grep -r 'hidden\|disabled\|display.*none' web/ -l

# Find telnet/SSH enable pages
grep -ri 'telnet\|ssh\|debug\|diag' web/ -l

# Find JS config API calls
grep -r 'GetValue\|SetValue\|SendGetInfo' web/ -l
```

## Config Flow

1,021+ XML elements, 3,208+ attributes, only 17 differ across firmware variants.

- **Build**: gzip + AES-256-CBC → flash
- **Boot**: decrypt → gunzip → parse XML → `DBInit`
- **Save**: `cfgtool SetPara` → `DBSave` → gzip + AES-256-CBC → flash

Key functions: `HW_CFGTOOL_Get/Set/Add/Del/CloneXMLValByPath`, `HW_XML_CFGFileSecurity`, `HW_XML_CFGFileEncryptWithKey`

## Firmware Signing

Certificate chain: e-fuse root → `app_cert.crt` (4096-bit RSA) → Code Signing CA 2 → Code Signing Cert 3. **No private signing key exists in any binary.** Signature verification: `SWM_Sig_VerifySignature → CmscbbVerify → HW_DM_GetRootPubKeyInfo` (reads e-fuse).

```bash
r2 -qc 'aaa; axt @sym.SWM_Sig_VerifySignature' lib/libhw_swm_dll.so
```
