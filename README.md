<<<<<<< HEAD
MikeOS
======

Open source 16-bit operating system for x86 PCs
-----------------------------------------------

```
Copyright (C) 2006 - 2014 MikeOS Developers -- see doc/LICENSE.TXT
```

MikeOS is a 16-bit real mode operating system for x86-compatible PCs, 
written entirely in assembly language, which boots from a floppy disk,
CD-ROM or USB key. It features a text-based dialog-driven user
interface, a command-line, support for FAT12 (MS-DOS-like) floppy
disks, sound (PC speaker), text editor, BASIC interpreter and more.
The kernel includes over 60 system calls.

MikeOS is a learning tool for those wishing to understand simple OS 
construction and x86 assembly. Quick getting-started guide: MikeOS can 
run from a floppy disk or CD-ROM, either on an emulator or a real PC. 
See the disk_images/ directory for files that you can write to the 
appropriate media or boot in, for instance, VMware, QEMU or VirtualBox.

You can find the source code in the source/ directory, and sample 
programs (included on the disk images) in the programs/ directory.
See the doc/ directory for more info, including:

- [handbook-user.html](doc/handbook-user.html) -- How to run and use MikeOS

- [handbook-appdev-basic.html](doc/handbook-appdev-basic.html) -- Writing software in BASIC
- [handbook-appdev-asm.html](doc/handbook-appdev-asm.html) -- Writing software in assembly
- [handbook-sysdev.html](doc/handbook-sysdev.html) -- Building and modifying the OS

- [LICENSE.TXT](doc/LICENSE.TXT) -- The open source, BSD-like license
- [CHANGES.TXT](doc/CHANGES.TXT) -- Detailed list of changes in previous releases
- [CREDITS.TXT](doc/CREDITS.TXT) -- People involved in the project

Have fun, and see the [website](http://mikeos.sourceforge.net)

[Mike Saunders](mailto:okachi@gmail.com)

=======
# NovaOS

**A 16-bit hobby operating system written in Assembly and C.**

NovaOS is a simple, educational operating system inspired by MikeOS. It's designed to run in 16-bit real mode and includes a command-line interface, a BASIC interpreter, and a simple graphical launcher.

## ✨ Features

*   **16-bit Real Mode**: Runs on standard x86 PCs.
*   **Command-Line Interface (CLI)**: A fully functional shell with built-in commands like `DIR`, `CAT`, `COPY`, and `DEL`.
*   **BASIC Interpreter**: Write and run BASIC programs directly from the OS.
*   **Simple File Manager**: Manage files on a FAT12 floppy disk image.
*   **NovaPad**: A basic text editor.
*   **Modular Design**: The kernel is separated into logical components (features, drivers, UI).

## 🛠️ Build & Run

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/danieldevir/NovaOS.git
    cd NovaOS
    ```

2.  **Assemble the kernel (requires NASM):**
    ```bash
    nasm -f bin source/kernel.asm -o kernel.bin
    ```

3.  **Create a bootable disk image (using a pre-built disk image or your own):**
    *(Detailed instructions for creating a bootable image will be added soon.)*

4.  **Run in QEMU:**
    ```bash
    qemu-system-x86_64 -fda disk_image.bin
    ```

## 📂 Project Structure

```
NovaOS/
├── source/          # Core kernel and feature source code
│   ├── features/    # System libraries (disk, screen, keyboard, etc.)
│   ├── ui/          # Graphical user interface components
│   └── bootload/    # Bootloader
├── programs/        # User applications (editor, file manager, games)
├── docs/            # Documentation
└── disk_images/     # Pre-built disk images
```

## 🤝 Contributing

Contributions are welcome! If you'd like to help, please feel free to open an issue or submit a pull request. Even an hour of your time can make a difference.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Daniel Baradaran** (11 years old)
*   GitHub: [@danieldevir](https://github.com/danieldevir)
*   Blog: [danieblog.ir](https://danieblog.ir)

---
*Built with passion for learning and the spirit of open source.*
>>>>>>> 80289420843b38744a4e00b365667c0075e69ef6
