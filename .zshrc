export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions ssh-agent)

source $ZSH/oh-my-zsh.sh
source $HOME/.local-private.sh

export EDITOR=nvim

alias ls="eza"
alias g="git"
alias vim="nvim"
alias gs="git status"
alias vi="nvim"
alias gd="git diff"
alias la="eza --all --git --header --icons --classify"
alias l="eza --grid --icons --git --classify"
alias ll="eza --all --long --icons --git --header --classify"
alias ls="eza --color=auto"
alias grep="grep --color=auto"
alias ..="cd .."
alias mv="mv -i"
alias rm="rm -i"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH=$HOME/.tmuxifier/bin:$PATH
eval "$(tmuxifier init -)"

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
alias config="git --git-dir=$HOME/dotfiles --work-tree=$HOME"

export SDKMAN_DIR="$HOME/.sdkman"

eval "$(zoxide init --cmd cd zsh)"

HOMEBREW_NO_ENV_HINTS=TRUE

eval "$(starship init zsh)"

