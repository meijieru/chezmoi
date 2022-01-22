# load fzf
for file in /usr/share/fzf/{key-bindings,completion}.zsh; do
    [ -f "$file" ] && source "$file"
done
unset file

# wsl
if [[ $(uname -r) =~ Microsoft$ ]]; then
    unsetopt BG_NICE
    unsetopt beep
    umask 022

    export DISPLAY=localhost:0
    export GDK_SCALE=2
    export QT_SCALE_FACTOR=2

    # otherwise opengl program may failed
    export LIBGL_ALWAYS_INDIRECT=0
elif [[ $(uname -r) =~ WSL2$ ]]; then
    unsetopt BG_NICE
    unsetopt beep
    umask 022

    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
    export GDK_SCALE=2
    export QT_SCALE_FACTOR=2

    # otherwise opengl program may failed
    export LIBGL_ALWAYS_INDIRECT=0

    # xdg-open
    if [[ -z $BROWSER ]]; then
        export BROWSER=wsl-open
    else
        export BROWSER=${BROWSER}:wsl-open
    fi
fi

# load anaconda
if [[ -f $HOME/lib/anaconda/bin/conda ]]; then
    export ANACONDA_HOME=${HOME}/lib/anaconda
    eval "$(${ANACONDA_HOME}/bin/conda shell.$(echo "$SHELL" | sed "s/.*\///") hook)"
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
