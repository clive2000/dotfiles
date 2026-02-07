#!/bin/bash

set -e

GITHUB_USERNAME="clive2000"

detect_os() {
    local os=$(uname -s)
    
    case $os in
        Darwin)
            OS="darwin"
            ;;
        Linux)
            OS="linux"
            ;;
        *)
            echo "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

install_xcode_cli_tools() {
    set +e
    xcode-select -p &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Command Line Tools for Xcode not found. Installing from softwareupdate…"
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
        PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
        softwareupdate -i "$PROD" --verbose;
    else
        echo "Command Line Tools for Xcode have been installed."
    fi
    set -e
}

install_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew"
        sudo echo 'Getting sudo session...'
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$USER/.zprofile
        eval $(/opt/homebrew/bin/brew shellenv)
    fi
}

install_git_linux() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ $ID == "ubuntu" ]]; then
            echo "Ubuntu detected, installing git..."
            sudo apt-get update
            sudo apt-get install -y git curl
        elif [[ $ID == "opensuse"* ]]; then
            echo "openSUSE detected, installing git..."
            sudo zypper refresh
            sudo zypper install -y git curl
        elif [[ $ID == "arch" ]]; then
            echo "Arch Linux detected, installing git..."
            sudo pacman -Syu --noconfirm git curl
        else
            echo "Unsupported Linux distribution: $ID"
            echo "Supported distributions: ubuntu, opensuse (Tumbleweed), arch"
            exit 1
        fi
    else
        echo "Could not detect Linux distribution (missing /etc/os-release)"
        exit 1
    fi
}

install_chezmoi() {
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
}

init_chezmoi() {
    echo "Initializing chezmoi with dotfiles..."
    "$HOME/.local/bin/chezmoi" init --apply "$GITHUB_USERNAME"
}

detect_os

if [ "$OS" == "darwin" ]; then
    echo "Darwin detected"
    install_xcode_cli_tools
    install_homebrew
fi

if [ "$OS" == "linux" ]; then
    echo "Linux detected"
    install_git_linux
fi

install_chezmoi
init_chezmoi

echo ""
echo "=============================================="
echo "Dotfiles installed successfully!"
echo ""
echo "chezmoi has been initialized and applied."
echo "Your environment is now configured."
echo "=============================================="
