#!/bin/bash

set -e

detect_arch() {
    local arch=$(uname -m)
    local os=$(uname -s)
    
    # Detect OS first
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

# Need yadm, git, ansible


install_dependencies_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y yadm git ansible
}

install_dependencies_opensuse() {
    sudo zypper refresh
    sudo zypper install -y yadm git ansible
}

install_dependencies_arch() {
    sudo pacman -Syu --noconfirm yadm git ansible
}

install_dependencies_darwin() {
    xcode-select -p &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Command Line Tools for Xcode not found. Installing from softwareupdate…"
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
        PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
        softwareupdate -i "$PROD" --verbose;
    else
        echo "Command Line Tools for Xcode have been installed."
    fi

    # Install homebrew
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$USER/.zprofile
        eval $(/opt/homebrew/bin/brew shellenv)
    fi

    # Install yadm and ansible
    brew install yadm ansible
}

detect_arch

# If linux, detect distribution and install dependencies
if [ "$OS" == "linux" ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$NAME
        if [[ $ID == "ubuntu" ]]; then
            echo "Ubuntu detected, installing dependencies for ubuntu"
            IS_UBUNTU=1
            install_dependencies_ubuntu
        elif [[ $ID == "opensuse" ]]; then
            echo "openSUSE detected, installing dependencies for opensuse"
            IS_OPENSUSE=1
            install_dependencies_opensuse
        elif [[ $ID == "arch" ]]; then
            echo "Arch Linux detected, installing dependencies for arch"
            IS_ARCH=1
            install_dependencies_arch
        fi
    else
        echo "Could not detect Linux distribution"
        exit 1
    fi
fi

# If darwin, install dependencies
if [ "$OS" == "darwin" ]; then
    echo "Darwin detected, installing dependencies for darwin"
    IS_DARWIN=1
    install_dependencies_darwin
fi

yadm clone https://github.com/clive2000/dotfiles.git --no-bootstrap
yadm bootstrap
