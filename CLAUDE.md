# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform dotfiles repository using **yadm** (Yet Another Dotfiles Manager) with **Ansible** for automated provisioning. It supports macOS and Linux (Ubuntu, openSUSE, Arch).

## Key Commands

### Bootstrap (fresh machine setup)
```bash
# One-liner install
curl -sL https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/master/.config/bootstrap/run.sh | bash

# Manual: clone then bootstrap
yadm clone https://github.com/clive2000/dotfiles.git --no-bootstrap
yadm bootstrap
```

### Run Ansible playbook manually
```bash
cd ~/.config/ansible_playbooks
ansible-playbook -v -i inventory.ini playbook.yml --become --ask-become-pass -e "ansible_user_name=$USER"
```

### Validate Ansible syntax
```bash
ansible-playbook --syntax-check ~/.config/ansible_playbooks/playbook.yml
```

## Architecture

### Bootstrap Flow
```
.config/bootstrap/run.sh
    → installs yadm + dependencies
    → yadm clone (pulls dotfiles to $HOME)
    → yadm bootstrap
        → .config/yadm/bootstrap
            → .config/scripts/install.sh##os.<OS>
                → runs ansible-playbook
                → .config/scripts/post_install.sh##os.<OS>
                    → HCP vault auth, GitHub CLI setup, git config
```

### OS-Specific Files
Files with `##os.Darwin` or `##os.Linux` suffixes are yadm alternates—yadm automatically selects the correct one based on the OS.

### Ansible Roles (in `.config/ansible_playbooks/roles/`)
| Role | Purpose |
|------|---------|
| `common` | Base packages, Oh My Zsh, Powerlevel10k, vim |
| `docker` | Docker installation |
| `github_cli` | GitHub CLI with GPG signing |
| `hcp` | HashiCorp Cloud Platform CLI |
| `terminal_emulator` | Ghostty (macOS) or Wezterm (Linux) |
| `terminal_tools` | Modern CLI utilities via Homebrew |
| `vscode` | VS Code and Cursor editors |

### Brewfiles (in `.config/brewfiles/`)
Modular Homebrew bundles: `minimal/`, `coding/`, `cloud/`, `entertainment/`

### Secrets Management
Uses HashiCorp Cloud Platform (HCP) Vault for:
- `GH_PERSONAL_TOKEN` - GitHub authentication
- `PGP_K_BASE64` - GPG key for git signing

## Configuration Files

- `.p10k.zsh` - Powerlevel10k prompt theme
- `.config/aliases/shell.zsh` - Custom shell aliases
- `.config/alacritty/alacritty.toml` - Alacritty terminal
- `.config/wezterm/wezterm.lua` - Wezterm terminal
- `.config/ghostty/config` - Ghostty terminal
