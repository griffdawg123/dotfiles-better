# 🌸 Zen Garden Shell Theme

A minimalist, tranquil shell experience inspired by Japanese aesthetics, Tokyo Night colors, and natural harmony. Designed for translucent terminals and focused coding workflows.

## 🎨 Visual Philosophy

**"Less is more, but better is everything"**

- **Tokyo Night Foundation**: Deep indigo nights with electric blue accents
- **Earthy Harmonies**: Stone, bamboo, moss, and cherry blossom tones
- **Translucent Optimized**: Works beautifully with background blur and transparency
- **Minimal Information**: Only essential context, reducing visual noise
- **Zen Aesthetics**: Clean lines, subtle colors, maximum focus

## 🎯 Color Palette

### Tokyo Night Base
- **Deep Night Sky**: `#1a1b26` - Main background
- **Storm Clouds**: `#24283b` - Subtle background
- **Moonlight**: `#c0caf5` - Primary text
- **Twilight**: `#565f89` - Muted text

### Zen Earth Tones
- **Weathered Stone**: `#6f7bb6` - Directory paths
- **Fresh Bamboo**: `#9ece6a` - Success states
- **Moss on Stone**: `#73daca` - Git clean
- **Cherry Blossom**: `#ff9e64` - Warm accents
- **Autumn Maple**: `#f7768e` - Errors
- **Raked Sand**: `#e0af68` - Warnings

## 🚀 Features

### Intelligent Prompt
- **Single Line Zen**: Minimal visual footprint
- **Smart Git Status**: Visual indicators without noise
- **Context Awareness**: Shows environment info only when relevant
- **Performance Focused**: Instant loading, no lag

### Enhanced Completions
- **Auto-suggestions**: Muted, intelligent predictions
- **Syntax Highlighting**: Zen earth tone highlighting
- **Smart Matching**: Fuzzy matching with visual feedback
- **Development Context**: NPM scripts, Make targets, Git branches

### Zen Functions
- **`zen-mode`**: Toggle ultra-minimal prompt
- **`zen-git`**: Beautiful git status overview
- **Smart Navigation**: Alt+h (home), Alt+u (up), Ctrl+Space (accept suggestion)

## 📁 File Structure

```
~/.dotfiles/p10k/.config/p10k/
├── zen-garden.zsh              # Main theme configuration
├── zen-garden-completions.zsh  # Enhanced completions & styling
└── p10k-addon.zsh             # Integration with existing setup
```

## 🛠 Installation

### Automatic Setup
```bash
cd ~/.dotfiles/p10k
./setup-addon.sh
```

### Manual Integration
Add to your `~/.zshrc`:
```bash
[[ ! -f ~/.config/p10k/p10k-addon.zsh ]] || source ~/.config/p10k/p10k-addon.zsh
```

## ⚡ Quick Start

1. **Install dependencies** (script handles this):
   - Oh My Zsh
   - Powerlevel10k
   - zsh-autosuggestions
   - zsh-syntax-highlighting

2. **Stow the configuration**:
   ```bash
   cd ~/.dotfiles && stow p10k
   ```

3. **Restart your shell**:
   ```bash
   exec zsh
   ```

4. **Enjoy zen mode**:
   - `Ctrl+P`: Toggle between Starship and Zen Garden
   - `zen-mode`: Toggle minimal prompt
   - `zen-git`: Quick git overview

## 🎯 Prompt Layout

### Left Side (Essential Info)
```
❯ directory git-branch ❯
```

### Right Side (Context When Needed)
```
⚠️ errors | 1.2s | bg-jobs | py-env | node | go | 14:30
```

### Example Outputs

**Clean Git Repo**:
```
❯ ~/dotfiles main ❯
```

**Dirty Git Repo**:
```
❯ ~/project feature-branch !2 +1 ❯
```

**With Context**:
```
❯ ~/api main ❯                    🐍 venv | ⚠️ 1 | 14:30
```

**Zen Mode**:
```
❯ ~/code ❯
```

## 🎨 Customization

### Color Tweaks
Edit `zen-garden.zsh` and modify the color variables:
```bash
typeset -g ZEN_BAMBOO="#your-green"
typeset -g ZEN_CHERRY="#your-orange"
```

### Prompt Elements
Customize what appears in your prompt:
```bash
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir                 # Current directory
  vcs                 # Git status
  prompt_char         # Zen symbol
)
```

### Zen Mode Behavior
Customize the `zen-mode` function in `zen-garden.zsh` to hide/show different elements.

## 🔧 Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+P` | Toggle Starship ↔ Zen Garden |
| `Ctrl+Space` | Accept auto-suggestion |
| `Ctrl+L` | Clear screen & suggestions |
| `Alt+h` | Navigate to home |
| `Alt+u` | Navigate up one directory |
| `↑/↓` | Smart history search |

## 🌿 Git Integration

### Status Indicators
- `main` - Clean branch
- `main !2` - 2 unstaged changes
- `main +1` - 1 staged change
- `main ?3` - 3 untracked files
- `main ⇡2` - 2 commits ahead
- `main ⇣1` - 1 commit behind
- `main ~1` - 1 conflict

### Git Aliases (Zen Style)
```bash
gst     # git status --short
gco     # git checkout
gcb     # git checkout -b
glog    # git log --oneline --graph
```

## 🔧 Troubleshooting

### Icons Not Displaying
- Ensure 0xProto Nerd Font is installed
- Verify terminal font is set correctly
- Check Unicode support in terminal

### Slow Prompt
- Large Git repos: Git status may take time
- Network segments: Disable cloud segments if not needed
- Background processes: Check for hanging operations

### Colors Not Appearing
- Verify terminal supports 24-bit color
- Check if background transparency affects visibility
- Adjust color values in `zen-garden.zsh`

### Completions Not Working
- Ensure plugins are loaded: `echo $plugins`
- Check completion cache: `rm -rf ~/.cache/zsh/completion`
- Restart shell after plugin installation

## 🌸 Philosophy

> "The best shell is one that disappears, leaving only your thoughts and the code."

Zen Garden prioritizes:
- **Clarity over clutter**
- **Speed over features**
- **Beauty over complexity**
- **Focus over distraction**

The theme adapts to your workflow rather than demanding attention, providing just enough information to maintain flow state while coding.

## 🤝 Compatibility

### Works With
- ✅ Any Nerd Font (optimized for 0xProto)
- ✅ Translucent/transparent terminals
- ✅ Alacritty, iTerm2, Ghostty, GNOME Terminal
- ✅ tmux integration
- ✅ Git repositories of any size
- ✅ Multi-monitor setups

### Optimized For
- 🎯 Coding workflows (Git, languages, containers)
- 🎯 System administration
- 🎯 Terminal-focused development
- 🎯 Japanese aesthetic backgrounds
- 🎯 Minimal cognitive overhead

## 📖 Inspiration

This theme draws inspiration from:
- **Tokyo's neon-lit nights** - Electric blues and purples
- **Japanese rock gardens** - Minimal, purposeful arrangement
- **Zen philosophy** - Less is more, focus on essence
- **Natural materials** - Stone, bamboo, moss textures
- **r/unixporn minimalism** - Clean, functional beauty

---

*"In the depth of silence, code speaks loudest."* 🧘‍♀️