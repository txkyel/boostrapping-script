#!/bin/sh

#### Bootstrapping script for minimal Debian install ###

sudo apt install git alacritty zsh -y
chsh -s $(which zsh)

### Install dotfiles
cd $HOME
echo ".dotfiles" >> .gitignore   # Ignore repo configs
git clone --bare https://github.com/txkyel/dotfiles.git $HOME/.dotfiles
config="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
$config config --local status.showUntrackedFiles no
# Remove conflicting changes
$config stash
# Remove README
$config update-index --assume-unchanged README.md
rm README.md
# Cleanup
unset config
rm .gitignore

### Build qtile
# Install dependencies
sudo apt install -y \
    xorg \
    xserver-xorg \
    python3 \
    python3-pip \
    python3-venv \
    python3-cffi \
    python3-cairocffi \
    python3-dbus-next \
    libpangocairo-1.0-0

[ -d "$HOME/.local/src/" ] || mkdir -p "$HOME/.local/src/" 
cd $HOME/.local/src/
python3 -m venv qtile_venv
cd qtile_venv/
git clone https://github.com/qtile/qtile.git
bin/pip install qtile/.
[ -d "$HOME/.local/bin/" ] || mkdir -p "$HOME/.local/bin/"
cp qtile $HOME/.local/bin/

### Build neovim
# Install dependencies
sudo apt install -y \
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    build-essential

cd $HOME/.local
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build \
    && cpack -G DEB \
    && sudo dpkg -i nvim-linux64.deb
