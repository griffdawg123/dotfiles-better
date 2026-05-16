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
alias cat="bat"

# === FZF ===
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
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

export PATH=$PATH:$HOME/.spicetify:$HOME/.local/bin
export PATH=$PATH:$HOME/.cargo/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOPATH="$HOME/go"

export PATH="$GOPATH/bin:$PATH"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/griffdawg/.dart-cli-completion/zsh-config.zsh ]] && . /home/griffdawg/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

eval "$(starship init zsh)"

export DOCKER_CLI_EXPERIMENTAL=enabled

alias v="nvim ."

bindkey -e
bindkey -s "^b" "tmux attach || tmux new\n"

export BEMOJI_PICKER_CMD="$(which fuzzel) -d"
# -----------------------


# === ZEN SHELL (Single Line, Muted Colors) ===
# P10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh setup (if available)
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="powerlevel10k/powerlevel10k"

  # Add to existing plugins or create array
  if [[ -z "${plugins[*]}" ]]; then
    plugins=(git)
  fi
  [[ "${plugins[*]}" =~ "zsh-autosuggestions" ]] || plugins+=(zsh-autosuggestions)
  [[ "${plugins[*]}" =~ "zsh-syntax-highlighting" ]] || plugins+=(zsh-syntax-highlighting)

  source $ZSH/oh-my-zsh.sh

  # Load P10k configuration from dotfiles
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

  # Enhanced auto-suggestions (muted)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240,italic'
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  bindkey '^ ' autosuggest-accept  # Ctrl+Space

else
  # Fallback to starship if no Oh My Zsh
  eval "$(starship init zsh)"
fi
