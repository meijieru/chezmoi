# load fzf
for file in /usr/share/fzf/{key-bindings,completion}.zsh; do
    [ -f "$file" ] && source "$file"
done
unset file

# macos
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# wsl
if [[ $(uname -r) =~ WSL2$ ]]; then
    unsetopt BG_NICE
    unsetopt beep
    umask 022

    # # x410
    # export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

    export GDK_SCALE=2
    export QT_SCALE_FACTOR=2

    # otherwise opengl program may failed
    export LIBGL_ALWAYS_INDIRECT=0

    # xdg-open
    if [[ -z $BROWSER ]]; then
        export BROWSER=wslview
    else
        export BROWSER=${BROWSER}:wslview
    fi
fi

# load zoxide
if [ -x "$(command -v zoxide)" ]; then
    eval "$(zoxide init zsh)"
fi

# load anaconda
if [[ -f $HOME/lib/anaconda/bin/conda ]]; then
    export ANACONDA_HOME=${HOME}/lib/anaconda
    eval "$(${ANACONDA_HOME}/bin/conda shell.$(echo "$SHELL" | sed "s/.*\///") hook)"
fi

# load brew
brew_home=/home/linuxbrew/.linuxbrew
if [[ -f ${brew_home}/bin/brew ]]; then
    export PATH=${brew_home}/bin:${PATH}
    export LD_LIBRARY_PATH=${brew_home}/lib:${LD_LIBRARY_PATH}
fi

# google related
# source the common Brain bashrc (go/brain-bashrc)
if [ -r /google/data/ro/teams/brain-frameworks/config/ml_bashrc ]; then
    source /google/data/ro/teams/brain-frameworks/config/ml_bashrc
fi
if [[ -f /etc/bash_completion.d/g4d ]]; then
    . /etc/bash_completion.d/p4
    . /etc/bash_completion.d/g4d
fi
if [[ -f /etc/bash_completion.d/hgd ]]; then
    source /etc/bash_completion.d/hgd
fi
