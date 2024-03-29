#zmodload zsh/zprof
# Created by newuser for 5.9
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.config/.script:$PATH
export XDG_CONFIG_HOME="$HOME/.config"

export LIBVA_DRIVER_NAME=radeonsi
export XDG_SESSION_TYPE=wayland
export WLR_NO_HARDWARE_CURSORS=1
export MOZ_ENABLE_WAYLAND=1

set -o vi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load theme
zinit ice pick"async.zsh" lucid wait"!0" src"pure.zsh"
zinit light sindresorhus/pure

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


# Load plugin
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \

zinit ice wait"1" lucid
zinit light lukechilds/zsh-nvm

#

# aliases
## refresh packages
alias ua-drop-caches='sudo paccache -rk3; paru -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && paru -Syyu --noconfirm'

alias sudo='sudo '
alias vim='nvim'

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias ip='ip --color=auto'

alias la='ls -A'
alias ll='ls -Al'
alias sp='wl-clipboard-history -l'

# alias for packages
alias ua-drop-caches='sudo paccache -rk3; paru -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && paru -Syyu --noconfirm'

# alias for git dotfiles
alias config='/usr/bin/git --git-dir=/home/xun/.cfg/ --work-tree=/home/xun/'

# proxy
alias proxy='source ~/.config/.script/proxy.sh'

# joshuto
alias jo='joshuto'

#zprof
