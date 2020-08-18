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

if [ "$EUID" -ne 0 ]; 
then
  error "Please run as root"
  exit 1
fi

if [ -f /etc/redhat-release ]; then
  run_echo "Ok it's CentOS, go .."
else
    error "CentOS only"
    exit 1
fi

run_echo "Install Deps"
sudo yum install -y gcc kernel-devel make ncurses-devel git wget curl nano tar zsh> /dev/null 2>&1 || {
    error "make install Deps"
    exit 1
}

if [[ $(tmux -V) == "tmux $tmuxversion" ]]
then
    run_echo Tmux $tmuxversion installed
else
    sudo rm -rf ~/Downloads/tmux > /dev/null 2>&1
    sudo mkdir -p ~/Downloads/tmux > /dev/null 2>&1

    run_echo "Download and install libevent"
    sudo cd ~/Downloads/tmux

    curl -OL "https://github.com/libevent/libevent/releases/download/release-$libeventversion-stable/libevent-$libeventversion-stable.tar.gz" >/dev/null 2>&1 || {
        error "Download libevent"
        exit 1
    }
    tar -xvzf "libevent-$libeventversion-stable.tar.gz" >/dev/null 2>&1 || {
        error "Tar libevent"
        exit 1
    }
    cd "libevent-$libeventversion-stable" >/dev/null 2>&1
    ./configure --prefix=/usr/local >/dev/null 2>&1 || {
        error "configure libevent"
        exit 1
    }
    sudo make >/dev/null 2>&1 || {
        error "make libevent"
        exit 1
    }
    sudo make install >/dev/null 2>&1 || {
        error "make install libevent"
        exit 1
    }

    run_echo "Download and install Tmux"
    sudo cd ~/Downloads/tmux
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
    sudo LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr >/dev/null 2>&1 || {
        error "configure tmux"
        exit 1
    }
    sudo make >/dev/null 2>&1 || {
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
    error "Tmux $tmuxversion not installed"
fi

