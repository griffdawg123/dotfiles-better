#!/bin/bash

# Powerlevel10k Installation Script
# This script sets up Powerlevel10k with Oh My Zsh and recommended plugins

set -e

echo "🚀 Setting up Powerlevel10k shell environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo -e "\n${MAGENTA}=== $1 ===${NC}\n"
}

# Check if running in Zsh
check_zsh() {
    if [ -z "$ZSH_VERSION" ]; then
        log_warning "This script is designed for Zsh. Current shell: $SHELL"
        if ! command -v zsh >/dev/null 2>&1; then
            log_error "Zsh is not installed. Please install Zsh first."
            exit 1
        fi
    fi
}

# Install Oh My Zsh if not present
install_oh_my_zsh() {
    log_header "Installing Oh My Zsh"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed successfully"
    else
        log_info "Oh My Zsh already installed, skipping..."
    fi
}

# Install Powerlevel10k theme
install_powerlevel10k() {
    log_header "Installing Powerlevel10k Theme"

    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    if [ ! -d "$p10k_dir" ]; then
        log_info "Cloning Powerlevel10k repository..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        log_success "Powerlevel10k installed successfully"
    else
        log_info "Powerlevel10k already installed, updating..."
        cd "$p10k_dir" && git pull
        log_success "Powerlevel10k updated successfully"
    fi
}

# Install recommended plugins
install_plugins() {
    log_header "Installing Zsh Plugins"

    local custom_plugins="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # zsh-autosuggestions
    if [ ! -d "$custom_plugins/zsh-autosuggestions" ]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$custom_plugins/zsh-autosuggestions"
        log_success "zsh-autosuggestions installed"
    else
        log_info "zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$custom_plugins/zsh-syntax-highlighting" ]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_plugins/zsh-syntax-highlighting"
        log_success "zsh-syntax-highlighting installed"
    else
        log_info "zsh-syntax-highlighting already installed"
    fi
}

# Check fonts (user prefers 0xProto)
check_fonts() {
    log_header "Checking Font Configuration"

    log_info "Checking for 0xProto font family..."

    if fc-list | grep -i "0xProto" > /dev/null 2>&1; then
        log_success "0xProto fonts are already installed"
        log_info "Your existing 0xProto fonts will work perfectly with Powerlevel10k!"
    else
        log_warning "0xProto fonts not detected"
        log_info "Consider installing 0xProto Nerd Font for optimal icon display"
        echo -e "${CYAN}You can download 0xProto from:${NC}"
        echo -e "• ${MAGENTA}https://github.com/ryanoasis/nerd-fonts/releases${NC}"
        echo -e "• Look for '0xProto' in the assets"
    fi

    log_info "Font compatibility notes:"
    echo -e "• 0xProto works great with Powerlevel10k"
    echo -e "• Make sure you have the Nerd Font version for icons"
    echo -e "• If icons don't display, try 0xProto Nerd Font"
}

# Backup existing config
backup_config() {
    log_header "Backing Up Existing Configuration"

    if [ -f "$HOME/.zshrc" ]; then
        local backup_file="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$HOME/.zshrc" "$backup_file"
        log_success "Existing .zshrc backed up to $backup_file"
    fi

    if [ -f "$HOME/.p10k.zsh" ]; then
        local backup_file="$HOME/.p10k.zsh.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$HOME/.p10k.zsh" "$backup_file"
        log_success "Existing .p10k.zsh backed up to $backup_file"
    fi
}

# Setup symlinks
setup_symlinks() {
    log_header "Setting Up Symlinks"

    # Link the new .zshrc
    if [ -f "$HOME/.dotfiles/p10k/.zshrc" ]; then
        log_info "Creating symlink for .zshrc..."
        ln -sf "$HOME/.dotfiles/p10k/.zshrc" "$HOME/.zshrc"
        log_success ".zshrc symlink created"
    fi

    # Link the p10k config
    if [ -f "$HOME/.dotfiles/p10k/.p10k.zsh" ]; then
        log_info "Creating symlink for .p10k.zsh..."
        ln -sf "$HOME/.dotfiles/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
        log_success ".p10k.zsh symlink created"
    fi
}

# Verify installation
verify_installation() {
    log_header "Verifying Installation"

    local errors=0

    # Check Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_error "Oh My Zsh not found"
        ((errors++))
    else
        log_success "Oh My Zsh found"
    fi

    # Check Powerlevel10k
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ ! -d "$p10k_dir" ]; then
        log_error "Powerlevel10k not found"
        ((errors++))
    else
        log_success "Powerlevel10k found"
    fi

    # Check plugins
    local custom_plugins="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    if [ ! -d "$custom_plugins/zsh-autosuggestions" ]; then
        log_warning "zsh-autosuggestions not found"
        ((errors++))
    else
        log_success "zsh-autosuggestions found"
    fi

    if [ ! -d "$custom_plugins/zsh-syntax-highlighting" ]; then
        log_warning "zsh-syntax-highlighting not found"
        ((errors++))
    else
        log_success "zsh-syntax-highlighting found"
    fi

    # Check config files
    if [ ! -f "$HOME/.zshrc" ]; then
        log_error ".zshrc not found"
        ((errors++))
    else
        log_success ".zshrc found"
    fi

    if [ ! -f "$HOME/.p10k.zsh" ]; then
        log_error ".p10k.zsh not found"
        ((errors++))
    else
        log_success ".p10k.zsh found"
    fi

    return $errors
}

# Main installation function
main() {
    log_header "Powerlevel10k Setup Script"

    check_zsh
    backup_config
    install_oh_my_zsh
    install_powerlevel10k
    install_plugins
    check_fonts
    setup_symlinks

    if verify_installation; then
        log_header "Installation Complete!"

        echo -e "${GREEN}✨ Powerlevel10k has been successfully installed!${NC}\n"

        echo -e "${CYAN}Next steps:${NC}"
        echo -e "1. ${YELLOW}Restart your terminal${NC} or run: ${MAGENTA}exec zsh${NC}"
        echo -e "2. ${YELLOW}Your 0xProto font${NC} should work great!"
        echo -e "3. ${YELLOW}Run the configuration wizard${NC}: ${MAGENTA}p10k configure${NC}"
        echo -e "4. ${YELLOW}Enjoy your new prompt!${NC} 🎉\n"

        echo -e "${BLUE}Configuration files:${NC}"
        echo -e "• Main config: ${MAGENTA}~/.dotfiles/p10k/.zshrc${NC}"
        echo -e "• P10k config: ${MAGENTA}~/.dotfiles/p10k/.p10k.zsh${NC}"
        echo -e "• Install script: ${MAGENTA}~/.dotfiles/p10k/install.sh${NC}\n"

        echo -e "${BLUE}Customization:${NC}"
        echo -e "• Edit ${MAGENTA}~/.dotfiles/p10k/.p10k.zsh${NC} for prompt customization"
        echo -e "• Edit ${MAGENTA}~/.dotfiles/p10k/.zshrc${NC} for shell behavior"
        echo -e "• Run ${MAGENTA}p10k configure${NC} anytime to reconfigure\n"

    else
        log_error "Installation completed with some issues. Please check the output above."
        exit 1
    fi
}

# Run main function
main "$@"