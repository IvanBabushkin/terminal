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

if [ -f /etc/redhat-release ]; then
  run_echo "ok it's centons"
else
    error "CentOS only"
    exit 1
fi

run_echo "Install zsh"
sudo yum install -y zsh


if [[ $(tmux -V) == "tmux $tmuxversion" ]]
then
    run_echo Tmux $tmuxversion installed
else
    run_echo "Install Tmux"
    run_echo "Install Deps"
    rm -rf ~/Downloads/tmux
    mkdir -p ~/Downloads/tmux
    yum install -y gcc kernel-devel make ncurses-devel git wget curl zsh >/dev/null 2>&1 || {
        error "Install deps"
        exit 1
    }

    run_echo "Download and install libevent"

    cd ~/Downloads/tmux

    curl -OL "https://github.com/libevent/libevent/releases/download/release-$libeventversion-stable/libevent-$libeventversion-stable.tar.gz" >/dev/null 2>&1 || {
        error "download libevent"
        exit 1
    }
    tar -xvzf "libevent-$libeventversion-stable.tar.gz" >/dev/null 2>&1 || {
        error "tar libevent"
        exit 1
    }
    cd "libevent-$libeventversion-stable" >/dev/null 2>&1
    ./configure --prefix=/usr/local >/dev/null 2>&1 || {
        error "configure libevent"
        exit 1
    }
    make >/dev/null 2>&1 || {
        error "make libevent"
        exit 1
    }
    sudo make install >/dev/null 2>&1 || {
        error "make install libevent"
        exit 1
    }
    cd ..

    run_echo "Download and install Tmux"
    curl -OL "https://github.com/tmux/tmux/releases/download/$tmuxversion/tmux-$tmuxversion.tar.gz" >/dev/null 2>&1 || {
        error "download tmux"
        exit 1
    }
    tar -xvzf "tmux-$tmuxversion.tar.gz" >/dev/null 2>&1 || {
        error "tar tmux"
        exit 1
    }
    cd "tmux-$tmuxversion" >/dev/null 2>&1 || {
        exit 1
    }
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr >/dev/null 2>&1 || {
        error "configure tmux"
        exit 1
    }
    make >/dev/null 2>&1 || {
        error "make tmux"
        exit 1
    }
    sudo make install >/dev/null 2>&1 || {
        error "make install tmux"
        exit 1
    }

fi


if [[ $(tmux -V) == "tmux $tmuxversion" ]]
then
    run_echo "Tmux $tmuxversion installed"
else
    error "Install Tmux"
fi


run_echo "Install oh-my-zsh plugins"
mkdir -p ~/.oh-my-zsh/custom/plugins/
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions

run_echo "Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

