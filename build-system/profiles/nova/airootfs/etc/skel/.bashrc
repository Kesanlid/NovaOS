# ~/.bashrc - User bash configuration for NovaOS

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ====================
# Aliases
# ====================

alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Package management
alias pacsyu='sudo pacman -Syu'
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -R'
alias pacrs='sudo pacman -Rs'

# System
alias updatedb='sudo updatedb'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
alias halt='sudo halt'

# Gaming
alias gamemode='gamemoderun'
alias mangohud='MANGOHUD=1 mangohud'

# ====================
# Environment
# ====================

# Prompt (NovaOS style)
PS1='\[\033[01;31m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \$ '

# Color support
export CLICOLOR=1

# Editor
export EDITOR=vim
export VISUAL=vim

# ====================
# Functions
# ====================

# Quick extract
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Make directory and cd into it
mkcd() {
    mkdir -p "$@" && cd "$@"
}

# ====================
# History
# ====================

# Don't put duplicate lines in history
HISTCONTROL=ignoredups:erasedups

# Append to history
shopt -s histappend

# History size
HISTSIZE=10000
HISTFILESIZE=20000

# ====================
# Shell Options
# ====================

# Check window size after each command
shopt -s checkwinsize

# Autocorrect typos in path
shopt -s cdspell

# Enable programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
