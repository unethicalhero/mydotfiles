> **Note:** Still working on it...
#  My Arch (BTW) x Hyprland Dotfiles

This repository contains my personal dotfiles and setup scripts designed to quickly configure a fresh Arch-based Linux system.

## Overview

The setup automates:

- Installation of essential and optional packages from both official repositories and the Arch User Repository (AUR).
- Copying of configuration files and directories (`.config` and `.local`) from the repository to your home directory, with user prompts to select which configs to apply.
- Automatic installation of the `yay` AUR helper if it's not already installed.

## Usage

To get started, you can `curl` the setup script directly from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/unethicalhero/mydotfiles/refs/heads/main/setup.sh | bash
```
