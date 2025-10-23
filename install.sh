#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${GREEN}Installing dotfiles from $DOTFILES_DIR${NC}"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${YELLOW}Backup directory: $BACKUP_DIR${NC}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Backup existing file/directory if it exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing $target${NC}"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink $target${NC}"
        rm "$target"
    fi

    # Create symlink
    echo -e "${GREEN}Linking $source -> $target${NC}"
    ln -sf "$source" "$target"
}

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}Oh My Zsh already installed${NC}"
fi

# Link shell configurations
echo -e "\n${GREEN}=== Linking shell configurations ===${NC}"
create_symlink "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/shell/bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/shell/profile" "$HOME/.profile"

# Link vim configuration
echo -e "\n${GREEN}=== Linking vim configuration ===${NC}"
create_symlink "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"

# Link git configuration
echo -e "\n${GREEN}=== Linking git configuration ===${NC}"
create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# Create git config local file if it doesn't exist
if [ ! -f "$DOTFILES_DIR/git/gitconfig.local" ]; then
    echo -e "${YELLOW}Creating git/gitconfig.local for personal info...${NC}"
    cat > "$DOTFILES_DIR/git/gitconfig.local" << 'EOF'
[user]
	name = YOUR_NAME
	email = YOUR_EMAIL
	username = YOUR_USERNAME
EOF
    echo -e "${RED}IMPORTANT: Edit $DOTFILES_DIR/git/gitconfig.local with your personal information!${NC}"
fi

# Link X resources
echo -e "\n${GREEN}=== Linking X resources ===${NC}"
if [ -f "$DOTFILES_DIR/shell/Xresources" ]; then
    create_symlink "$DOTFILES_DIR/shell/Xresources" "$HOME/.Xresources"
fi
if [ -f "$DOTFILES_DIR/shell/xmodmap" ]; then
    create_symlink "$DOTFILES_DIR/shell/xmodmap" "$HOME/.xmodmap"
fi

# Link .config directories
echo -e "\n${GREEN}=== Linking .config directories ===${NC}"

# i3
if [ -d "$DOTFILES_DIR/config/i3" ]; then
    create_symlink "$DOTFILES_DIR/config/i3" "$HOME/.config/i3"
fi

# alacritty
if [ -d "$DOTFILES_DIR/config/alacritty" ]; then
    create_symlink "$DOTFILES_DIR/config/alacritty" "$HOME/.config/alacritty"
fi

# polybar
if [ -d "$DOTFILES_DIR/config/polybar" ]; then
    create_symlink "$DOTFILES_DIR/config/polybar" "$HOME/.config/polybar"
fi

# picom
if [ -d "$DOTFILES_DIR/config/picom" ]; then
    create_symlink "$DOTFILES_DIR/config/picom" "$HOME/.config/picom"
fi

# tmux
if [ -d "$DOTFILES_DIR/config/tmux" ]; then
    create_symlink "$DOTFILES_DIR/config/tmux" "$HOME/.config/tmux"
fi

# flameshot
if [ -d "$DOTFILES_DIR/config/flameshot" ]; then
    create_symlink "$DOTFILES_DIR/config/flameshot" "$HOME/.config/flameshot"
fi

# Link fehbg if it exists
if [ -f "$DOTFILES_DIR/shell/fehbg" ]; then
    create_symlink "$DOTFILES_DIR/shell/fehbg" "$HOME/.fehbg"
fi

echo -e "\n${GREEN}=== Dotfiles installation complete! ===${NC}"
echo -e "${YELLOW}Backup of old files: $BACKUP_DIR${NC}"
echo -e "${YELLOW}Don't forget to:${NC}"
echo -e "  1. Edit $DOTFILES_DIR/git/gitconfig.local with your personal git info"
echo -e "  2. Install dependencies: i3, alacritty, polybar, picom, feh, flameshot, etc."
echo -e "  3. Reload your shell: exec zsh"
echo -e "  4. Load Xresources: xrdb ~/.Xresources"
