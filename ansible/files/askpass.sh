#!/bin/sh
# sudo askpass helper for tools that call sudo themselves (yay). The
# password comes from the task's environment, never from a file or argv.
printf '%s\n' "$DOTFILES_SUDO_PASS"
