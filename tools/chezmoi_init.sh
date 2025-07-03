# manually install chezmoi if needed
if [[ -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
fi

cd ~/.local || exit
if ! [[ -x "$(command -v chezmoi)" ]]; then
    echo "Installing chezmoi."
    sh -c "$(curl -fsLS git.io/chezmoi)"
fi

export -U PATH=$HOME/.local/bin/:$PATH

export REPO=git@github.com:meijieru/chezmoi.git
chezmoi init --apply ${REPO}
