# dotfile
This Git repository stores the configuration files for my personal computer.

Use [chezmoi](https://github.com/twpayne/chezmoi) to manage my dotfile.

## Installation

Before proceeding, ensure have `Git` and `chezmoi` installed on system.

```bash
chezmoi init --apply https://github.com/Xunop/dotfiles.git
```

## Usage & Workflow

### Daily Commands

  * **`chezmoi update`**: **Pull** latest remote changes and apply them.
  * **`chezmoi edit <file>`**: **Edit** a managed file using your `$EDITOR`.
  * **`chezmoi apply`**: **Apply** pending changes to your home directory.
  * **`chezmoi diff`**: **See** what changes will be made before applying.

### Managing Files

1. To add a new file:

```bash
# Add the file to chezmoi's source state.
chezmoi add ~/.config/app/new.conf

# Commit and push the changes.
chezmoi cd
git add .
git commit -m "Add new.conf"
git push
```

2. To modify an existing file:

```bash
# Recommended: Edit the source file directly.
chezmoi edit ~/.config/app/existing.conf

# Apply the changes.
chezmoi apply

# Commit and push.
chezmoi cd && git commit -am "Update existing.conf" && git push
```

Alternatively, if you've edited the file in your home directory directly, run `chezmoi add <file>` to sync the changes back to the source state before committing.

3. To remove a file:

```bash
# Stop managing the file AND delete it from your system.
chezmoi remove ~/.config/app/old.conf

# To stop managing it but keep the local copy, use `chezmoi forget`.
```

4. To refresh a file's state:

```bash
# Re-read the file's content and permissions from the filesystem.
chezmoi re-add <file>
```

## Software & Configuration


| Category                | Application(s)                                                                          | Notes                                                              |
| ----------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| **Window Manager** | [Hyprland](https://hyprland.org/)                                                       | A dynamic tiling Wayland compositor.                               |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar)                                             | Wayland bar.                                   |
| **Terminal** | [Alacritty](https://alacritty.org/)                                                     | A terminal emulator. Theme: Tokyo Night.     |
| **Shell** | [Zsh](https://www.zsh.org/)                                                             | Zsh                      |
| **Multiplexer** | [Tmux](https://github.com/tmux/tmux)                                                    | Terminal multiplexer for managing multiple sessions.               |
| **App Launcher** | [Fuzzel](https://codeberg.org/dnkl/fuzzel) / [Rofi](https://github.com/davatorium/rofi) / [Wofi](https://hg.sr.ht/~scoopta/wofi) | Some app launchers.                     |
| **File Manager** | [Joshuto](https://github.com/kamiyaa/joshuto)                                           | A terminal-based file manager.                        |
| **Notifications** | [Dunst](https://dunst-project.org/)                                                     | A notification daemon.                  |
| **Input Method** | [Fcitx5](https://github.com/fcitx/fcitx5) + [Rime](https://rime.im/)                      | Configured for various Chinese input methods.   |
| **Browser Addons** | [Sidebery](https://addons.mozilla.org/en-US/firefox/addon/sidebery/) / [Tabliss](https://tabliss.io/) | Style configs for Firefox addons.                                  |

