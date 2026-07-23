from pathlib import Path
import shutil

file = Path("source/features/cli.asm")

backup = Path("source/features/cli.asm.sysinfo.bak")

if not backup.exists():
    shutil.copy(file, backup)

text = file.read_text()

if "sysinfo_text" in text:
    print("SYSINFO text already exists")
    raise SystemExit

old = "version_msg\t\tdb 'NovaOS ', NovaOS_VER, 13, 10, 0"

new = old + "\n\nsysinfo_text\tdb 'NovaOS 1.0', 13, 10, 'Architecture: x86', 13, 10, 'Kernel: Nova Kernel', 13, 10, 0"

if old not in text:
    print("Target not found again")
else:
    text = text.replace(old, new, 1)
    file.write_text(text)
    print("SYSINFO text added")
