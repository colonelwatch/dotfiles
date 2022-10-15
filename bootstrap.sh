# SYSTEM CONFIGURATION

sudo cp -f system/pacman.conf /etc
sudo pacman -Syuu --noconfirm

sudo pacman -S bolt nvidia-lts udiskie udisks2 xf86-video-intel --noconfirm # necessary for eGPU setup
sudo cp -f system/20-intel.conf /etc/X11/xorg.conf.d # sets tearfree

sudo pacman -S intel-undervolt --noconfirm
sudo cp -f system/intel-undervolt.conf /etc
sudo intel-undervolt apply
sudo systemctl enable intel-undervolt.service

sudo cp -f system/zram-generator.conf /etc/systemd # expands swap space to RAM size

sudo pacman -S cronie networkmanager --noconfirm # system essentials
sudo systemctl enable cronie.service
sudo systemctl enable NetworkManager.service

sudo pacman -S bluez bluez-utils --noconfirm
sudo cp -f system/main.conf /etc/bluetooth/main.conf
sudo systemctl enable bluetooth.service

sudo pacman -S acpi alsa-utils brightnessctl playerctl --noconfirm # used by AwesomeWM exts



# PROGRAM INSTALLATION

sudo pacman -S gnome-keyring --noconfirm # deps not covered in proceeding installs

# installing yay manually before using yay to get other AUR programs
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg --syncdeps --rmdeps --noconfirm
sudo pacman -U *.pkg.tar.zst --noconfirm
cd ..
rm -rf yay

sudo pacman -S rclone --noconfirm # used for restore and automatic backups of home

sudo pacman -S vim man rofi pcmanfm vlc --noconfirm # desktop essentials
yay -S macchina --noconfirm --removemake --answerdiff=None
sudo pacman -S firefox discord --noconfirm # web essentials
yay -S google-chrome slack-desktop zoom --noconfirm --removemake --answerdiff=None
sudo pacman -S steam lutris --noconfirm # gaming
yay -S visual-studio-code-bin --noconfirm --removemake --answerdiff=None # programming
sudo pacman -S audacity calibre gimp libreoffice-fresh --noconfirm # other tools
yay -S zotero-bin --noconfirm --removemake --answerdiff=None

sudo pacman -Sc --noconfirm
yay -Sc --noconfirm
rm -rf ~/.cargo # remove leftover rust files

sudo cp -f system/google-chrome.desktop /usr/share/applications/google-chrome.desktop
sudo cp -f system/steam.desktop /usr/share/applications/steam.desktop
sudo cp -f system/audacity.desktop /usr/share/applications/audacity.desktop



# USER-SPACE CONFIGURATION

crontab crontab.bak

git submodule update --init --recursive
mkdir -p ~/.config

mkdir -p ~/.config/rclone # not symlink b/c will contain keys
cp ~/.dotfiles/.config/rclone/rclone.conf ~/.config/rclone
# rclone is not authorized yet, so authorize manually in recovery.sh

ln -s -f ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.config/awesome ~/.config/awesome
ln -s ~/.dotfiles/.config/macchina ~/.config/macchina
ln -s ~/.dotfiles/.config/lutris ~/.config/
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.Xresources ~/.Xresources