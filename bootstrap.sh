sudo cp -f system/pacman.conf /etc
sudo chmod 644 /etc/pacman.conf
sudo pacman -Syuu

sudo pacman -S nvidia-lts udiskie udisks2 --noconfirm
sudo pacman -S acpi alsa-utils bolt brightnessctl intel-undervolt playerctl --noconfirm

sudo cp -f system/intel-undervolt.conf /etc
sudo chmod 644 /etc/intel-undervolt.conf
sudo intel-undervolt apply
sudo systemctl enable intel-undervolt.service


install_from_aur(){ # first arg is package name, second is git repo name
    git clone https://aur.archlinux.org/$1.git
    cd $1
    makepkg --syncdeps --rmdeps --noconfirm
    sudo pacman -U *.pkg.tar.zst --noconfirm
    cd ..
    rm -rf $1
}

sudo pacman -S firefox neofetch vim man rofi --noconfirm
sudo pacman -S steam lutris --noconfirm
sudo pacman -S discord --noconfirm
install_from_aur zoom
install_from_aur visual-studio-code-bin
install_from_aur google-chrome
install_from_aur slack-desktop

sudo cp -f system/google-chrome.desktop /usr/share/applications/google-chrome.desktop
sudo chmod 644 /usr/share/applications/google-chrome.desktop
sudo cp -f system/steam.desktop /usr/share/applications/steam.desktop
sudo chmod 644 /usr/share/applications/steam.desktop


git submodule update --init --recursive
mkdir -p ~/.config

ln -s -f ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.config/awesome ~/.config/awesome
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.Xresources ~/.Xresources