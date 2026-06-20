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

yay -S --noconfirm --answerdiff=None --sudoloop                             \
    acpi alsa-utils bluez bluez-utils bolt brightnessctl cpupower cronie    \
    dnsmasq exfatprogs jre-openjdk libimobiledevice linux-zen-headers       \
    networkmanager nvidia-open-dkms playerctl reflector samba sof-firmware  \
    ttf-font-awesome udiskie udisks2 xclip

# install config files
sudo rm /boot/loader/entries/* # remove default entries
sudo cp -rvf --no-preserve=mode,ownership root/boot/loader/* /boot/loader/
sudo cp -rvf --no-preserve=mode,ownership root/etc/* /etc/

sudo systemctl enable                                   \
    bluetooth.service cpupower.service cronie.service   \
    NetworkManager.service reflector.service

# </ROOT>



# <USER>

# install packages
yay -S --noconfirm --answerdiff=None --sudoloop                             \
    audacity adw-gtk-theme bc bluetui discord firefox fish freecad fd       \
    fuse2 github-cli ghostscript gimp git-lfs google-chrome imagemagick     \
    inkscape jq kicad kicad-library kicad-library-3d libreoffice-fresh      \
    logseq-desktop-electron-bin ltspice lutris macchina man neovim          \
    otf-ipafont parallel pcmanfm perl-image-exiftool picom-git pre-commit   \
    prismlauncher prusa-slicer pyenv qdirstat qemu-desktop ripgrep rclone   \
    rsync rofi rpcs3-bin ruby steam thunderbird ttf-ia-writer               \
    ttf-jetbrains-mono-nerd ttf-ms-win10-cdn tree tree-sitter-cli unzip     \
    virt-manager visual-studio-code-bin vlc xclip yazi zip zopfli           \
    zotero-bin

# install awesome-luajit-git with docs explicitly disabled (breaks with Lua 5.5)
_BUILD_DOCS=0 yay -S --noconfirm --answerdiff=None awesome-luajit-git

# install jekyll through ruby
gem install jekyll bundler

# download and execute miniconda install script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3_install.sh
bash ~/miniconda3_install.sh -b # conda will soon be intialized by importing the fish config
rm ~/miniconda3_install.sh

# install config files
mkdir -p ~/.config
ln -s -f $PWD/config/* ~/.config/

# install home files by hand (NOTE: ~/ is far less flat than ~/.config)
ln -s -f $PWD/home/.bashrc ~/
ln -s -f $PWD/home/.gitconfig ~/
ln -s -f $PWD/home/.xinitrc ~/
ln -s -f $PWD/home/.Xresources ~/
mkdir -p ~/.local/share/applications
ln -s -f $PWD/home/.local/share/applications/* ~/.local/share/applications/

# libvirt is actually a root service!
sudo cp -f root/etc/libvirt/libvirtd.conf /etc/libvirt/ 

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

systemctl --user enable ssh-agent.service

# </USER>



# <CLEANUP>

yay -Sc --noconfirm

# </CLEANUP>
