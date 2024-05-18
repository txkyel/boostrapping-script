#### INSTALL QTILE
cd $HOME

# Install dependencies
sudo apt install xserver-xorg xinit -y
sudo apt install libpangocairo-1.0-0 -y
sudo apt install python3-pip python3-xcffib python3-cairocffi -y

# Install qtile and dependencies
pip install dbus-next --break-system-packages
pip install qtile --break-system-packages

# Xsessions Desktop file
cat > ./temp << "EOF"
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Type=Application
Keywords=wm;tiling
EOF

sudo cp ./temp /usr/share/xsessions/qtile.desktop
sudo echo "Exec=$HOME/.local/bin/qtile start" | sudo tee -a /usr/share/xsessions/qtile.desktop

# Cleanup
rm ./temp


### INSTALL TERMINAL + SHELL
sudo apt install git neovim -y
# TODO: Add install scripts

#### INSTALL CONFIGS
# Ignore repo configs
echo ".dotfiles" >> .gitignore

# Clone dotfiles
git clone --bare https://github.com/txkyel/dotfiles.git $HOME/.dotfiles

# Setup alias
config="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# Ignore untracked files
$config config --local status.showUntrackedFiles no

# Remove all conflicting changes
# TODO: Add script/alias for backing and restoring conflicting configs
# NOTE: you can "config stash apply" to apply the local version of the file
$config stash

rm .gitignore
