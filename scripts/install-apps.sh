#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Application Installer ===${NC}"
echo -e "${YELLOW}This script will install the latest stable versions of applications referenced in your dotfiles${NC}\n"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package via apt
install_apt() {
    local package="$1"
    if ! dpkg -l | grep -q "^ii  $package "; then
        echo -e "${BLUE}Installing $package via apt...${NC}"
        sudo apt install -y "$package"
    else
        echo -e "${GREEN}$package already installed${NC}"
    fi
}

# Update package lists
echo -e "${BLUE}Updating package lists...${NC}"
sudo apt update

# ============================================
# Core Window Manager & Tools
# ============================================
echo -e "\n${GREEN}=== Installing Core Window Manager Tools ===${NC}"

install_apt "i3"
install_apt "polybar"
install_apt "picom"
install_apt "feh"
install_apt "flameshot"
install_apt "dmenu"
install_apt "i3lock"
install_apt "xss-lock"
install_apt "xinput"
install_apt "x11-xserver-utils" # for xrandr
install_apt "network-manager"
install_apt "network-manager-gnome" # for nm-applet

# ============================================
# Shell & Terminal Tools
# ============================================
echo -e "\n${GREEN}=== Installing Shell & Terminal Tools ===${NC}"

install_apt "zsh"
install_apt "vim"
install_apt "git"
install_apt "curl"
install_apt "wget"
install_apt "tmux"
install_apt "build-essential"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}Installing Oh My Zsh (latest)...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}Oh My Zsh already installed${NC}"
fi

# ============================================
# Alacritty Terminal (via Cargo)
# ============================================
echo -e "\n${GREEN}=== Installing Alacritty ===${NC}"

if ! command_exists alacritty; then
    # Install Rust/Cargo if not present
    if ! command_exists cargo; then
        echo -e "${BLUE}Installing Rust and Cargo (latest stable)...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    # Install Alacritty dependencies
    echo -e "${BLUE}Installing Alacritty dependencies...${NC}"
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 scdoc

    echo -e "${BLUE}Building Alacritty from source (latest stable - this may take a few minutes)...${NC}"
    cargo install alacritty
else
    echo -e "${GREEN}Alacritty already installed${NC}"
fi

# ============================================
# Node.js & Package Managers
# ============================================
echo -e "\n${GREEN}=== Installing Node.js Tools ===${NC}"

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    echo -e "${BLUE}Installing NVM (latest)...${NC}"
    # Get latest NVM version dynamically
    NVM_LATEST=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST}/install.sh" | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo -e "${BLUE}Installing Node.js LTS (latest)...${NC}"
    nvm install --lts
    nvm use --lts
else
    echo -e "${GREEN}NVM already installed${NC}"
fi

# Install pnpm
if ! command_exists pnpm; then
    echo -e "${BLUE}Installing pnpm (latest)...${NC}"
    curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    echo -e "${GREEN}pnpm already installed${NC}"
fi

# ============================================
# Development Tools
# ============================================
echo -e "\n${GREEN}=== Installing Development Tools ===${NC}"

# VS Code
if ! command_exists code; then
    echo -e "${BLUE}Installing VS Code (latest stable)...${NC}"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code
else
    echo -e "${GREEN}VS Code already installed${NC}"
fi

# GitHub CLI
if ! command_exists gh; then
    echo -e "${BLUE}Installing GitHub CLI (latest stable)...${NC}"
    install_apt "gh"
else
    echo -e "${GREEN}GitHub CLI already installed${NC}"
fi

# ============================================
# Browsers
# ============================================
echo -e "\n${GREEN}=== Installing Browsers ===${NC}"

# Google Chrome
if ! command_exists google-chrome; then
    echo -e "${BLUE}Installing Google Chrome (latest stable)...${NC}"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
    sudo dpkg -i /tmp/google-chrome.deb || sudo apt install -f -y
    rm /tmp/google-chrome.deb
else
    echo -e "${GREEN}Google Chrome already installed${NC}"
fi

# Zen Browser
if [ ! -d "$HOME/zen" ]; then
    echo -e "${BLUE}Installing Zen Browser (latest release)...${NC}"
    echo -e "${YELLOW}Fetching latest Zen Browser release...${NC}"

    # Get latest release URL for generic/specific build
    ZEN_URL=$(curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | grep "browser_download_url.*specific.tar.bz2" | cut -d '"' -f 4 | head -1)

    if [ -n "$ZEN_URL" ]; then
        wget -O /tmp/zen.tar.bz2 "$ZEN_URL"
        mkdir -p "$HOME/zen"
        tar -xjf /tmp/zen.tar.bz2 -C "$HOME/zen" --strip-components=1
        rm /tmp/zen.tar.bz2
        echo -e "${GREEN}Zen Browser installed to ~/zen${NC}"
    else
        echo -e "${RED}Failed to download Zen Browser. Please install manually from https://github.com/zen-browser/desktop/releases${NC}"
    fi
else
    echo -e "${GREEN}Zen Browser already installed at ~/zen${NC}"
fi

# ============================================
# Communication & Productivity
# ============================================
echo -e "\n${GREEN}=== Installing Communication Tools ===${NC}"

# Slack
if ! command_exists slack; then
    echo -e "${BLUE}Installing Slack (latest)...${NC}"
    sudo snap install slack
else
    echo -e "${GREEN}Slack already installed${NC}"
fi

# ============================================
# Media
# ============================================
echo -e "\n${GREEN}=== Installing Media Applications ===${NC}"

# Spotify
if ! command_exists spotify; then
    echo -e "${BLUE}Installing Spotify (latest)...${NC}"
    sudo snap install spotify
else
    echo -e "${GREEN}Spotify already installed${NC}"
fi

# ============================================
# API Development Tools
# ============================================
echo -e "\n${GREEN}=== Installing API Tools ===${NC}"

# Insomnia
if ! command_exists insomnia; then
    echo -e "${BLUE}Installing Insomnia (latest)...${NC}"
    sudo snap install insomnia
else
    echo -e "${GREEN}Insomnia already installed${NC}"
fi

# ============================================
# Programming Languages
# ============================================
echo -e "\n${GREEN}=== Installing Programming Languages ===${NC}"

# Go (latest stable)
if ! command_exists go; then
    echo -e "${BLUE}Installing Go (latest stable)...${NC}"
    # Fetch latest Go version dynamically
    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -1)
    wget "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    echo -e "${GREEN}Go ${GO_VERSION} installed. Make sure /usr/local/go/bin is in your PATH${NC}"
else
    echo -e "${GREEN}Go already installed ($(go version))${NC}"
fi

# ============================================
# Fonts (for polybar and terminal)
# ============================================
echo -e "\n${GREEN}=== Installing Fonts ===${NC}"

install_apt "fonts-font-awesome"
install_apt "fonts-powerline"

# Install Nerd Fonts (latest release)
if [ ! -d "$HOME/.local/share/fonts/NerdFonts" ]; then
    echo -e "${BLUE}Installing JetBrains Mono Nerd Font (latest)...${NC}"

    # Get latest Nerd Fonts release version
    NERD_FONTS_VERSION=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    mkdir -p "$HOME/.local/share/fonts/NerdFonts"
    cd /tmp
    wget "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/JetBrainsMono.zip"
    unzip -q JetBrainsMono.zip -d "$HOME/.local/share/fonts/NerdFonts/"
    rm JetBrainsMono.zip
    fc-cache -fv
    echo -e "${GREEN}JetBrains Mono Nerd Font (${NERD_FONTS_VERSION}) installed${NC}"
else
    echo -e "${GREEN}Nerd Fonts already installed${NC}"
fi

# ============================================
# Final Steps
# ============================================
echo -e "\n${GREEN}=== Installation Complete! ===${NC}"
echo -e "\n${YELLOW}Installed versions:${NC}"
command_exists zsh && echo -e "  zsh: $(zsh --version)"
command_exists vim && echo -e "  vim: $(vim --version | head -1)"
command_exists git && echo -e "  git: $(git --version)"
command_exists tmux && echo -e "  tmux: $(tmux -V)"
command_exists alacritty && echo -e "  alacritty: $(alacritty --version)"
command_exists code && echo -e "  VS Code: $(code --version | head -1)"
command_exists go && echo -e "  Go: $(go version)"
[ -s "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh" && command_exists node && echo -e "  Node.js: $(node --version)"
command_exists pnpm && echo -e "  pnpm: $(pnpm --version)"

echo -e "\n${YELLOW}Recommended next steps:${NC}"
echo -e "  1. Set zsh as default shell: ${BLUE}chsh -s \$(which zsh)${NC}"
echo -e "  2. Log out and log back in for shell changes to take effect"
echo -e "  3. Run the dotfiles installer: ${BLUE}cd ~/dotfiles && ./install.sh${NC}"
echo -e "  4. Configure your git credentials: ${BLUE}vim ~/dotfiles/git/gitconfig.local${NC}"
echo -e "  5. Update wallpaper path in ${BLUE}~/dotfiles/config/i3/config${NC}"
echo -e "  6. Reload i3 with ${BLUE}Mod+Shift+r${NC} or log out and select i3 from login screen"
echo -e "\n${GREEN}Enjoy your new setup!${NC}"
