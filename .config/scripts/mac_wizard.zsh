#!/usr/bin/env zsh

# Clear the screen and set up the terminal
clear

# Function to handle terminal setup
setup_terminal() {
    # Save current terminal settings
    old_stty=$(stty -g)
    # Configure terminal for immediate input without enter
    stty raw -echo
}

# Function to restore terminal settings
cleanup_terminal() {
    # Restore original terminal settings
    stty $old_stty
}

# Function to get a single keypress
get_key() {
    local key
    # Read a single character
    key=$(dd bs=1 count=1 2>/dev/null)
    # Convert to lowercase for easier comparison
    echo $key | tr '[:upper:]' '[:lower:]'
}

# Function to display the welcome message
show_welcome() {
    printf "Welcome to Mac Wizard!\r\n"
    printf "======================\r\n"
    printf "\r\n"
    printf "This wizard will help you configure your Mac environment.\r\n"
    printf "\r\n"
    printf "Press [enter] or [y] to continue, [n] or [q] to quit...\r\n"
}

# Function to get latest Python stable version
get_latest_python_version() {
    # Fetch Python releases from endoflife.date API
    local releases=$(curl -s 'https://endoflife.date/api/python.json')
    
    # Parse the JSON to find the latest stable version with longest support
    local latest_version=$(echo $releases | \
        python3 -c "
import sys, json
releases = json.load(sys.stdin)
# Filter out pre-release versions and sort by release date
stable_releases = [r for r in releases if not r['cycle'].startswith('0')]
# Get the most recent release
latest = stable_releases[0]['latest']
print(latest)
        ")
    
    echo $latest_version
}

# Function to check if specific Python version is installed
is_python_version_installed() {
    local version=$1
    pyenv versions --bare | grep -q "^$version$"
    return $?
}

# Function to get current Python version
get_current_python_version() {
    pyenv version | cut -d' ' -f1
}

# Function to install Python
install_python() {
    printf "Checking latest Python version...\r\n"
    local python_version=$(get_latest_python_version)
    local current_version=$(get_current_python_version)

    if is_python_version_installed $python_version; then
        printf "Python ${python_version} is already installed\r\n"
        if [[ "$current_version" == "$python_version" ]]; then
            printf "And it's already set as the global version\r\n"
            sleep 1  # Give user time to read the message
            return 0
        else
            printf "Would you like to set Python ${python_version} as global? [y/n]: \r\n"
            while true; do
                local key=$(get_key)
                case "$key" in
                    $'\n'|'y')
                        cleanup_terminal
                        echo "\nSetting Python ${python_version} as global..."
                        pyenv global ${python_version}
                        return 0
                        ;;
                    'n'|'q')
                        cleanup_terminal
                        echo "\nKeeping current Python version..."
                        return 1
                        ;;
                esac
            done
        fi
    else
        printf "Latest Python version is: ${python_version}\r\n"
        printf "\r\n"
        printf "Would you like to install Python ${python_version} using pyenv? [y/n]: \r\n"
        
        while true; do
            local key=$(get_key)
            case "$key" in
                $'\n'|'y')
                    cleanup_terminal
                    echo "\nInstalling Python ${python_version}..."
                    pyenv install ${python_version}
                    pyenv global ${python_version}
                    return 0
                    ;;
                'n'|'q')
                    cleanup_terminal
                    echo "\nSkipping Python installation..."
                    return 1
                    ;;
            esac
        done
    fi
}

# Function to get latest Node.js LTS version
get_latest_node_lts() {
    # Fetch Node.js releases from endoflife.date API
    local releases=$(curl -s 'https://endoflife.date/api/nodejs.json')
    
    # Parse the JSON to find the latest LTS version
    local latest_lts=$(echo $releases | \
        python3 -c "
import sys, json
releases = json.load(sys.stdin)
# Find latest LTS version
lts_releases = [r for r in releases if r.get('lts')]
latest = lts_releases[0]['latest']
print(latest)
        ")
    
    echo $latest_lts
}

# Function to check if specific Node.js version is installed
is_node_version_installed() {
    local version=$1
    fnm list | grep -q "v${version}"
    return $?
}

# Function to get current Node.js version
get_current_node_version() {
    node -v | sed 's/v//'
}

# Function to install Node.js
install_node() {
    printf "Checking Node.js installation...\r\n"
    
    if command -v node >/dev/null 2>&1; then
        local current_version=$(node -v)
        printf "Node.js ${current_version} is currently installed\r\n"
        printf "Would you like to install the latest LTS version? [y/n]: \r\n"
    else
        printf "Node.js is not installed\r\n"
        printf "Would you like to install the latest LTS version? [y/n]: \r\n"
    fi
    
    while true; do
        local key=$(get_key)
        case "$key" in
            $'\n'|'y')
                cleanup_terminal
                echo "\nInstalling latest Node.js LTS version..."
                fnm install --lts
                fnm use lts/latest
                return 0
                ;;
            'n'|'q')
                cleanup_terminal
                echo "\nSkipping Node.js installation..."
                return 1
                ;;
        esac
    done
}

# Function to add cargo env to zshrc
add_cargo_to_zshrc() {
    local cargo_env_line='# Rust environment
source $HOME/.cargo/env
    '
    local zshrc="$HOME/.zshrc"
    
    # Check if the line already exists in .zshrc
    if ! grep -Fxq "$cargo_env_line" "$zshrc"; then
        printf "\nAdding Cargo environment to .zshrc...\r\n"
        echo "$cargo_env_line" >> "$zshrc"
    else
        printf "Cargo environment already configured in .zshrc\r\n"
    fi
}

# Function to install Rust
install_rust() {
    printf "Checking Rust installation...\r\n"
    
    if command -v rustc >/dev/null 2>&1; then
        local current_version=$(rustc --version | cut -d' ' -f2)
        printf "Rust ${current_version} is currently installed\r\n"
        printf "Would you like to update Rust to the latest version? [y/n]: \r\n"
    else
        printf "Rust is not installed\r\n"
        printf "Would you like to install Rust using rustup? [y/n]: \r\n"
    fi
    
    while true; do
        local key=$(get_key)
        case "$key" in
            $'\n'|'y')
                cleanup_terminal
                if command -v rustc >/dev/null 2>&1; then
                    echo "\nUpdating Rust..."
                    rustup update stable
                else
                    echo "\nInstalling Rust..."
                    # Restore terminal settings before running rustup script
                    cleanup_terminal
                    # Run the rustup installer
                    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                    # Re-enter raw mode after installation
                    setup_terminal
                fi
                add_cargo_to_zshrc
                return 0
                ;;
            'n'|'q')
                cleanup_terminal
                echo "\nSkipping Rust installation..."
                return 1
                ;;
        esac
    done
}

# Function to install Brewfile
install_brewfile() {
    local cloud_brewfile="$HOME/.config/brewfiles/cloud/brewfile"
    local entertainment_brewfile="$HOME/.config/brewfiles/entertainment/brewfile"
    
    printf "Checking Brewfiles...\r\n"
    
    # Handle cloud Brewfile
    if [[ -f "$cloud_brewfile" ]]; then
        printf "Found Cloud Brewfile at ${cloud_brewfile}\r\n"
        printf "Would you like to install packages from Cloud Brewfile? [y/n]: \r\n"
        
        while true; do
            local key=$(get_key)
            case "$key" in
                $'\n'|'y')
                    cleanup_terminal
                    echo "\nInstalling packages from Cloud Brewfile..."
                    cleanup_terminal
                    brew bundle --file="$cloud_brewfile"
                    setup_terminal
                    break
                    ;;
                'n'|'q')
                    cleanup_terminal
                    echo "\nSkipping Cloud Brewfile installation..."
                    break
                    ;;
            esac
        done
    else
        printf "Cloud Brewfile not found at ${cloud_brewfile}\r\n"
        sleep 1
    fi

    printf "\r\n"  # Add spacing between installations

    # Handle entertainment Brewfile
    if [[ -f "$entertainment_brewfile" ]]; then
        printf "Found Entertainment Brewfile at ${entertainment_brewfile}\r\n"
        printf "Would you like to install packages from Entertainment Brewfile? [y/n]: \r\n"
        
        while true; do
            local key=$(get_key)
            case "$key" in
                $'\n'|'y')
                    cleanup_terminal
                    echo "\nInstalling packages from Entertainment Brewfile..."
                    cleanup_terminal
                    brew bundle --file="$entertainment_brewfile"
                    setup_terminal
                    break
                    ;;
                'n'|'q')
                    cleanup_terminal
                    echo "\nSkipping Entertainment Brewfile installation..."
                    break
                    ;;
            esac
        done
    else
        printf "Entertainment Brewfile not found at ${entertainment_brewfile}\r\n"
        sleep 1
    fi
}

# Main wizard function
main() {
    setup_terminal
    
    # Set trap to ensure terminal settings are restored on exit
    trap cleanup_terminal EXIT INT TERM

    show_welcome
    
    while true; do
        local key=$(get_key)
        case "$key" in
            $'\n'|'y')
                cleanup_terminal
                echo "\nStarting configuration..."
                install_python
                install_node
                install_rust
                install_brewfile
                return 0
                ;;
            'n'|'q')
                cleanup_terminal
                echo "\nExiting wizard..."
                return 1
                ;;
        esac
    done
}

# Run the wizard
main
