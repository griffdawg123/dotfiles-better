# dotfiles — griffdawg

Stow-managed dotfiles for an Arch Linux / Hyprland / Wayland desktop.
Colour scheme throughout is **Zen** (dark charcoal, slate-teal, seafoam accents).

---

## Initial setup

One command per machine. It installs ansible if needed, then installs
packages and stows the right dotfiles for this machine's profile:

```bash
git clone git@github.com:griffdawg123/dotfiles-better.git ~/.local/src/dotfiles
~/.local/src/dotfiles/bootstrap.sh            # profile from hostname
~/.local/src/dotfiles/bootstrap.sh laptop     # or name it
~/.local/src/dotfiles/bootstrap.sh -- --check # dry run
```

| Profile | Machine | Prompt |
|---|---|---|
| `desktop` | CachyOS tower, two BenQs | powerlevel10k |
| `laptop` | CachyOS laptop, docks to the same BenQs | starship |
| `work` | Ubuntu under WSL — shell and editor only | starship |

- **Hostname → profile** mapping: `ansible/vars/hosts.yml`
- **Packages and stow list** per profile: `ansible/vars/profiles/<profile>.yml`
- **Existing files in the way** stop the run with a list. Links that already
  point into this repo are replaced automatically; for real files, move them
  or rerun with `./bootstrap.sh -- -e dotfiles_backup=true` to move them to
  `~/.dotfiles-backup/<timestamp>/`.

On WSL, pin the hostname so the profile lookup is stable, then restart WSL:

```ini
# /etc/wsl.conf
[network]
hostname = work-wsl
```

The SDDM theme targets the system root and is not handled by the playbook:

```bash
sudo stow --dir=~/.local/src/dotfiles --target=/ sddm
```

### Per-machine Hyprland config

`hypr/.config/hypr/` is shared, with differences in `hosts/<profile>/`:

- `init.lua` — extra autostart and overrides; the laptop's also handles docking (desk screens get the shared layout from `modules/monitors.lua`: workspace 1 left, 2–10 on the GL2580; the laptop screen shows the scratchpad)
- `hypridle.conf`, `hyprlock.conf` — the top-level files are symlinks to these

The playbook links `hypr/.config/hypr/host` to the machine's profile
(gitignored). Validate changes without reloading:

```bash
Hyprland --verify-config -c ~/.config/hypr/hyprland.lua
```

---

## Packages

### Active — Hyprland / Wayland stack

| Package | Configures | Required packages |
|---|---|---|
| `hypr` | Hyprland (Lua config) — keybinds, window rules, per-host monitors; hypridle, hyprlock, hyprpaper | see `ansible/vars/packages.yml` |
| `quickshell` | Wayland status bar (QML) — full bar on the GL2580 (or the only screen), slim bar elsewhere; battery/brightness only where present | `quickshell` |
| `sddm` | Login manager — Zen-themed QML greeter with clock, fingerprint support, keyring unlock | `sddm` `qt5-quickcontrols2` `fprintd` `gnome-keyring` |
| `alacritty` | Terminal emulator — Zen colours, 0xProto Nerd Font, transparent background | `alacritty` `ttf-0xproto-nerd` |
| `rofi` | App launcher (`Super+R`), power menu (`Super+X`), emoji picker (`Super+E`), game launcher (`Super+G`) | `rofi-wayland` `rofi-games`(AUR) `rofimoji` `wtype` `wl-clipboard` |
| `bluetuith` | TUI Bluetooth manager with vim keybinds | `bluetuith` |
| `zen` | Canonical Zen palette — shell colour exports sourced by scripts and other configs | — |

### Active — Shell / Editor

| Package | Configures | Required packages |
|---|---|---|
| `zsh` | Zsh config — aliases, PATH, tool integrations | `zsh` `bat` `fd` `eza` `zoxide` `fzf` `nvm` |
| `tmux` | tmux config and plugins (TPM, tmux-fzf, tmuxifier, vim-tmux-navigator) | `tmux` — run `prefix + I` after first launch to install plugins |
| `starship` | Shell prompt (laptop, work) — git status, language versions, battery, command duration | `starship` |
| `p10k` | Powerlevel10k prompt (desktop) — used when `~/.oh-my-zsh` exists | `oh-my-zsh` `zsh-theme-powerlevel10k` |
| `fzf` | fzf-git integration scripts sourced by `.zshrc` | `fzf` `git` |
| `nvim_new` | Neovim config (lazy.nvim) — **currently active** | `neovim` |

### Active — Apps

| Package | Configures | Required packages |
|---|---|---|
| `spotify-wayland` | Spotify Ozone/Wayland flags | `spotify` |
| `BetterDiscord` | BetterDiscord theme | `discord` `betterdiscord`(AUR) |
| `ghostty` | Ghostty terminal config | `ghostty` |
| `tschuss` | Logout / session-end screen | `tschuss`(AUR) |

### Legacy — X11 / AwesomeWM era

These packages remain in the repo for reference but are not part of the active setup.

| Package | Notes |
|---|---|
| `awesome` | AwesomeWM config |
| `picom` | X11 compositor |
| `polybar` | X11 status bar |
| `waybar` | Wayland status bar, superseded by `quickshell` |
| `dunst` | Notification daemon, superseded by `mako` |
| `fuzzel` | App launcher, superseded by `rofi` |
| `nvim_lazy` `nvim_packer` | Old Neovim configs, superseded by `nvim_new` |

---

## SDDM notes

The SDDM stow package targets `/` rather than `~`, so the theme lands in
`/usr/share/sddm/themes/zen/` where the greeter can read it.

After enabling SDDM for the first time:

```bash
sudo systemctl enable sddm
sudo systemctl disable greetd   # or whatever the previous DM was
```

Fingerprint and keyring unlock are handled by `/etc/pam.d/sddm` — ensure
`pam_fprintd.so` and `pam_gnome_keyring.so` are present in that file.

---

## Zen colour palette

The canonical palette lives in `zen/.config/zen/zen.sh` and is sourced
by scripts that need hex values. Mirrors exist in:

- `hypr/.config/hypr/modules/palette.lua` — rgba format for Hyprland borders
- `alacritty/.config/alacritty/zen-colors.toml` — Alacritty colour scheme
- `quickshell/.config/quickshell/Theme.qml` — QML colour properties
- `rofi/.config/rofi/colors/zen.rasi` — Rofi colour variables

| Role | Hex |
|---|---|
| Background | `#1c1c1c` |
| Surface | `#303030` |
| Foreground / Accent 1 | `#87afaf` |
| Accent 2 | `#87d7af` |
| Green | `#87af87` |
| Yellow | `#d7af5f` |
| Red | `#d78787` |
