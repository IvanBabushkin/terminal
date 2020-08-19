#!/bin/bash
set -e
libeventversion=2.1.11
tmuxversion=3.1

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

setup_color() {
	# Only use colors if connected to a terminal
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
}

error() {
	echo ${RED}"Error:${RESET} $@" >&2
}

run_echo() {
    echo ${BLUE}"Run:${RESET} $@" >&2
}

prompt_confirm() {
  while true; do
    read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
    case $REPLY in
      [yY]) echo ; return 0 ;;
      [nN]) echo ; return 1 ;;
      *) echo ; return 1 ;;
    esac
  done
}

setup_color

if ! [ -f /etc/redhat-release ]; then
    error "CentOS only"
    exit 1
fi

run_echo $(command_exists tmux) lalala
if [ -f command_exists "tmux" ] && command_exists "zsh" && $(tmux -V) == "tmux $tmuxversion"; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/IvanBabushkin/terminal/master/1_install.sh)"
    exit 0
fi

echo ${RED}"Не установлены зависимости${RESET}" >&2
prompt_confirm "Установить? требуется root" || exit 0
sudo sh -c "$(curl -fsSL 'https://raw.githubusercontent.com/IvanBabushkin/terminal/master/0_install.sh')"

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/IvanBabushkin/terminal/master/install.sh)"

