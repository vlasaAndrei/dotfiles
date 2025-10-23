# Dotfiles

Personal dotfiles for Linux (i3wm, zsh, vim, and development tools)

## Contents

- **Shell**: zsh, bash configurations with Oh My Zsh
- **Window Manager**: i3 with polybar, picom compositor
- **Terminal**: Alacritty configuration
- **Editor**: Vim configuration
- **Development**: Git, tmux configurations
- **Tools**: Flameshot, feh wallpaper setter

## Prerequisites

### Required packages

```bash
# Ubuntu/Debian/Pop!_OS
sudo apt update
sudo apt install -y \
    i3 \
    zsh \
    vim \
    git \
    curl \
    feh \
    tmux \
    polybar \
    picom \
    alacritty \
    flameshot \
    xinput \
    xss-lock \
    i3lock
```

### Optional packages

```bash
# Additional tools referenced in configs
sudo apt install -y \
    dmenu \
    i3status \
    network-manager \
    nm-applet
```

## Installation

### Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:
- Backup your existing dotfiles to `~/.dotfiles_backup_TIMESTAMP`
- Install Oh My Zsh if not present
- Create symlinks from the repo to your home directory
- Set up the `.config` directory structure

### Post-Installation

1. **Edit personal git configuration**:
   ```bash
   # Edit with your personal info
   cp git/gitconfig.local.example git/gitconfig.local
   vim git/gitconfig.local
   ```

2. **Set up wallpaper**:
   - Update the wallpaper path in `config/i3/config` (lines 244)
   - Or place your wallpaper at `/home/YOUR_USERNAME/Pictures/Wallpapers/`

3. **Configure monitors**:
   - Edit `config/i3/config` to match your monitor setup
   - Update `xrandr` commands (line 220)
   - Adjust workspace assignments (lines 249-260)

4. **Update application paths**:
   - Review i3 keybindings for applications (lines 196-214)
   - Update paths if your applications are installed elsewhere

5. **Install Node Version Manager (NVM)**:
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   ```

6. **Reload your shell**:
   ```bash
   exec zsh
   ```

7. **Load X resources**:
   ```bash
   xrdb ~/.Xresources
   ```

## Repository Structure

```
dotfiles/
├── config/           # .config directory contents
│   ├── i3/          # i3 window manager config
│   ├── alacritty/   # Alacritty terminal config
│   ├── polybar/     # Polybar status bar config
│   ├── picom/       # Picom compositor config
│   ├── tmux/        # Tmux config
│   └── flameshot/   # Flameshot screenshot tool config
├── git/             # Git configurations
│   ├── gitconfig    # Public git config
│   └── gitconfig.local.example  # Template for personal info
├── shell/           # Shell configurations
│   ├── zshrc        # Zsh configuration
│   ├── bashrc       # Bash configuration
│   ├── profile      # Shell profile
│   ├── Xresources   # X resources
│   ├── xmodmap      # Keyboard mappings
│   └── fehbg        # Wallpaper script
├── vim/             # Vim configurations
│   └── vimrc        # Vim configuration
├── scripts/         # Utility scripts
├── install.sh       # Installation script
├── .gitignore       # Git ignore file
└── README.md        # This file
```

## Key Features

### i3 Window Manager
- Custom keybindings for common applications
- Dual monitor support with workspace assignments
- Integrated with polybar for status bar
- Picom for transparency and compositing effects
- Gaps between windows for aesthetics

### Shell Configuration
- Oh My Zsh with robbyrussell theme
- Git and Golang plugins
- Custom aliases for theme switching (go-light/go-dark)
- WiFi management aliases
- SSH agent auto-start
- NVM and pnpm integration

### Custom Keybindings (i3)
- `Super+Enter`: Alacritty terminal
- `Super+b`: Zen browser
- `Super+m`: VS Code
- `Super+g`: Google Chrome
- `Super+p`: Slack
- `Super+j`: Spotify
- `Super+i`: Insomnia
- `Ctrl+Shift+s`: Flameshot screenshot

## Customization

### Adding new configurations
1. Add the config files to the appropriate directory
2. Update `install.sh` to create the symlinks
3. Update this README with the new configuration

### Removing Oh My Zsh
If you prefer a minimal zsh setup:
1. Remove Oh My Zsh references from `shell/zshrc`
2. Remove the Oh My Zsh installation step from `install.sh`

## Troubleshooting

### Symlinks not working
```bash
# Check if symlinks were created
ls -la ~ | grep "\->"
ls -la ~/.config | grep "\->"
```

### i3 not loading polybar
```bash
# Make polybar launch script executable
chmod +x ~/.config/polybar/launch.sh
# Test manually
~/.config/polybar/launch.sh
```

### Git config not loading personal info
```bash
# Check if gitconfig.local exists and has correct path
git config --list --show-origin
```

## Backup and Restore

### Creating a backup
Your existing dotfiles are automatically backed up when running `install.sh` to:
```
~/.dotfiles_backup_TIMESTAMP/
```

### Restoring from backup
```bash
# Remove symlinks
rm ~/.zshrc ~/.bashrc ~/.vimrc ~/.gitconfig
rm -rf ~/.config/i3 ~/.config/alacritty ~/.config/polybar

# Restore from backup
cp -r ~/.dotfiles_backup_TIMESTAMP/* ~/
```

## License

Free to use and modify.

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt to your needs!
