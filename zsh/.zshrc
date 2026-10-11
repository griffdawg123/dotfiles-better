# === P10K INSTANT PROMPT (must be first — before any output or slow init) ===
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
# export ZSH="$HOME/.oh-my-zsh"
#
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Auto-update behavior
# zstyle ':omz:update' mode auto      # update automatically without asking

# zsh plugins
# plugins=(git)

# source $ZSH/oh-my-zsh.sh

# User configuration

# === EDITOR === 
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# === BAT ===
if command -v bat &>/dev/null; then
  alias cat="bat"
elif command -v batcat &>/dev/null; then
  alias cat="batcat"
fi

# === FZF ===
export PATH="$HOME/.fzf/bin:$PATH"
source <(fzf --zsh)
export FZF_DEFAULTCOMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULTCOMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
    fd --type=d --hidden --follow --exclude ".git" . "$1"
}

source $HOME/.config/fzf-git.sh

_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo ${}'"                          "$@" ;;
        ssh)          fzf --preview 'dig {}'                                   "$@" ;;
        *)            fzf --preview "$show_file_or_dir_preview"                "$@" ;;
    esac
}

# === EZA ===
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first"

# === ZOXIDE ===
eval "$(zoxide init zsh)"
alias cd="z"

# === tmuxifier ===
if [[ -x "$HOME/.tmux/plugins/tmuxifier/bin/tmuxifier" ]]; then
  export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
elif [[ -x "$HOME/.tmuxifier/bin/tmuxifier" ]]; then
  export PATH="$HOME/.tmuxifier/bin:$PATH"
fi
if command -v tmuxifier &>/dev/null; then
  eval "$(tmuxifier init -)"
fi

export PATH=$PATH:$HOME/.spicetify:$HOME/.local/bin
export PATH=$PATH:$HOME/.cargo/bin

# === NVM (lazy-loaded for fast startup) ===
export NVM_DIR="$HOME/.nvm"
# Add nvm's node/npm to PATH immediately without loading nvm itself
# (lets you run node/npm directly; nvm CLI is loaded on first use)
if [[ -d "$NVM_DIR" ]]; then
  # Put the default node version on PATH without sourcing nvm
  export PATH="$NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default 2>/dev/null)/bin:$PATH"
fi
# Lazy-load nvm: only initialize when nvm/node/npm/npx are actually called
_load_nvm() {
  unset -f nvm node npm npx yarn pnpm 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { _load_nvm; nvm "$@"; }
# Uncomment if you want node/npm/npx to also trigger full nvm load:
# node() { _load_nvm; node "$@"; }
# npm()  { _load_nvm; npm "$@"; }
# npx()  { _load_nvm; npx "$@"; }

export GOPATH="$HOME/go"

export PATH="$GOPATH/bin:$PATH"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh" || true
## [/Completion]

# === WINDOWS INTEROP ===
export PATH="$PATH:/mnt/c/Windows/System32"  # clip.exe

export DOCKER_CLI_EXPERIMENTAL=enabled

alias v="nvim ."

bindkey -e
bindkey -s "^b" "tmux attach || tmux new\n"

export BEMOJI_PICKER_CMD="$(which fuzzel) -d"
# -----------------------


# === OH MY ZSH + P10K SETUP ===
# Oh My Zsh setup (if available)
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_DISABLE_COMPFIX=true  # Skip slow compaudit on startup

  # powerlevel10k: a git clone lives in Oh My Zsh's custom themes (Ubuntu);
  # the Arch package installs to /usr/share instead, where Oh My Zsh can't
  # find it, so that one is sourced directly after Oh My Zsh loads.
  _p10k_system=/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  if [[ -r ${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
  else
    ZSH_THEME=""
  fi

  # Autosuggestions/highlighting are loaded below with the completion setup,
  # wherever they're installed.
  [[ -n "${plugins[*]}" ]] || plugins=(git)

  source $ZSH/oh-my-zsh.sh

  [[ -z $ZSH_THEME && -r $_p10k_system ]] && source $_p10k_system
  unset _p10k_system

  # Load P10k configuration from dotfiles
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

else
  # Fallback to starship if no Oh My Zsh
  eval "$(starship init zsh)"
fi


# === COMPLETION (fish-style, with or without Oh My Zsh) ===
# Oh My Zsh runs compinit and loads its plugins itself; everything below
# fills in whatever it didn't, so starship-only machines get the same.

if [[ -z $ZSH ]]; then
  # Extra completion definitions from a git-cloned zsh-completions (Ubuntu);
  # the Arch package already installs into site-functions.
  fpath=(~/.local/share/zsh/plugins/zsh-completions/src(N-/) $fpath)
  autoload -Uz compinit
  compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
fi

zstyle ':completion:*' menu select                       # arrow-key menu on Tab
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{109}-- %d --%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Source a plugin from the Arch package, Ubuntu package or a git clone.
_load_zsh_plugin() {
  local dir
  for dir in /usr/share/zsh/plugins/$1 /usr/share/$1 ~/.local/share/zsh/plugins/$1 \
             ${ZSH_CUSTOM:-${ZSH:-/nonexistent}/custom}/plugins/$1; do
    if [[ -r $dir/$1.zsh ]]; then
      source "$dir/$1.zsh"
      return
    fi
  done
}

# Grey inline suggestion as you type; → or End accepts, Ctrl+Space too.
(( $+functions[_zsh_autosuggest_start] )) || _load_zsh_plugin zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240,italic'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept

# Colour commands as you type (valid/invalid). Must load after other widgets.
[[ -n $ZSH_HIGHLIGHT_VERSION ]] || _load_zsh_plugin zsh-syntax-highlighting

# Up/Down search history for what's already typed.
_load_zsh_plugin zsh-history-substring-search
if (( $+functions[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

unfunction _load_zsh_plugin


# Added by Antigravity CLI installer
export PATH="/home/griffdawg/.local/bin:$PATH"
