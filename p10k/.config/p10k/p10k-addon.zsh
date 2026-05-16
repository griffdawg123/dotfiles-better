# Powerlevel10k Addon for existing zsh configuration
# Source this file to add p10k support to your current setup

# === POWERLEVEL10K INSTANT PROMPT ===
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# === OH MY ZSH SETUP (if not already configured) ===
if [[ -z "$ZSH" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
fi

# Only configure if Oh My Zsh is available and not already initialized
if [[ -d "$ZSH" ]] && [[ -z "$ZSH_THEME" ]]; then
  # Set Powerlevel10k theme
  ZSH_THEME="powerlevel10k/powerlevel10k"

  # Add p10k-specific plugins to existing plugins array
  if [[ -z "${plugins[*]}" ]]; then
    plugins=(git)
  fi

  # Add useful plugins if not already present
  [[ "${plugins[*]}" =~ "zsh-autosuggestions" ]] || plugins+=(zsh-autosuggestions)
  [[ "${plugins[*]}" =~ "zsh-syntax-highlighting" ]] || plugins+=(zsh-syntax-highlighting)

  # Source Oh My Zsh if not already done
  if [[ ! "$-" =~ "i" ]] || [[ -z "$PROMPT" ]] || [[ "$PROMPT" == *"starship"* ]]; then
    source $ZSH/oh-my-zsh.sh
  fi
fi

# === POWERLEVEL10K CONFIG ===
# Load Zen Garden theme or fallback to default
if [[ -f ~/.config/p10k/zen-garden.zsh ]]; then
  source ~/.config/p10k/zen-garden.zsh
elif [[ -f ~/.config/p10k/.p10k.zsh ]]; then
  source ~/.config/p10k/.p10k.zsh
fi

# === ZEN GARDEN ENHANCEMENTS ===
# Load enhanced completions and styling
[[ ! -f ~/.config/p10k/zen-garden-completions.zsh ]] || source ~/.config/p10k/zen-garden-completions.zsh

# === PERFORMANCE OPTIMIZATIONS ===
# Disable Oh My Zsh auto-update
DISABLE_AUTO_UPDATE="true"

# Faster completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# === P10K TOGGLE FUNCTION ===
# Function to switch between Starship and Powerlevel10k
toggle-prompt() {
  if [[ "$PROMPT" =~ "starship" ]] || command -v starship >/dev/null && [[ -z "$POWERLEVEL9K_MODE" ]]; then
    # Switch to p10k
    export POWERLEVEL9K_MODE=nerdfont-complete
    [[ ! -f ~/.config/p10k/.p10k.zsh ]] || source ~/.config/p10k/.p10k.zsh
    echo "🚀 Switched to Powerlevel10k"
  else
    # Switch to Starship
    unset POWERLEVEL9K_MODE
    eval "$(starship init zsh)"
    echo "⭐ Switched to Starship"
  fi
  zle reset-prompt 2>/dev/null || true
}

# Create zle widget if in interactive shell
if [[ "$-" =~ "i" ]]; then
  zle -N toggle-prompt
  # Bind to Ctrl+P for "Prompt"
  bindkey '^P' toggle-prompt
fi