# Powerlevel10k Shell Configuration

A modern, fast, and highly customizable Zsh prompt based on Powerlevel10k theme.

## 🚀 Features

- **Ultra-fast prompt** with instant loading
- **Rich Git integration** with status indicators
- **Development environment detection** (Node.js, Python, Go, Docker, etc.)
- **Beautiful icons** with Nerd Font support
- **Intelligent path shortening** for better readability
- **Command execution time** display
- **Custom LLM integration** (Ctrl+G to toggle)
- **Enhanced auto-completion** and syntax highlighting

## 📁 Files

```
~/.dotfiles/p10k/
├── .p10k.zsh          # Powerlevel10k configuration
├── .zshrc             # Enhanced Zsh configuration
├── install.sh         # Installation script
└── README.md          # This file
```

## 🛠 Installation

### GNU Stow Installation (Recommended)

This package is designed to work with GNU Stow for clean dotfile management:

```bash
cd ~/.dotfiles/p10k
./stow.sh
```

The stow script will:
- Install Oh My Zsh (if not present)
- Install Powerlevel10k theme
- Install recommended plugins (autosuggestions, syntax highlighting)
- Check your existing 0xProto font setup
- Use GNU Stow to manage symlinks
- Handle conflicts with existing dotfiles
- Backup existing configurations

### Traditional Installation

For manual symlink management:

```bash
cd ~/.dotfiles/p10k
./install.sh
```

### Manual Installation

1. **Install Oh My Zsh:**
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. **Install Powerlevel10k:**
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```

3. **Install plugins:**
   ```bash
   # Auto-suggestions
   git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

   # Syntax highlighting
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

4. **Font setup:**
   Your existing 0xProto fonts work great! Ensure you have the Nerd Font version for optimal icons.

5. **Stow the package:**
   ```bash
   cd ~/.dotfiles
   stow p10k
   ```

## ⚙️ Configuration

### First Setup

After installation, restart your terminal and run:

```bash
p10k configure
```

This will start the interactive configuration wizard to customize your prompt.

### Font Setup

Your **0xProto** fonts work perfectly with Powerlevel10k! Just ensure you have the Nerd Font version:

- **0xProto Nerd Font** provides the best icon support
- Available at: [Nerd Fonts Releases](https://github.com/ryanoasis/nerd-fonts/releases)
- Look for "0xProto" in the release assets

If you're already using 0xProto, you're all set! The configuration will work great with your existing font choice.

### Customization

#### Prompt Elements

Edit `~/.dotfiles/p10k/.p10k.zsh` to customize prompt segments:

```bash
# Left prompt elements
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon                 # OS identifier
  dir                     # Current directory
  vcs                     # Git status
  newline                 # Line break
  prompt_char             # Prompt symbol
)

# Right prompt elements
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # Exit code
  command_execution_time  # Duration
  background_jobs         # Background jobs
  virtualenv              # Python venv
  nvm                     # Node.js version
  # Add more segments as needed
)
```

#### Colors and Icons

Customize colors for different segments:

```bash
# Directory colors
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103

# Git colors
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
```

### Shell Configuration

Edit `~/.dotfiles/p10k/.zshrc` for shell behavior:

```bash
# Plugin configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

# Add custom aliases
alias ll='eza -la'
alias tree='eza --tree'

# Add custom functions
function mkcd() {
  mkdir -p "$1" && cd "$1"
}
```

## 🎨 Theme Styles

The configuration includes several pre-configured styles:

- **Lean**: Clean, minimal design
- **Classic**: Traditional prompt with separators
- **Rainbow**: Colorful segments
- **Pure**: Minimal, distraction-free

Switch styles by running `p10k configure` and selecting your preference.

## 🔧 Troubleshooting

### Common Issues

**Icons not displaying correctly:**
- Ensure you're using 0xProto Nerd Font (not regular 0xProto)
- Check if your terminal supports Unicode
- Verify font is properly set in terminal settings

**Slow prompt:**
- Disable heavy segments in `.p10k.zsh`
- Check for network-dependent segments (gcloud, aws)

**Configuration not loading:**
- Verify stow symlinks: `ls -la ~/.zshrc ~/.p10k.zsh`
- Check for syntax errors: `zsh -n ~/.zshrc`
- Re-stow if needed: `cd ~/.dotfiles && stow -R p10k`

**Plugin issues:**
- Reinstall plugins: `rm -rf ~/.oh-my-zsh/custom/plugins/* && ./stow.sh`
- Check plugin load order in `.zshrc`

**Stow conflicts:**
- Check for existing files: `stow -n -v p10k`
- Unstow conflicting packages: `stow -D conflicting-package`
- Use `stow -R p10k` to restow after resolving conflicts

### Reset Configuration

To start fresh:

```bash
# Backup current config
cp ~/.p10k.zsh ~/.p10k.zsh.backup

# Reset to defaults
rm ~/.p10k.zsh
p10k configure
```

## 🚀 Advanced Features

### LLM Integration

Toggle LLM mode with `Ctrl+G`:
- Provides AI-powered command suggestions
- Integrates with your existing LLM tools

### Git Integration

Enhanced Git status display:
- Branch information with ahead/behind counts
- Stash indicators
- Conflict markers
- Untracked file counts

### Development Environment Detection

Automatically shows:
- Node.js version (when in Node projects)
- Python virtual environment
- Go module information
- Docker context
- Kubernetes context

## 📚 Resources

- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Zsh Documentation](http://zsh.sourceforge.net/Doc/)
- [Nerd Fonts](https://www.nerdfonts.com/)

## 🤝 Contributing

Feel free to customize and extend this configuration:

1. Fork or copy the dotfiles
2. Make your changes
3. Test thoroughly
4. Share your improvements!

## 📝 License

This configuration is based on the default Powerlevel10k setup with enhancements.
Feel free to use, modify, and distribute as needed.