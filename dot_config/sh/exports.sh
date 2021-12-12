# Modified/Stolen from:
# http://mths.be/dotfiles

# Make vim the default editor
if [ -x "$(command -v nvim)" ]; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi
export GIT_EDITOR=${EDITOR}

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
if [ -x "$(command -v nvimpager)" ]; then
    export PAGER=nvimpager
else
    export PAGER="less -X"
fi
export MANPAGER=$PAGER

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# term
export TERM="xterm-256color"

# Customize to your needs...
export -U PATH=$HOME/.local/bin/:$PATH
export -U LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH

export GTAGSLABEL='native-pygments'
export GTAGSCONF=$HOME/.config/gtags.conf

export XAUTHORITY=$HOME/.Xauthority

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export _ZL_DATA=$XDG_STATE_HOME/zlua
export WGETRC=$XDG_CONFIG_HOME/wgetrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
export ACKRC=$XDG_CONFIG_HOME/ack/ackrc
export WAKATIME_HOME=$XDG_CONFIG_HOME/wakatime
# export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export IPYTHONDIR=$XDG_CONFIG_HOME/ipython
export JUPYTER_CONFIG_DIR=$XDG_CONFIG_HOME/jupyter
# export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/config
