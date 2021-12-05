# Collections of my dotfiles

## Deploy

```sh
export REPO=ssh://git@direct.meijieru.com:2222/meijieru/chezmoi.git
chezmoi init --apply ${REPO}
```

To preview the change,

```sh
chezmoi apply --dry-run --verbose
```

## Neovim

Check [doc](./dot_config/lvim/doc/nvim.md)
