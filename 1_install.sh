#!/bin/bash
set -e

libeventversion=2.1.11
tmuxversion=3.1

setup_color() {
	# Only use colors if connected to a terminal
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error:${RESET} $@" >&2
}

run_echo() {
    echo ${BLUE}"Run:${RESET} $@" >&2
}

setup_color

if [ ! -f /etc/redhat-release ]; then
    error "CentOS only"
    exit 1
fi

if [[ $(tmux -V) == "tmux $tmuxversion" ]]
then
    run_echo "Tmux $tmuxversion installed"
else
    error "Tmux $tmuxversion not installed"
    exit 1
fi

if [[ ! $(zsh --version)  ]]
then
    error "zsh not installed"
    exit 1
fi


rm -rf ~/.oh-my-zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

