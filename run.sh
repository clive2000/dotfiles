#!/bin/bash

# Apply dotfiles only. For full machine provisioning, use:
# https://github.com/clive2000/provision

set -e

GITHUB_USERNAME="clive2000"

install_chezmoi() {
    if ! command -v chezmoi >/dev/null 2>&1; then
        echo "Installing chezmoi..."
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"
    else
        echo "chezmoi is already installed."
    fi
}

init_chezmoi() {
    echo "Initializing chezmoi with dotfiles..."
    if [ -d "$HOME/.local/share/chezmoi" ]; then
        chezmoi apply
    else
        chezmoi init --apply "$GITHUB_USERNAME"
    fi
}

install_chezmoi
init_chezmoi

echo ""
echo "=============================================="
echo "Dotfiles applied successfully!"
echo ""
echo "For full machine provisioning (software install),"
echo "see: https://github.com/clive2000/provision"
echo "=============================================="
