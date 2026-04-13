# AGENTS.md

This file provides guidance to AI coding agents (e.g. OpenAI Codex, Cursor, etc.) when working with code in this repository.

## Mandatory Rules

> ⚠️ **RULE: All changes MUST be made in a feature branch.**
> Never commit directly to `main` (or `chezmoi`, or any other trunk branch).
> Always create a dedicated feature branch before making any edits, e.g.:
> ```bash
> git checkout -b feature/<short-description>
> ```
> Open a pull request to merge the feature branch back into the trunk branch when the work is complete.

## Overview

This is a cross-platform dotfiles repository using **chezmoi** for dotfile management. It manages **configuration files only** — software provisioning is handled separately by the [provision](https://github.com/clive2000/provision) repo.

## Supported Platforms

| Platform | Notes |
|----------|-------|
| macOS (Apple Silicon) | Homebrew |
| Arch Linux | Official repos |
| openSUSE Tumbleweed | Official repos |
| Ubuntu | apt |

## Key Commands

### Apply dotfiles
```bash
# One-liner install (installs chezmoi and applies dotfiles)
curl -sL https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/main/run.sh | bash

# Or if chezmoi is already installed:
chezmoi init --apply clive2000

# Re-apply after changes:
chezmoi apply
```

### Full machine setup (provisioning + dotfiles)
```bash
# Use the provision repo's bootstrap script:
curl -sL https://raw.githubusercontent.com/clive2000/provision/refs/heads/main/run.sh | bash
```

## Architecture

### Dotfiles Flow
```
chezmoi init --apply clive2000
    → prompts for git name/email (.chezmoi.toml.tmpl)
    → applies dotfiles (dot_p10k.zsh → ~/.p10k.zsh, etc.)
    → run_once_after_90-configure-git.sh.tmpl
        → git config setup
```

### Chezmoi File Naming Conventions
- `dot_` prefix → becomes `.` (e.g., `dot_p10k.zsh` → `~/.p10k.zsh`)
- `dot_config/` → `~/.config/`
- `.tmpl` suffix → processed as Go template
- `run_once_after_*` → scripts that run once after applying dotfiles

## Configuration Files

- `dot_p10k.zsh` → `~/.p10k.zsh` - Powerlevel10k prompt theme
- `dot_config/aliases/shell.zsh` → `~/.config/aliases/shell.zsh` - Custom shell aliases
- `dot_config/ghostty/config` → `~/.config/ghostty/config` - Ghostty terminal
- `dot_config/zellij/config.kdl` → `~/.config/zellij/config.kdl` - Zellij multiplexer

## Chezmoi Source Directory Structure

```
/                                    # This repo = chezmoi source
├── .chezmoi.toml.tmpl               # Config template (prompts for git name/email)
├── .chezmoiignore                   # Files to not deploy to $HOME
├── .chezmoiscripts/
│   └── run_once_after_90-configure-git.sh.tmpl
├── dot_p10k.zsh                     # → ~/.p10k.zsh
├── dot_config/                      # → ~/.config/
│   ├── aliases/shell.zsh
│   ├── ghostty/config
│   └── zellij/config.kdl
├── run.sh                           # Dotfiles-only bootstrap (not deployed)
├── README.md                        # Documentation (not deployed)
├── CLAUDE.md                        # Guidance for Claude Code (not deployed)
└── AGENTS.md                        # This file (not deployed)
```

## Related

- **[provision](https://github.com/clive2000/provision)** — Machine provisioning with Ansible (software installation)
