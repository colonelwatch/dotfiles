# SYSTEM CONFIGURATION

sudo cp -f system/pacman.conf /etc/
sudo pacman -Syuu --noconfirm

sudo pacman -S bolt nvidia-lts udiskie udisks2 --noconfirm # necessary for eGPU setup

sudo pacman -S intel-undervolt --noconfirm
sudo cp -f system/intel-undervolt.conf /etc/
sudo intel-undervolt apply
sudo systemctl enable intel-undervolt.service

sudo cp -f system/zram-generator.conf /etc/systemd/ # expands swap space to RAM size

sudo pacman -S cronie networkmanager samba jre-openjdk libimobiledevice --noconfirm # system essentials
sudo systemctl enable cronie.service
sudo systemctl enable NetworkManager.service

sudo pacman -S bluez bluez-utils --noconfirm
sudo cp -f system/main.conf /etc/bluetooth/
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

sudo pacman -S vim man rofi pcmanfm vlc fish zip unzip ranger --noconfirm # desktop essentials
yay -S macchina-bin gtk-theme-numix-solarized piavpn-bin --noconfirm --removemake --answerdiff=None
sudo pacman -S firefox discord thunderbird --noconfirm # web essentials
yay -S google-chrome slack-desktop zoom logseq-desktop-bin --noconfirm --removemake --answerdiff=None
sudo pacman -S steam lutris --noconfirm # gaming
sudo pacman -S ruby --noconfirm # programming
yay -S visual-studio-code-bin --noconfirm --removemake --answerdiff=None
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3_install.sh
sudo pacman -S audacity calibre gimp libreoffice-fresh qemu-full --noconfirm # other tools
yay -S zotero-bin --noconfirm --removemake --answerdiff=None

sudo systemctl enable piavpn.service

gem install jekyll bundler
bash ~/miniconda3_install.sh -b # conda will soon be intialized by importing the fish config

sudo pacman -Sc --noconfirm
yay -Sc --noconfirm
rm ~/miniconda3_install.sh

sudo cp -f system/steam.desktop /usr/share/applications/steam.desktop
sudo cp -f system/audacity.desktop /usr/share/applications/audacity.desktop



# USER-SPACE CONFIGURATION

crontab crontab.bak

git submodule update --init --recursive
mkdir -p ~/.config

mkdir -p ~/.config/rclone # not symlink b/c will contain keys
cp ~/.dotfiles/config/rclone/rclone.conf ~/.config/rclone/
# rclone is not authorized yet, so authorize manually in recovery.sh

# remove default configs (should be empty folder)
rm -rf ~/.config/gtk-3.0 # remove default gtk config (should be empty folder)
rm -rf ~/.config/fish

ln -s -f ~/.dotfiles/.bashrc ~/
ln -s -f ~/.dotfiles/.gtkrc-2.0 ~/
ln -s ~/.dotfiles/config/awesome ~/.config/
ln -s ~/.dotfiles/config/alacritty ~/.config/
ln -s ~/.dotfiles/config/chrome-flags.conf ~/.config/
ln -s ~/.dotfiles/config/fish ~/.config/
ln -s ~/.dotfiles/config/gtk-3.0 ~/.config/
ln -s ~/.dotfiles/config/macchina ~/.config/
ln -s ~/.dotfiles/config/lutris ~/.config/
ln -s ~/.dotfiles/config/rofi ~/.config/
ln -s ~/.dotfiles/.gitconfig ~/
ln -s ~/.dotfiles/.Xresources ~/