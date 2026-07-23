from pathlib import Path
import shutil

file = Path("source/features/cli.asm")
backup = Path("source/features/cli.asm.shell_v1_1.bak")

if not backup.exists():
    shutil.copy(file, backup)

text = file.read_text()

# Add ABOUT command check
old = "\tmov di, help_string\t\t; 'HELP' entered?\n\tcall os_string_compare\n\tjc near print_help"

new = old + """

\tmov di, about_string\t\t; 'ABOUT' entered?
\tcall os_string_compare
\tjc near print_about
"""

if old in text and "about_string" not in text:
    text = text.replace(old, new, 1)


# Add CLEAR command check
old = "\tmov di, cls_string\t\t; 'CLS' entered?\n\tcall os_string_compare\n\tjc near clear_screen"

new = old + """

\tmov di, clear_string\t\t; 'CLEAR' entered?
\tcall os_string_compare
\tjc near clear_screen
"""

if old in text and "clear_string" not in text:
    text = text.replace(old, new, 1)


# Add print_about
old = "print_help:\n\tmov si, help_text\n\tcall os_print_string\n\tjmp get_cmd"

new = old + """

print_about:
\tmov si, about_text
\tcall os_print_string
\tjmp get_cmd
"""

if old in text and "print_about:" not in text:
    text = text.replace(old, new, 1)


# Change prompt
text = text.replace(
"\tprompt                  db '> ', 0",
"\tprompt                  db 'NovaOS> ', 0"
)


# Change help
text = text.replace(
"Commands: DIR, COPY, REN, DEL, CAT, SIZE, CLS, HELP, TIME, DATE, VER, EXIT",
"NovaOS Shell Commands:\r\nSYSINFO  System information\r\nABOUT    About NovaOS\r\nCLEAR    Clear screen\r\nDIR      List files\r\nHELP     Help menu\r\nVER      Version\r\nEXIT     Exit shell"
)


# Add strings
old = "\thelp_string             db 'HELP', 0"

new = old + """
\about_string            db 'ABOUT', 0
\tclear_string            db 'CLEAR', 0
"""

if old in text and "about_string" not in text:
    text = text.replace(old, new, 1)


# Add about text
old = "\tversion_msg             db 'NovaOS ', NovaOS_VER, 13, 10, 0"

new = old + """
\tabout_text              db 'NovaOS', 13, 10, 'The Nova Operating System', 13, 10, 'Version 1.1', 13, 10, 0
"""

if old in text and "about_text" not in text:
    text = text.replace(old, new, 1)


file.write_text(text)
print("NovaOS Shell v1.1 patch applied")
