# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# less with color
alias less="less -R"

# override prezto utility `mkdir -p`
alias mkdir="nocorrect mkdir"

# Customize to your needs...
alias mk='make'
alias zc='z -c' # match subdir of current dir
# alias zz='z -i' # interactively
# alias zf='z -I' # fuzzy finder
alias zb='z -b'
alias zbi='z -b -i' # jump to parent dir
alias zbf='z -b -I' # jump to parent dir using fzf
alias wget='wget --hsts-file="$XDG_STATE_HOME/wget-hsts"'
alias glow='PAGER= glow'

alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

alias tp='trash-put'
alias tl='trash-list'
alias rm='echo "This is not the command you are looking for."; false'

if [ -x "$(command -v xclip)" ]; then
    alias copytoclipboard='xclip -selection c'
    alias pastefromclipboard='xclip -o -selection c'
fi

if [ -x "$(command -v eza)" ]; then
    exa="eza"
elif [ -x "$(command -v exa)" ]; then
    exa="exa"
fi
if [ -n "${exa}" ]; then
    alias l="${exa} --long --icons"
    alias ll="${exa} --long --icons --all"
    alias lg="${exa} --long --header --git --icons"
    alias ls="${exa}"
    alias tree="${exa} --tree"
fi

if [ -x "$(command -v dust)" ]; then
    alias du="dust"
fi

if [ -x "$(command -v duf)" ]; then
    alias df="duf"
fi

if [ -x "$(command -v bat)" ]; then
    alias cat="bat"
fi

if [ -x "$(command -v btop)" ]; then
    alias top="btop"
    alias htop="btop"
fi

if [ -x "$(command -v fastfetch)" ]; then
    alias neofetch="fastfetch"
fi

if [ -x "$(command -v nvim)" ]; then
    alias vim='nvim'
    alias vi='nvim'
    alias vimdiff='nvim -d'
fi

# debian use a different name
if [ -x "$(command -v fdfind)" ]; then
    alias fd='fdfind'
fi
