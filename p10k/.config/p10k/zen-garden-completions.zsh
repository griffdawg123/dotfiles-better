# Zen Garden Enhanced Completions
# Optimized auto-suggestions and completions for the zen garden theme

# === ENHANCED AUTO-SUGGESTIONS ===
if [[ -n "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE}" ]]; then
  # Zen garden muted suggestion style
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89,italic'
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
  ZSH_AUTOSUGGEST_USE_ASYNC=true
  ZSH_AUTOSUGGEST_MANUAL_REBIND=true

  # Custom accept key (Ctrl+Space for zen workflow)
  bindkey '^ ' autosuggest-accept

  # Clear suggestions on Ctrl+L (zen clean slate)
  zen-clear-suggestions() {
    zle clear-screen
    zle autosuggest-clear
  }
  zle -N zen-clear-suggestions
  bindkey '^L' zen-clear-suggestions
fi

# === ENHANCED SYNTAX HIGHLIGHTING ===
if [[ -n "${ZSH_HIGHLIGHT_HIGHLIGHTERS}" ]]; then
  # Zen garden highlighting with earth tones
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

  # Main syntax highlighting (zen colors)
  ZSH_HIGHLIGHT_STYLES[default]='none'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e'              # maple red
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#bb9af7,bold'         # lavender
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#e0af68'               # sand
  ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#e0af68'               # sand
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#9ece6a,underline'       # bamboo
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#565f89'           # muted
  ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#7aa2f7,underline'    # stone blue
  ZSH_HIGHLIGHT_STYLES[path]='fg=#c0caf5'                       # moonlight
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#565f89'         # muted separator
  ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#565f89'  # muted separator
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#bb9af7'                   # lavender
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#bb9af7,bold'     # lavender
  ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#7dcfff'       # cyan
  ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#565f89' # muted
  ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#7dcfff'       # cyan
  ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#565f89' # muted
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#e0af68'       # sand
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#e0af68'       # sand
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#bb9af7'       # lavender
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#565f89' # muted
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'     # bamboo
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'     # bamboo
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#9ece6a'     # bamboo
  ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#9ece6a'                   # bamboo
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#7dcfff' # cyan
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#7dcfff'   # cyan
  ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#7dcfff'   # cyan
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#c0caf5'                     # moonlight
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#565f89,bold'           # muted redirect
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89,italic'             # muted comment
  ZSH_HIGHLIGHT_STYLES[named-fd]='none'
  ZSH_HIGHLIGHT_STYLES[numeric-fd]='none'
  ZSH_HIGHLIGHT_STYLES[arg0]='fg=#c0caf5'                       # moonlight command

  # Bracket highlighting (zen pairs)
  ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#f7768e,bold'         # maple error
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#7dcfff,bold'       # cyan
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#9ece6a,bold'       # bamboo
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#e0af68,bold'       # sand
  ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#bb9af7,bold'       # lavender
  ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=#7aa2f7,bold'       # stone

  # Pattern highlighting (zen warnings)
  ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=#1a1b26,bg=#f7768e,bold')  # danger
  ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=#1a1b26,bg=#e0af68,bold')   # caution

  # Cursor highlighting
  ZSH_HIGHLIGHT_STYLES[cursor]='bg=#565f89'                     # muted highlight
fi

# === ENHANCED COMPLETIONS ===

# Zen completion menu styling
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# Group styling with zen colors
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'%{\e[38;2;158;206;106m%}── %d ──%{\e[0m%}'
zstyle ':completion:*:messages' format $'%{\e[38;2;125;207;255m%}── %d ──%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[38;2;247;118;142m%}── No matches ──%{\e[0m%}'
zstyle ':completion:*:corrections' format $'%{\e[38;2;224;175;104m%}── %d (errors: %e) ──%{\e[0m%}'

# Enhanced file completion
zstyle ':completion:*:*:*:*:*' file-sort modification
zstyle ':completion:*:*:*:*:*' file-list all
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-command-:*:' verbose false

# Process completion with zen filtering
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"

# Git completion enhancements
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-switch:*' sort false
zstyle ':completion:*:git-branch:*' sort false

# Command correction (zen gentle suggestions)
zstyle ':completion:*:corrections' format $'%{\e[38;2;224;175;104m%}── Did you mean %d? ──%{\e[0m%}'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Performance optimizations
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh/completion

# === ZEN COMPLETION FUNCTIONS ===

# Smart completion for common development commands
_zen_npm_scripts() {
  if [[ -f package.json ]]; then
    local scripts=($(node -pe "Object.keys(require('./package.json').scripts || {}).join(' ')" 2>/dev/null))
    _describe 'npm scripts' scripts
  fi
}

_zen_make_targets() {
  if [[ -f Makefile ]] || [[ -f makefile ]] || [[ -f GNUmakefile ]]; then
    local targets=($(make -qp 2>/dev/null | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u))
    _describe 'make targets' targets
  fi
}

# Register zen completions
if command -v npm >/dev/null 2>&1; then
  compdef _zen_npm_scripts npm
fi

if command -v make >/dev/null 2>&1; then
  compdef _zen_make_targets make
fi

# === ZEN KEYBINDINGS ===

# Enhanced navigation with zen feel
bindkey '^[[1;5C' forward-word                    # Ctrl+Right
bindkey '^[[1;5D' backward-word                   # Ctrl+Left
bindkey '^[[H' beginning-of-line                  # Home
bindkey '^[[F' end-of-line                        # End
bindkey '^[[3~' delete-char                       # Delete

# Zen history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search        # Up arrow
bindkey '^[[B' down-line-or-beginning-search      # Down arrow

# Quick directory navigation (zen shortcuts)
zen-up() {
  cd .. && zle reset-prompt
}
zle -N zen-up
bindkey '^[u' zen-up                              # Alt+u for up directory

zen-home() {
  cd ~ && zle reset-prompt
}
zle -N zen-home
bindkey '^[h' zen-home                            # Alt+h for home

# === ENHANCED HISTORY ===

# Zen history configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Create history directory if it doesn't exist
[[ -d ~/.cache/zsh ]] || mkdir -p ~/.cache/zsh

# History options for zen workflow
setopt EXTENDED_HISTORY          # Save timestamp with history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_IGNORE_DUPS          # Ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS      # Ignore all duplicates
setopt HIST_FIND_NO_DUPS         # Don't find duplicates in search
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt HIST_VERIFY               # Show command before executing from history
setopt INC_APPEND_HISTORY        # Append to history immediately
setopt SHARE_HISTORY             # Share history between sessions

# === ZEN ALIASES FOR BETTER WORKFLOW ===

# Enhanced ls with zen colors (if eza is available)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=always --group-directories-first --icons'
  alias ll='eza -la --color=always --group-directories-first --icons --git'
  alias lt='eza --tree --color=always --icons --level=2'
  alias la='eza -a --color=always --group-directories-first --icons'
fi

# Git zen aliases
alias gst='git status --short'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbd='git branch -d'
alias glog='git log --oneline --graph --decorate --all'
alias gdiff='git diff --color=always'

# Development zen shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Quick file operations
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=plain'
fi

if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi