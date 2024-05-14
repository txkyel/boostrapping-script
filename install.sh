#### Installing Qtile ####
cd $HOME

# Install dependencies
sudo apt install pipx python3-cairocffi libpangocairo-1.0-0 git -y

# Install qtile and dependencies
pipx install qtile
pipx inject dbus-next qtile-extras

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



#### Clone dotfiles ####
# Ignore repo configs
echo ".dotfiles" >> .gitignore

# Clone dotfiles
git clone --bare git@github.com:txkyel/dotfiles.git $HOME/.dotfiles

# Setup alias
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# Ignore untracked files
config config --local status.showUntrackedFiles no

# Remove all conflicting changes
# NOTE: you can "config stash apply" to apply the local version of the file
config stash
