# Collections of my dotfiles

## Deploy

```bash
# manually install chezmoi if needed 
mkdir -p ~/.local/bin
cd ~/.local
sh -c "$(curl -fsLS git.io/chezmoi)"
export -U PATH=$HOME/.local/bin/:$PATH

export REPO=ssh://git@direct.meijieru.com:2222/meijieru/chezmoi.git
chezmoi init --apply ${REPO}
```

To preview the change,

```bash
chezmoi apply --dry-run --verbose
```

## Setup remote server

Check [doc](./doc/server_setup.md)

## Neovim

Check [doc](./doc/nvim.md)
