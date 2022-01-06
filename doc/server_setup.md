# Deploy on new server

## Ubuntu

Assume lowest version is 16.04.

### System

#### Add new sudo user

```bash
export username=meijieru
sudo adduser ${username}
sudo usermod -aG sudo ${username}

su ${username}
chsh -s /bin/zsh ${username}
```

- To add home directory for existing users `mkhomedir_helper ${username}`

#### SSH

Usually copy from other machine.

### Utilities

#### Anaconda

```bash
mkdir ~/lib
cd ~/lib
export anaconda_url=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
wget ${anaconda_url} -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/lib/anaconda
```

#### Neovim

Deps

```bash
# available on ubuntu16.04
sudo apt install lua5.3
```

#### tmux

```bash
sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update
sudo apt install tmux-next
```
