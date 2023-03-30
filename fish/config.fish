 set  fish_greeting 
 oh-my-posh init fish --config ~/Documents/oh-my-posh-config/ompcollinsv1.json | source
 set -x PATH $PATH $HOME/.npm-packages/bin

 starship init fish | source

 source ~/.local/share/icons-in-terminal/icons.fish

# Add NVM to PATH for Fish shell
set -x PATH $HOME/.nvm/bin $PATH

# Load NVM
#source $HOME/.nvm/nvm.fish
 #eval (python -m virtualfish)
