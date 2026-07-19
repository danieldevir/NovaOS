from pathlib import Path
import shutil

print("NovaOS Patcher v1.0")

file = Path("source/features/cli.asm")

if not file.exists():
    print("cli.asm not found!")
    raise SystemExit

backup = file.with_suffix(".asm.bak")

if not backup.exists():
    shutil.copy(file, backup)
    print("Backup created:", backup)

print("Ready to patch:", file)
