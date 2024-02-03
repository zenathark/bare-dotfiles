export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions ssh-agent)

source $ZSH/oh-my-zsh.sh
source $HOME/.local-private.sh

export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH=$HOME/.tmuxifier/bin:$PATH
eval "$(tmuxifier init -)"

alias config="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
eval "$(starship init zsh)"
#if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false

export AWS_EC2_METADATA_DISABLED=true

