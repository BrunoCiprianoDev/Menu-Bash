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

**Main packages include:**

- `i3-wm` – lightweight tiling window manager  
- `i3status` – status bar for i3  
- `dmenu` – application launcher for i3  
- `lightdm` & `lightdm-gtk-greeter` – display manager for login  
- `network-manager` & `network-manager-gnome` – network configuration  
- `xfce4-power-manager` – power/battery management  
- `pavucontrol` – audio management  
- `upower` – battery monitoring  
- `thunar` – file manager  
- `gvfs` & `gvfs-backends` – virtual filesystem support  
- `policykit-1` – administrative permissions  

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

# Copy the project to /opt
sudo mkdir -p /opt/bash-menu
sudo cp -r ~/Menu-Bash/* /opt/bash-menu/

# Make the main script executable
sudo chmod +x /opt/bash-menu/main.sh

# Create a symbolic link in /usr/local/bin for global access
sudo ln -s /opt/bash-menu/main.sh /usr/local/bin/bm
