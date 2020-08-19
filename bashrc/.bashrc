# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias update_terimnal_configs='sh -c $(curl -fsSL "https://raw.githubusercontent.com/IvanBabushkin/terminal/master/2_install.sh")'
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && exec tmux -2 new -s $USER || tmux -2 attach -t $USER