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

rm -rf ~/.oh-my-zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

run_echo "Install oh-my-zsh plugins"
mkdir -p ~/.oh-my-zsh/custom/plugins/

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    cd ~/.oh-my-zsh/custom/plugins/
    git clone https://github.com/zsh-users/zsh-autosuggestions >/dev/null 2>&1 || {
        error "install zsh-autosuggestions"
        exit 1
    }
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd ~/.oh-my-zsh/custom/plugins/
    git clone https://github.com/zsh-users/zsh-syntax-highlighting  >/dev/null 2>&1 || {
        error "zsh-syntax-highlighting"
        exit 1
    }
fi

run_echo "Install zsh config"
curl -fsSL https://raw.githubusercontent.com/IvanBabushkin/terminal/master/zsh/.zshrc > ~/.zshrc
run_echo "Install zsh theme"
mkdir -p ~/.oh-my-zsh/custom/themes/
curl -fsSL https://raw.githubusercontent.com/IvanBabushkin/terminal/master/zsh/theme/me.zsh-theme > ~/.oh-my-zsh/custom/themes/me.zsh-theme

run_echo "Install Tmux Plugin Manager"
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

run_echo "Install Tmux config"
curl -fsSL https://raw.githubusercontent.com/IvanBabushkin/terminal/master/tmux/.tmux.conf > ~/.tmux.conf
run_echo "Install bash config"
curl -fsSL https://raw.githubusercontent.com/IvanBabushkin/terminal/master/bashrc/.bashrc > ~/.bashrc
run_echo "load tmux: tmux new -s $USER || tmux attach -s $USER"
run_echo "Press prefix + I (capital i, as in Install) to fetch the plugin"

