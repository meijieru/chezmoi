# My Dotfiles

This repository contains my personal dotfiles, managed by [chezmoi](https://www.chezmoi.io/).

## Prerequisites

- `git`
- `curl`
- `zsh`

## Installation

To bootstrap in one line:

```bash
zsh -c "$(curl -fsLS https://raw.githubusercontent.com/meijieru/chezmoi/master/tools/chezmoi_init.sh)"
```

## Usage

To preview changes, run:

```bash
chezmoi apply --dry-run --verbose
```

## Other Setups

### Remote Server

Check [doc](./doc/server_setup.md).

### NAS

Check [wiki](https://gitea.meijieru.com/meijieru/nas_management/wiki/?action=_pages).
