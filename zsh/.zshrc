
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="me"
HIST_STAMPS="dd.mm.yyyy"
plugins=(
    #compleat
    colored-man-pages
    common-aliases
    cp
    django
    docker
    docker-compose
    git
    history
    redis-cli
    rsync
    sudo
    supervisor
    zsh-autosuggestions
    zsh-interactive-cd
    zsh-syntax-highlighting
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'

# ALIAS
alias update_terimnal_configs='sh -c $(curl -fsSL "https://raw.githubusercontent.com/IvanBabushkin/terminal/master/2_install.sh")'

source $ZSH/oh-my-zsh.sh