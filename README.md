from pathlib import Path

content = """# 🧰 Bash System Menu

An **interactive Bash menu** designed for **minimalist environments** (i3, pure WMs, X-based servers, Ubuntu/Debian Minimal), with a strong focus on:

- ⚡ **zero bloat**
- 🧠 **full terminal control**
- 🪶 **minimal RAM and CPU usage**
- 🧩 simple integration with window managers like **i3**

This project was born from the idea of replacing **heavy graphical applications** with a **simple, fast, and extensible TUI menu**, written entirely in Bash.

---

## ✨ Features

- 🔋 Battery status visualization
- 📶 Wi-Fi management via `nmcli`
  - list available networks
  - connect / switch networks
- 🌐 Network information (interfaces, IP)
- ⌨️ Keyboard-driven menu
- 🧱 Simple and easy-to-modify structure

---

## 🎯 Purpose

To create a **practical and lightweight tool** for everyday tasks while avoiding dependencies on:

- full desktop environments (XFCE, GNOME, KDE)
- memory-resident applets
- unnecessary menus and daemons

Ideal for users of:
- i3 / sway
- minimalist setups
- older hardware
- or anyone who prefers **terminal-first control**

---

## 📦 Dependencies

Minimal dependencies (may vary depending on enabled modules):

- `bash`
- `acpi`
- `network-manager` (`nmcli`)
- `iproute2`

Optional:
- `fzf` (for advanced interactive menus)

---

## 🚀 Usage

```bash
chmod +x menu.sh
./menu.sh
