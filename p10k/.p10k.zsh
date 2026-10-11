# Zen Shell Configuration
# Single line, muted colors, optimized for translucent terminal + Japanese background

# P10k configuration
() {
  emulate -L zsh -o extended_glob
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Single line prompt
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                     # current directory
    vcs                     # git status
    prompt_char            # prompt symbol
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code (errors only)
    command_execution_time  # duration (slow only)
    background_jobs         # bg processes
    virtualenv             # python env
    nvm                    # node version
  )

  # Muted color scheme (low contrast for translucent terminal)
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # Prompt character (muted zen colors)
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=108   # muted green
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=174 # muted red
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'

  # Directory (muted stone blue)
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=109                # muted blue-gray
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=102      # very muted
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=115         # muted teal
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

  # Directory anchors (project detection)
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
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  # Git (subtle earth tones)
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=108          # muted green
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=179      # muted yellow
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=179       # muted yellow
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=115   # muted teal
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Git performance
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=4096
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

  # Status (subtle warnings)
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=174 # muted red
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=174   # muted red
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false

  # Execution time (subtle)
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=102 # very muted
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  # Background jobs (subtle)
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=179     # muted yellow

  # Language versions (project context only)
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=108          # muted green
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  typeset -g POWERLEVEL9K_NVM_FOREGROUND=115                 # muted teal
  typeset -g POWERLEVEL9K_NVM_PROMPT_ALWAYS_SHOW=false

  # Context (minimal - only when needed)
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=174        # muted red
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=179 # muted yellow
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=102             # very muted
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  # Hide context unless needed (remote/root)
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  # Performance and behavior
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # Reload if already loaded
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell p10k which config file to use
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}