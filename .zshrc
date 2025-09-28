# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prevent autoloading from unwanted custom function directories
fpath=(${fpath:#/home/bigyam/.config/zsh/functions})

# Oh-my-zsh installation path
ZSH=/usr/share/oh-my-zsh/

# Theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Plugins
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Detect AUR helper
if pacman -Qi yay &>/dev/null; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
   aurhelper="paru"
fi

# Install function
function in {
    local -a arch=() aur=()
    for pkg in "$@"; do
        if pacman -Si "$pkg" &>/dev/null; then
            arch+=("$pkg")
        else
            aur+=("$pkg")
        fi
    done

    (( ${#arch[@]} )) && sudo pacman -S "${arch[@]}"
    (( ${#aur[@]} )) && ${aurhelper} -S "${aur[@]}"
}

# Aliases
alias c='clear'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias un='$aurhelper -Rns'
alias up='$aurhelper -Syu'
alias pl='$aurhelper -Qs'
alias pa='$aurhelper -Ss'
alias pc='$aurhelper -Sc'
alias po='$aurhelper -Qtdq | $aurhelper -Rns -'
alias vc='code'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias mkdir='mkdir -p'

# Add this to your .zshrc before sourcing p10k
typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Fast command not found handler (disables auto search delay)
unset -f command_not_found_handler >/dev/null 2>&1 || true
command_not_found_handler() {
    echo "zsh: command not found: $1"
    return 127
}
# Vi mode
bindkey -v
export PATH="$HOME/bin:$PATH"

# Fuzzy directory search
fcd() {
  local dir
  dir=$(find . -type d | fzf) && cd "$dir"
}
# Fuzzy file search
ff() {
  local file
  file=$(find . -type f 2>/dev/null | fzf) || return
  nvim "$file"
}
