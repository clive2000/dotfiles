# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform dotfiles repository using **yadm** (Yet Another Dotfiles Manager) with **Ansible** for automated provisioning.

## Supported Platforms

| Platform | Terminal Emulator | Notes |
|----------|-------------------|-------|
| macOS (Apple Silicon) | Ghostty | Homebrew cask |
| Arch Linux | Ghostty | Official repos |
| openSUSE Tumbleweed | Ghostty | Official repos |
| Ubuntu | System default (no-op) | Uses default terminal |

## Key Commands

### Bootstrap (fresh machine setup)
```bash
# One-liner install (prompts user to run yadm bootstrap)
curl -sL https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/master/run.sh | bash

# Then complete setup
yadm bootstrap
```

### Run Ansible playbook manually
```bash
cd ~/.config/ansible_playbooks
# Requires ansible_user_name var
ansible-playbook -v -i inventory.ini playbook.yml --become --ask-become-pass -e "ansible_user_name=$USER"
```

### Validate Ansible syntax
```bash
ansible-playbook --syntax-check ~/.config/ansible_playbooks/playbook.yml
```

## Architecture

### Bootstrap Flow
```
run.sh
    → installs yadm + dependencies
    → yadm clone (pulls dotfiles to $HOME)
    → prompts user to run: yadm bootstrap
        → .config/yadm/bootstrap
            → .config/scripts/install.sh (yadm selects OS variation)
                → runs ansible-playbook
                → .config/scripts/post_install.sh (yadm selects OS variation)
                    → git config setup
```

### OS-Specific Files
Files with `##os.Darwin` or `##os.Linux` suffixes are yadm alternates. Yadm automatically selects the correct one based on the OS during checkout/bootstrap.

### Ansible Roles (in `.config/ansible_playbooks/roles/`)
| Role | Purpose |
|------|---------|
| `common` | Base packages, Oh My Zsh, Powerlevel10k, vim, zsh config |
| `docker` | Docker installation |
| `github_cli` | GitHub CLI with GPG signing |
| `terminal_emulator` | Ghostty (macOS/Arch/openSUSE), no-op on Ubuntu |
| `terminal_tools` | Modern CLI utilities via Homebrew/apt/zypper/pacman |
| `vscode` | VS Code and Cursor editors |

### Brewfiles (in `.config/brewfiles/`)
Modular Homebrew bundles: `minimal/`, `coding/`, `cloud/`, `entertainment/`. They are available for manual installation but not currently enforced by the main playbook.

## Configuration Files

- `.p10k.zsh` - Powerlevel10k prompt theme
- `.config/aliases/shell.zsh` - Custom shell aliases
- `.config/alacritty/alacritty.toml` - Alacritty terminal
- `.config/ghostty/config` - Ghostty terminal (macOS)
