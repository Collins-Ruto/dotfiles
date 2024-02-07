 set  fish_greeting 
 #oh-my-posh init fish --config ~/Documents/oh-my-posh-config/ompcollinsv1.json | source
 set -x PATH $PATH $HOME/.npm-packages/bin

 starship init fish | source

 source ~/.local/share/icons-in-terminal/icons.fish

# Add NVM to PATH for Fish shell
set -x PATH $HOME/.nvm/bin $PATH

# Load NVM
#source $HOME/.nvm/nvm.fish

# eval (python3.11 -m virtualfish)

export PATH="$PATH:$HOME/bin"

# Created by `pipx` on 2023-12-08 22:53:07
set PATH $PATH /home/collins/.local/bin

# aliases
alias gitconfunset="git config --unset-all --global user.name && git config --unset-all --global user.email"
alias gitconfset="git config --global user.email \"collinsruto48@gmail.com\" && git config --global user.name \"collins-ruto\""
