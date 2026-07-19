from pathlib import Path
import shutil

file = Path("source/features/cli.asm")

backup = Path("source/features/cli.asm.sysinfo_command.bak")

if not backup.exists():
    shutil.copy(file, backup)

text = file.read_text()

if "print_sysinfo:" in text:
    print("SYSINFO command already exists")
    raise SystemExit

old = "\tmov di, ver_string\t\t; 'VER' entered?\n\tcall os_string_compare\n\tjc near print_ver"

new = old + "\n\n\tmov di, sysinfo_string\t\t; 'SYSINFO' entered?\n\tcall os_string_compare\n\tjc near print_sysinfo"

if old not in text:
    print("VER command block not found")
    raise SystemExit

text = text.replace(old, new, 1)

old2 = "print_ver:\n\tmov si, version_msg\n\tcall os_print_string\n\tjmp get_cmd"

new2 = old2 + "\n\n\nprint_sysinfo:\n\tmov si, sysinfo_text\n\tcall os_print_string\n\tjmp get_cmd"

if old2 not in text:
    print("print_ver block not found")
    raise SystemExit

text = text.replace(old2, new2, 1)

old3 = "\tver_string\t\tdb 'VER', 0"

new3 = old3 + "\n\tsysinfo_string\t\tdb 'SYSINFO', 0"

if old3 not in text:
    print("ver_string not found")
    raise SystemExit

text = text.replace(old3, new3, 1)

file.write_text(text)
print("SYSINFO command added")
