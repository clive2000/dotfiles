# xhuang's dotfiles

Configuration files managed with [chezmoi](https://www.chezmoi.io/).

For machine provisioning (software installation), see [provision](https://github.com/clive2000/provision).

## Quick Start

### Apply dotfiles only

```bash
# One-liner (installs chezmoi and applies dotfiles)
curl -sL https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/main/run.sh | bash

# Or if chezmoi is already installed:
chezmoi init --apply clive2000
```

### Full machine setup (provisioning + dotfiles)

```bash
# Uses the provision repo's bootstrap script
curl -sL https://raw.githubusercontent.com/clive2000/provision/refs/heads/main/run.sh | bash
```

## What's Included

| Config | Source | Destination |
|--------|--------|-------------|
| Powerlevel10k | `dot_p10k.zsh` | `~/.p10k.zsh` |
| Shell aliases | `dot_config/aliases/shell.zsh` | `~/.config/aliases/shell.zsh` |
| Ghostty | `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| Zellij | `dot_config/zellij/config.kdl` | `~/.config/zellij/config.kdl` |
| Git config | `run_once_after_90` | `~/.gitconfig` (user.name/email) |

## Update Dotfiles

```bash
chezmoi update
```

## Add New Dotfiles

```bash
chezmoi add ~/.some-config-file
chezmoi cd
git add . && git commit -m "Add some-config-file" && git push
```

## Related

- **[provision](https://github.com/clive2000/provision)** — Machine provisioning with Ansible
