#!/bin/bash
set -e

libeventversion=2.1.11
tmuxversion=3.1

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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

