# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git zsh-autosuggestions)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Enable Vim keybindings
bindkey -v

# Fuzzy change directory
fcd() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf) && cd "$dir"
}

# Fuzzy file search and open in Neovim
ff() {
  local file
  file=$(find . -type f 2>/dev/null | fzf) || return
  nvim "$file"
}

# Bind Ctrl+F to fuzzy change directory
fzf_cd_widget() { fcd; zle reset-prompt }
zle -N fzf_cd_widget
bindkey '^F' fzf_cd_widget

# Bind Ctrl+P to fuzzy open file
fzf_file_widget() { ff; zle reset-prompt }
zle -N fzf_file_widget
bindkey '^P' fzf_file_widget

# Aliases
alias ls='eza -1 --icons=auto'
alias fe='exit'
alias off='shutdown now'
alias home='cd ~'
alias down='cd ~/Downloads'
alias doc='cd ~/Documents'
