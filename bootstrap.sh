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

yay -S \
    acpi alsa-utils bluez bluez-utils bolt brightnessctl cpupower cronie dnsmasq gksu \
    jre-openjdk libimobiledevice linux-zen-headers networkmanager nvidia-open-dkms \
    playerctl reflector samba sof-firmware ttf-font-awesome udiskie udisks2 xclip \
    --noconfirm --removemake --answerdiff=None --sudoloop

# install config files
sudo rm /boot/loader/entries/* # remove default entries
sudo cp -rvf --no-preserve=mode,ownership root/boot/loader/* /boot/loader/
sudo cp -rvf --no-preserve=mode,ownership root/etc/* /etc/

sudo systemctl enable \
    bluetooth.service cpupower.service cronie.service NetworkManager.service \
    reflector.service

# </ROOT>



# <USER>

# install packages
MAKEFLAGS="-j$(nproc)" yay -S \
    audacity discord firefox fish freecad fd fuse2 ghostscript gimp git-lfs gnome-keyring google-chrome \
    gparted imagemagick inkscape jq kicad kicad-library kicad-library-3d libreoffice-fresh \
    logseq-desktop-bin lutris macchina man neovim nm-connection-editor otf-ipafont parallel \
    pcmanfm perl-image-exiftool prusa-slicer qemu-desktop ranger ripgrep rclone rsync rofi rpcs3-bin ruby steam \
    teensyduino thunderbird ttf-ia-writer ttf-jetbrains-mono ttf-ms-win10-cdn turbostat unzip virt-manager \
    visual-studio-code-bin vlc xclip zip zopfli zotero-bin \
    --noconfirm --removemake --answerdiff=None --sudoloop

# install jekyll through ruby
gem install jekyll bundler

# download and execute miniconda install script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3_install.sh
bash ~/miniconda3_install.sh -b # conda will soon be intialized by importing the fish config
rm ~/miniconda3_install.sh

# download passmark performancetest as a user binary
wget https://www.passmark.com/downloads/pt_linux_x64.zip -O ~/pt_linux_x64.zip
unzip ~/pt_linux_x64.zip -d ~/
sudo mv ~/PerformanceTest/pt_linux_x64 /usr/local/bin/pt
rm -rf ~/PerformanceTest
rm ~/pt_linux_x64.zip

# download and install latest (as of 2023-12-23) version of adw-gtk3
wget https://github.com/lassekongo83/adw-gtk3/releases/download/v5.2/adw-gtk3v5-2.tar.xz -O ~/adw-gtk3v5-2.tar.xz
mkdir ~/.local/share/themes
tar -xf ~/adw-gtk3v5-2.tar.xz -C ~/.local/share/themes
rm ~/adw-gtk3v5-2.tar.xz

# override .desktops with custom ones
sudo cp -rvf --no-preserve=mode,ownership root/usr/share/applications/* /usr/share/applications/

# install config files
mkdir -p ~/.config
# ln -s -f $PWD/home/* ~/ # uncomment if files besides dotfiles are added to home
ln -s -f $PWD/home/.* ~/ # we explicitly need to write out the pwd
ln -s -f $PWD/config/* ~/.config/
sudo cp -f root/etc/libvirt/libvirtd.conf /etc/libvirt/ # libvirt is actually a root service!

# deal with rclone config edge case
unlink ~/.config/rclone # undo symlink b/c it eventually contains keys we don't want to commit...
mkdir ~/.config/rclone  #  ...so we'll only copy the config files
cp ~/.dotfiles/config/rclone/rclone.conf ~/.config/rclone/
# rclone is not authorized yet, so authorize manually in recovery.sh

# other config
sudo usermod -a -G uucp,libvirt kenny # needed for arduino and virt-manager
sudo systemctl enable libvirtd.service
xdg-mime default pcmanfm.desktop inode/directory # by default, vscode seems to be the default file manager
crontab crontab.bak

# </USER>



# <CLEANUP>

yay -Sc --noconfirm

# </CLEANUP>
