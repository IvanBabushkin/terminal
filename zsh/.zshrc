
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="me"
HIST_STAMPS="dd.mm.yyyy"
plugins=(
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    history
    git
    docker
    docker-compose
    django
    redis-cli
    colored-man-pages
    compleat
    rsync
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'
source $ZSH/oh-my-zsh.sh