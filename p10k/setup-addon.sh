#!/bin/bash

# Powerlevel10k Addon Setup Script
# This script adds p10k support to your existing zsh configuration without replacing it

set -e

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

# Check if stow is available
check_stow() {
    log_header "Checking GNU Stow"

    if ! command -v stow >/dev/null 2>&1; then
        log_error "GNU Stow is not installed. Please install it first:"
        echo -e "• ${CYAN}Arch/Manjaro:${NC} sudo pacman -S stow"
        echo -e "• ${CYAN}Ubuntu/Debian:${NC} sudo apt install stow"
        echo -e "• ${CYAN}macOS:${NC} brew install stow"
        exit 1
    else
        log_success "GNU Stow found: $(which stow)"
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

# Check fonts
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
}

# Stow the p10k package
stow_p10k() {
    log_header "Setting Up P10k Configuration with Stow"

    cd "$HOME/.dotfiles"

    log_info "Stowing p10k package..."
    stow p10k

    if [ $? -eq 0 ]; then
        log_success "p10k package stowed successfully"
    else
        log_error "Failed to stow p10k package. Check for conflicts."
        exit 1
    fi
}

# Add addon to existing zshrc
add_to_zshrc() {
    log_header "Adding P10k Addon to Your ZSH Configuration"

    local zshrc_file="$HOME/.zshrc"
    local addon_line='[[ ! -f ~/.config/p10k/p10k-addon.zsh ]] || source ~/.config/p10k/p10k-addon.zsh'

    if [ -f "$zshrc_file" ]; then
        if grep -q "p10k-addon.zsh" "$zshrc_file"; then
            log_info "P10k addon already present in .zshrc"
        else
            log_info "Adding P10k addon to your existing .zshrc..."
            echo "" >> "$zshrc_file"
            echo "# === POWERLEVEL10K ADDON ===" >> "$zshrc_file"
            echo "# Adds p10k support while preserving existing configuration" >> "$zshrc_file"
            echo "$addon_line" >> "$zshrc_file"
            log_success "P10k addon added to .zshrc"
        fi
    else
        log_warning "No existing .zshrc found. Creating one with basic setup..."
        cat > "$zshrc_file" << 'EOF'
# Basic zsh configuration with Powerlevel10k addon

# === POWERLEVEL10K ADDON ===
# Adds p10k support while preserving existing configuration
[[ ! -f ~/.config/p10k/p10k-addon.zsh ]] || source ~/.config/p10k/p10k-addon.zsh
EOF
        log_success "Created new .zshrc with P10k addon"
    fi
}

# Show completion info
show_completion() {
    log_header "Setup Complete!"

    echo -e "${GREEN}✨ Powerlevel10k addon has been successfully installed!${NC}\n"

    echo -e "${CYAN}What was added:${NC}"
    echo -e "• ${YELLOW}Powerlevel10k addon${NC} sourced in your .zshrc"
    echo -e "• ${YELLOW}Your existing config${NC} is preserved"
    echo -e "• ${YELLOW}0xProto font support${NC} maintained\n"

    echo -e "${CYAN}Next steps:${NC}"
    echo -e "1. ${YELLOW}Restart your terminal${NC} or run: ${MAGENTA}exec zsh${NC}"
    echo -e "2. ${YELLOW}Toggle prompts${NC} with: ${MAGENTA}Ctrl+P${NC}"
    echo -e "3. ${YELLOW}Configure p10k${NC} with: ${MAGENTA}p10k configure${NC}"
    echo -e "4. ${YELLOW}Enjoy both prompts!${NC} 🎉\n"

    echo -e "${BLUE}Prompt switching:${NC}"
    echo -e "• ${YELLOW}Ctrl+P${NC}: Toggle between Starship ⭐ and Powerlevel10k 🚀"
    echo -e "• ${YELLOW}Function${NC}: ${MAGENTA}toggle-prompt${NC}\n"

    echo -e "${BLUE}Configuration files:${NC}"
    echo -e "• P10k addon: ${MAGENTA}~/.config/p10k/p10k-addon.zsh${NC}"
    echo -e "• P10k config: ${MAGENTA}~/.config/p10k/.p10k.zsh${NC}"
    echo -e "• Your .zshrc: ${MAGENTA}~/.zshrc${NC} (preserved + addon added)\n"

    echo -e "${BLUE}Stow management:${NC}"
    echo -e "• ${YELLOW}Stow package${NC}: ${MAGENTA}p10k${NC}"
    echo -e "• ${YELLOW}Unstow${NC}: ${MAGENTA}cd ~/.dotfiles && stow -D p10k${NC}"
    echo -e "• ${YELLOW}Restow${NC}: ${MAGENTA}cd ~/.dotfiles && stow -R p10k${NC}\n"
}

# Main function
main() {
    log_header "Powerlevel10k Addon Setup"

    echo -e "${CYAN}This script will:${NC}"
    echo -e "• Add Powerlevel10k support to your existing configuration"
    echo -e "• Keep your current zsh setup intact"
    echo -e "• Allow you to toggle between Starship and P10k"
    echo -e "• Use GNU Stow for clean management\n"

    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelled by user"
        exit 0
    fi

    check_stow
    install_oh_my_zsh
    install_powerlevel10k
    install_plugins
    check_fonts
    stow_p10k
    add_to_zshrc
    show_completion
}

# Run main function
main "$@"