# Zen Garden Theme - Minimalist Tokyo Night with Earthy Undertones
# Optimized for translucent terminals and Japanese aesthetic backgrounds
#
# Color Philosophy:
# - Tokyo Night muted blues and purples for calm focus
# - Earthy accents (stone, bamboo, moss) for natural harmony
# - Minimal information density for zen-like clarity

# === ZEN GARDEN COLOR PALETTE ===

# Tokyo Night base with earthy modifications
typeset -g ZEN_BG_MAIN="#1a1b26"           # Deep night sky
typeset -g ZEN_BG_SUBTLE="#24283b"         # Storm clouds
typeset -g ZEN_FG_PRIMARY="#c0caf5"        # Moonlight text
typeset -g ZEN_FG_MUTED="#565f89"          # Twilight comments

# Zen earth tones (inspired by Japanese gardens)
typeset -g ZEN_STONE="#6f7bb6"             # Weathered stone (Tokyo Night blue muted)
typeset -g ZEN_BAMBOO="#9ece6a"            # Fresh bamboo (green)
typeset -g ZEN_MOSS="#73daca"              # Moss on stone (cyan)
typeset -g ZEN_CHERRY="#ff9e64"            # Cherry blossom (warm peach)
typeset -g ZEN_MAPLE="#f7768e"             # Autumn maple (soft red)
typeset -g ZEN_SAND="#e0af68"              # Raked sand (warm yellow)

# Status colors optimized for translucent backgrounds
typeset -g ZEN_SUCCESS="#a9b665"           # Muted bamboo green
typeset -g ZEN_WARNING="#d5925c"           # Muted sand orange
typeset -g ZEN_ERROR="#e5505f"             # Muted maple red
typeset -g ZEN_INFO="#7fb4ca"              # Muted stone blue

# Git status colors (subtle but clear)
typeset -g ZEN_GIT_CLEAN="#9ece6a"         # Clean bamboo
typeset -g ZEN_GIT_DIRTY="#d5925c"         # Sandy changes
typeset -g ZEN_GIT_STAGED="#7fb4ca"        # Staged like still water
typeset -g ZEN_GIT_CONFLICT="#e5505f"      # Conflict like autumn

# === ZEN GARDEN P10K CONFIGURATION ===

# Instant prompt for translucent terminals
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

() {
  emulate -L zsh -o extended_glob
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # === PROMPT LAYOUT (Zen Single Line) ===
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context                 # user@host (minimal, only when needed)
    dir                     # current directory (shortened intelligently)
    vcs                     # git status (clean visual indicators)
    newline                 # breathing room
    prompt_char            # zen prompt symbol
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # command status (errors only)
    command_execution_time  # slow commands only
    background_jobs         # background processes
    virtualenv             # python env (when active)
    nvm                    # node version (when in js projects)
    go_version             # go version (when in go projects)
    time                   # time (subtle)
  )

  # === ZEN AESTHETICS ===
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  # Transparent background for better blending
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

  # Icons before content
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

  # Minimal prompt spacing
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # === PROMPT CHARACTER (Zen Symbol) ===
  # Use a subtle zen-inspired prompt that changes with status
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$ZEN_BAMBOO
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$ZEN_ERROR

  # Zen symbols: ❯ for success, ❌ for error (minimal)
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'

  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # === DIRECTORY (Intelligent Shortening) ===
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$ZEN_STONE
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$ZEN_FG_MUTED
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$ZEN_MOSS
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

  # Zen anchor files (project roots)
  local anchor_files=(
    .git .bzr .citc .hg .node-version .python-version .go-version
    .ruby-version .lua-version .java-version .perl-version .php-version
    .tool-versions .shorten_folder_marker .svn .terraform CVS
    Cargo.toml composer.json go.mod package.json stack.yaml
    pyproject.toml requirements.txt setup.py Pipfile pom.xml
    build.gradle Makefile CMakeLists.txt
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"

  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  # === GIT STATUS (Zen Visual Language) ===
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Custom git formatter for zen aesthetics
  function zen_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g zen_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Fresh status colors
      local meta=$ZEN_FG_MUTED
      local clean=$ZEN_GIT_CLEAN
      local modified=$ZEN_GIT_DIRTY
      local untracked=$ZEN_INFO
      local conflicted=$ZEN_ERROR
    else
      # Stale status (muted)
      local meta=$ZEN_FG_MUTED
      local clean=$ZEN_FG_MUTED
      local modified=$ZEN_FG_MUTED
      local untracked=$ZEN_FG_MUTED
      local conflicted=$ZEN_FG_MUTED
    fi

    local res

    # Branch name (shortened for zen)
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      (( $#branch > 20 )) && branch[18,-1]="…"
      res+="${clean}${branch//\%/%%}"
    fi

    # Tag (if no branch)
    if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      (( $#tag > 20 )) && tag[18,-1]="…"
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    # Commit hash (if no branch/tag)
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,7]}"

    # Zen status indicators (minimal)
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"

    (( VCS_STATUS_STASHES )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED )) && res+=" ${ZEN_GIT_STAGED}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED )) && res+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"

    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g zen_git_format=$res
  }
  functions -M zen_git_formatter 2>/dev/null

  # Git configuration
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=4096
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((zen_git_formatter(1)))+${zen_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((zen_git_formatter(0)))+${zen_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$ZEN_MOSS
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=$ZEN_FG_MUTED

  # === STATUS (Errors Only for Zen) ===
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$ZEN_WARNING
  typeset -g POWERLEVEL9K_STATUS_ERROR=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$ZEN_ERROR
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$ZEN_ERROR
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false

  # === EXECUTION TIME (Slow Commands Only) ===
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$ZEN_SAND
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  # === BACKGROUND JOBS ===
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$ZEN_WARNING

  # === CONTEXT (Minimal) ===
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$ZEN_ERROR
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=$ZEN_WARNING
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=$ZEN_FG_MUTED
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  # Hide context unless needed
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  # === LANGUAGE VERSIONS (Project Context Only) ===

  # Python Virtual Environment
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$ZEN_BAMBOO
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  # Node Version (project context)
  typeset -g POWERLEVEL9K_NVM_FOREGROUND=$ZEN_MOSS
  typeset -g POWERLEVEL9K_NVM_PROMPT_ALWAYS_SHOW=false

  # Go Version (project context)
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$ZEN_STONE
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true

  # === TIME (Subtle) ===
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$ZEN_FG_MUTED
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # === INSTANT PROMPT ===
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # Reload if already loaded
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell p10k which config file to use
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

# === ZEN GARDEN COMPLETION ENHANCEMENTS ===

# Completion styling for zen aesthetics
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'\e[38;2;158;206;106m-- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[38;2;213;146;92mNo matches found\e[0m'

# Faster completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion

# Git completion enhancement
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-switch:*' sort false

# === ZEN FUNCTIONS ===

# Zen mode toggle
zen-mode() {
  if [[ -z "$ZEN_MODE_ACTIVE" ]]; then
    export ZEN_MODE_ACTIVE=1
    # Hide right prompt for ultimate minimalism
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
    echo "🧘 Zen mode activated - minimal prompt"
  else
    unset ZEN_MODE_ACTIVE
    # Restore right prompt
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status command_execution_time background_jobs
      virtualenv nvm go_version time
    )
    echo "🌸 Zen mode deactivated - full prompt"
  fi
  p10k reload
}

# Quick git status with zen formatting
zen-git() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "🌿 $(git branch --show-current) | $(git status --porcelain | wc -l) changes"
    git status --short
  else
    echo "🏔️  Not in a git repository"
  fi
}