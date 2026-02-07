# xhuang's dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) and provisioned with [Ansible](https://www.ansible.com/).

## Quick Start (Fresh Machine)

### One-liner install

Using curl:
```bash
curl -sL https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/chezmoi/run.sh | bash
```

Using wget:
```bash
wget -qO- https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/chezmoi/run.sh | bash
```

This will:
1. Install prerequisites (Xcode CLI tools on macOS, git on Linux)
2. Install Homebrew (macOS only)
3. Install chezmoi
4. Clone and apply dotfiles
5. Run Ansible playbook to provision the machine
6. Configure git with your name and email

### Alternative: Direct chezmoi (if chezmoi is already installed)

```bash
chezmoi init --apply clive2000
```

## Manual Ansible Playbook

To re-run the Ansible playbook manually:

```bash
cd ~/.config/ansible_playbooks
ansible-playbook -v -i inventory.ini playbook.yml --become --ask-become-pass -e "ansible_user_name=$USER"
```

## Supported Platforms

| Platform | Terminal Emulator | Notes |
|----------|-------------------|-------|
| macOS (Apple Silicon) | Ghostty | Homebrew cask |
| Arch Linux | Ghostty | Official repos |
| openSUSE Tumbleweed | Ghostty | Official repos |
| Ubuntu | System default | Uses default terminal |

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