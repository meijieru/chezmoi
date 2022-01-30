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

Check [doc](./doc/server_setup.md).

## Setup win10

Check [doc](./doc/win10.md), still work in progress.

## Setup NAS

Check [wiki](https://gitea.meijieru.com/meijieru/nas_management/wiki/?action=_pages).

## Neovim

Check [doc](./doc/nvim.md).

### Cheatsheets

Check [doc](./doc/cheatsheet.md).
