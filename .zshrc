export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source $HOME/.local-private.sh

alias config="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
eval "$(starship init zsh)"
