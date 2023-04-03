# <SETUP>

# check if pwd is ~/.dotfiles
if [ ! "$PWD" = "$HOME/.dotfiles" ]; then
    echo "Please run this script from the ~/.dotfiles directory."
    exit 1
fi

# acquire dependencies
git submodule update --init --recursive

# configure pacman
sudo cp -f root/etc/pacman.conf /etc/
sudo pacman -Syuu --noconfirm

# installing yay manually before using yay
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg --syncdeps --rmdeps --noconfirm
sudo pacman -U *.pkg.tar.zst --noconfirm
cd ..
rm -rf yay-bin

# </SETUP>



# <ROOT>

yay -Rs pipewire-pulse --noconfirm

yay -S \
    acpi alsa-utils bluez bluez-utils bolt brightnessctl cpupower cronie \
    jre-openjdk libimobiledevice linux-zen-headers networkmanager nvidia-open-dkms \
    playerctl samba sof-firmware ttf-font-awesome udiskie udisks2 xclip \
    --noconfirm --removemake --answerdiff=None --sudoloop

# install config files
sudo rm /boot/loader/entries/* # remove default entries
sudo cp -rvf --no-preserve=mode,ownership root/boot/loader/* /boot/loader/
sudo cp -rvf --no-preserve=mode,ownership root/etc/* /etc/

sudo systemctl enable \
    bluetooth.service cpupower.service cronie.service NetworkManager.service

# </ROOT>



# <USER>

# install packages
MAKEFLAGS="-j$(nproc)" yay -S \
    audacity calibre discord firefox fish ghostscript gimp gnome-keyring google-chrome \
    gtk-theme-numix-solarized imagemagick inkscape libreoffice-fresh \
    logseq-desktop-bin lutris macchina-bin man nm-connection-editor otf-ipafont \
    passmark-performancetest-bin pcmanfm piavpn-bin qemu-desktop ranger rclone rofi ruby steam teensyduino \
    thunderbird ttf-jetbrains-mono ttf-ms-win10-auto turbostat unzip vim virt-manager \
    visual-studio-code-bin vlc zip zoom zopfli zotero-bin \
    --noconfirm --removemake --answerdiff=None --sudoloop

# install jekyll through ruby
gem install jekyll bundler

# download and execute miniconda install script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3_install.sh
bash ~/miniconda3_install.sh -b # conda will soon be intialized by importing the fish config
rm ~/miniconda3_install.sh

# override .desktops with custom ones
sudo cp -rvf --no-preserve=mode,ownership root/usr/share/applications/* /usr/share/applications/

# install config files
mkdir -p ~/.config
ln -s -f $PWD/home/* ~/ # we explicitly need to write out the pwd
ln -s -f $PWD/home/.* ~/
ln -s -f $PWD/config/* ~/.config/
sudo cp -f root/etc/libvirt/libvirtd.conf /etc/libvirt/ # libvirt is actually a root service!

# deal with rclone config edge case
unlink ~/.config/rclone # undo symlink b/c it eventually contains keys we don't want to commit...
mkdir ~/.config/rclone  #  ...so we'll only copy the config files
cp ~/.dotfiles/config/rclone/rclone.conf ~/.config/rclone/
# rclone is not authorized yet, so authorize manually in recovery.sh

# other config
sudo systemctl enable piavpn.service
sudo usermod -a -G uucp,libvirt kenny # needed for arduino and virt-manager
xdg-mime default pcmanfm.desktop inode/directory # by default, vscode seems to be the default file manager
crontab crontab.bak

# </USER>



# <CLEANUP>

yay -Sc --noconfirm

# </CLEANUP>