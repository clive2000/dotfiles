# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform dotfiles repository using **chezmoi** for dotfile management with **Ansible** for automated provisioning.

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
# One-liner install (installs chezmoi and applies dotfiles)
curl -sL https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/chezmoi/run.sh | bash

# Or if chezmoi is already installed:
chezmoi init --apply clive2000
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
    → installs chezmoi + dependencies (Xcode CLI, Homebrew, git)
    → chezmoi init --apply clive2000
        → prompts for git name/email (.chezmoi.toml.tmpl)
        → run_once_before_10-install-dependencies.sh.tmpl
            → installs Ansible
            → runs ansible-playbook (provisions machine)
        → applies dotfiles (dot_p10k.zsh → ~/.p10k.zsh, etc.)
        → run_once_after_90-configure-git.sh.tmpl
            → git config setup
```

### Chezmoi File Naming Conventions
- `dot_` prefix → becomes `.` (e.g., `dot_p10k.zsh` → `~/.p10k.zsh`)
- `dot_config/` → `~/.config/`
- `.tmpl` suffix → processed as Go template
- `run_once_before_*` → scripts that run once before applying dotfiles
- `run_once_after_*` → scripts that run once after applying dotfiles

### Ansible Roles (in `dot_config/ansible_playbooks/roles/`)
| Role | Purpose |
|------|---------|
| `common` | Base packages, Oh My Zsh, Powerlevel10k, vim, zsh config |
| `docker` | Docker installation |
| `github_cli` | GitHub CLI with GPG signing |
| `terminal_emulator` | Ghostty (macOS/Arch/openSUSE), no-op on Ubuntu |
| `terminal_tools` | Modern CLI utilities via Homebrew/apt/zypper/pacman |
| `vscode` | VS Code and Cursor editors |
| `llm_agents` | LLM-related tools |

### Brewfiles (in `dot_config/brewfiles/`)
Modular Homebrew bundles: `minimal/`, `coding/`, `cloud/`, `entertainment/`. They are available for manual installation but not currently enforced by the main playbook.

## Configuration Files

- `dot_p10k.zsh` → `~/.p10k.zsh` - Powerlevel10k prompt theme
- `dot_config/aliases/shell.zsh` → `~/.config/aliases/shell.zsh` - Custom shell aliases
- `dot_config/ghostty/config` → `~/.config/ghostty/config` - Ghostty terminal

## Chezmoi Source Directory Structure

```
/                                    # This repo = chezmoi source
├── .chezmoi.toml.tmpl               # Config template (prompts for git name/email)
├── .chezmoiignore                   # Files to not deploy to $HOME
├── .chezmoiscripts/                 # Run-once scripts
│   ├── run_once_before_10-install-dependencies.sh.tmpl
│   └── run_once_after_90-configure-git.sh.tmpl
├── dot_p10k.zsh                     # → ~/.p10k.zsh
├── dot_config/                      # → ~/.config/
│   ├── aliases/shell.zsh
│   ├── ansible_playbooks/           # Ansible provisioning (unchanged)
│   ├── brewfiles/
│   └── ghostty/config
├── run.sh                           # Bootstrap entry point (not deployed)
├── README.md                        # Documentation (not deployed)
└── CLAUDE.md                        # This file (not deployed)
```
