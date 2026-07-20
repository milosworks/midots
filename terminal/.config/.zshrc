# Env
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='code'
fi

export VISUAL="code --wait"

# Hist config
mkdir -p "$HOME/.local/state/zsh"

export HISTFILE="$HOME/.local/state/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000

ZSH_COMPDUMP=~/.cache/zsh/zcompdump-$ZSH_VERSION

# Oh My Zsh
export ZSH="$HOME/.local/share/oh-my-zsh"

# disabled so it doesnt fight with starship
ZSH_THEME=""

# OMZ Plugins
plugins=(
  gitfast
  archlinux
  sudo
  history-substring-search
  podman
  fzf

  rust
  golang
  bun
)

source $ZSH/oh-my-zsh.sh

# External plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# must be very last plugin sourced
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Tool init
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Aliases
alias fup='flatpak update'
alias pacin='sudo pacman -S'
alias pacrm='sudo pacman -Runs'
alias pacs='pacman -Ss'
alias pacup='sudo pacman -Syu'
alias yain='yay -S'

alias fastfetch='fastfetch --logo $(find ~/dotfiles/ansi -type f | shuf -n 1)'
alias ff='fastfetch'
alias lava='lavat -g -G -c D32F2F -k 70021a -s 6 -r 4 -b 12'

alias c='clear'
alias cat='bat'
alias dotconfig='$EDITOR ~/dotfiles/'
alias eza='eza --icons --group-directories-first --grid --git --hyperlink'
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias tree='eza --tree'
