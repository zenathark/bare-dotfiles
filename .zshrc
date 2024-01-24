export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions ssh-agent)

source $ZSH/oh-my-zsh.sh
source $HOME/.local-private.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias config="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
eval "$(starship init zsh)"
