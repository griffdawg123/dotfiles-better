# dotfiles — griffdawg

Stow-managed dotfiles for an Arch Linux / Hyprland / Wayland desktop.
Colour scheme throughout is **Zen** (dark charcoal, slate-teal, seafoam accents).

---

## Initial setup

### Prerequisites

```bash
sudo pacman -S git stow
```

### Clone and deploy

```bash
git clone git@github.com:griffdawg123/dotfiles-better.git ~/.dotfiles
cd ~/.dotfiles
```

Most packages stow into `~`:

```bash
stow alacritty bluetuith fzf ghostty hypr nvim_new quickshell \
     rofi sddm starship tmux tschuss zen zsh spotify-wayland \
     BetterDiscord
```

The SDDM theme targets the system root (requires sudo):

```bash
sudo stow --dir=~/.dotfiles --target=/ sddm
```

---

## Packages

### Active — Hyprland / Wayland stack

| Package | Configures | Required packages |
|---|---|---|
| `hypr` | Hyprland WM, keybinds, window rules, hypridle, hyprlock, hyprpaper | `hyprland` `hyprpaper` `hypridle` `hyprlock` `hyprshot` `swaync` `swayosd` `blueman` `brightnessctl` `pavucontrol` `aichat` |
| `quickshell` | Wayland status bar (QML) — workspaces, clock, battery, volume, brightness, media | `quickshell` |
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
| `starship` | Shell prompt — git status, language versions, battery, command duration | `starship` |
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
| `dunst` | Notification daemon, superseded by `swaync` |
| `fuzzel` | App launcher, superseded by `rofi` |
| `p10k` | Powerlevel10k prompt, superseded by `starship` |
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

- `hypr/.config/hypr/colors.conf` — rgba format for Hyprland borders
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
