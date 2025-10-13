# =========================
# ⚡ ZSH + Powerlevel10k Optimized Config (No Oh-My-Zsh)
# =========================

# -------------------------
# 🚀 Powerlevel10k Instant Prompt (MUST stay at top)
# -------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------
# 🌍 Environment Variables
# -------------------------
export PATH="$HOME/bin:$PATH"

# -------------------------
# 🎨 Theme: Powerlevel10k
# -------------------------
[[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]] && \
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# -------------------------
# 🧠 Plugins (Manual)
# -------------------------

# Autosuggestions (must be before syntax highlighting)
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'  # Dim gray
fi

# Syntax highlighting (must be last)
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# -------------------------
# 🛠 AUR Helper Detection
# -------------------------
if pacman -Qi yay &>/dev/null; then
  aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
  aurhelper="paru"
fi

# -------------------------
# 🧰 Custom Functions
# -------------------------

# Install packages from repo or AUR
in() {
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

# Fuzzy change directory
fcd() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf) && cd "$dir"
}

# Fuzzy file search and open in nvim
ff() {
  local file
  file=$(find . -type f 2>/dev/null | fzf) || return
  nvim "$file"
}

# Command not found handler
command_not_found_handler() {
  echo "zsh: command not found: $1"
  return 127
}

# -------------------------
# 🧭 Aliases
# -------------------------
alias ls='eza -1 --icons=auto'
alias fe='exit'
alias home='cd ~'
alias down='cd ~/Downloads'
alias doc='cd ~/Documents'

# -------------------------
# 📝 Keybindings
# -------------------------
bindkey -v  # Vi mode (optional — comment out if you prefer emacs mode)

# Optional: Accept autosuggestions with Ctrl+Space (more reliable in vi mode)
bindkey '^ ' autosuggest-accept

# -------------------------
# 🌟 Extras
# -------------------------

# Better history settings
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY

# Completion system
autoload -Uz compinit
compinit

# Case-insensitive tab completion (so down<Tab> → Downloads)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

