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
