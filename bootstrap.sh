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
    acpi adw-gtk-theme alsa-utils bluez bolt brightnessctl cpupower cronie  \
    dnsmasq exfatprogs fuse2 jre-openjdk linux-zen-headers networkmanager   \
    nvidia-open-dkms otf-ipafont playerctl qemu-desktop reflector samba     \
    sof-firmware woff2-font-awesome ttf-ia-writer ttf-jetbrains-mono-nerd   \
    ttf-ms-win10-cdn udiskie udisks2

# install config files
sudo rm /boot/loader/entries/* # remove default entries
sudo cp -rvf --no-preserve=mode,ownership root/boot/loader/* /boot/loader/
sudo cp -rvf --no-preserve=mode,ownership root/etc/* /etc/

sudo systemctl daemon-reload
sudo systemctl enable                                       \
    bluetooth.service cpupower.service cronie.service       \
    intel-rapl-performance.service NetworkManager.service   \
    reflector.service

# </ROOT>



# <USER>

# install packages
yay -S --noconfirm --answerdiff=None --sudoloop                             \
    audacity antigravity antigravity-cli bc bluetui bun discord firefox     \
    fish freecad fd flatpak github-cli ghostscript gimp git-lfs gparted     \
    imagemagick inkscape jq kicad kicad-library kicad-library-3d            \
    libreoffice-fresh ltspice lutris macchina man-db neovim nodejs npm      \
    parallel perl-image-exiftool picom-git polkit-gnome pre-commit          \
    prismlauncher prusa-slicer pyenv python-pydantic                        \
    python-pydantic-settings rpi-imager ripgrep rclone rsync rofi ruby      \
    steam thunderbird trash-cli tree tree-sitter-cli unzip virt-manager vlc \
    xclip yazi zip zopfli

# install awesome-luajit-git with docs explicitly disabled (breaks with Lua 5.5)
_BUILD_DOCS=0 yay -S --noconfirm --answerdiff=None awesome-luajit-git

flatpak install --noninteractive flathub                                    \
    com.google.Chrome org.zotero.Zotero io.github.streetpea.Chiaki4deck     \
    io.github.shundhammer.qdirstat net.rpcs3.RPCS3 com.logseq.Logseq

# install and set up lsfg-vk for flatpak
ver="v1.0.0"
prefix="https://github.com/PancakeTAS/lsfg-vk/releases/download/$ver"
for ver in "23.08" "24.08" "25.08"; do
    f="org.freedesktop.Platform.VulkanLayer.lsfg_vk_$ver.flatpak"
    wget "$prefix/$f"
    flatpak install --noninteractive --user $f
    rm $f
done
for app in "io.github.streetpea.Chiaki4deck" "net.rpcs3.RPCS3"; do
    flatpak override --user --filesystem $HOME/.config/lsfg-vk:ro "$app"
    flatpak override --user     \
        --env LSFG_CONFIG=$HOME/.config/lsfg-vk/conf.toml "$app"
done

# given Logseq access to pre-commit
sudo flatpak override --filesystem host-os:ro com.logseq.Logseq
sudo flatpak override --env PYTHONPATH=/run/host/lib/python3.14/site-packages

# install jekyll through ruby
gem install jekyll bundler

# download and execute miniconda install script
# TODO: remove?
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3_install.sh
bash ~/miniconda3_install.sh -b # conda will soon be intialized by importing the fish config
rm ~/miniconda3_install.sh

# install pi (and extensions)
export BUN_INSTALL_CACHE_DIR="$HOME"/.cache/bun
export BUN_INSTALL_BIN="$HOME"/.local/bin
export BUN_INSTALL="${XDG_DATA_HOME:-"$HOME"/.local/share}"/bun
export PATH="$PATH:$BUN_INSTALL_BIN"
bun add -g --ignore-scripts @earendil-works/pi-coding-agent
pi install git:github.com/earendil-works/pi-review

# install config files
mkdir -p ~/.config
ln -s -f $PWD/config/* ~/.config/

# install home files by hand (NOTE: ~/ is far less flat than ~/.config)
ln -s -f $PWD/home/.bashrc ~/
ln -s -f $PWD/home/.gitconfig ~/
ln -s -f $PWD/home/.xinitrc ~/
ln -s -f $PWD/home/.Xresources ~/
mkdir -p ~/.local/bin
ln -s -f $PWD/home/.local/bin/* ~/.local/bin/
mkdir -p ~/.local/share/applications
ln -s -f $PWD/home/.local/share/applications/* ~/.local/share/applications/
mkdir -p ~/.pi/agent
ln -s -f $PWD/home/.pi/agent/* ~/.pi/agent/

cp -r -f $PWD/home/.var/app/* ~/.var/app/

model_dirs=(
    Ornith-1.5-35B-A3B-exl3
    Swift-1.5-Qwen3.8-Flash-Next-EXL3-2.25bpw-48GB
    Swift-1.5-Qwen3.8-27B-EXL3
)
base=$PWD/home/.local/share/localai/models/tabbyAPI
models_root=~/.local/share/localai/models/tabbyAPI
for m in "${model_dirs[@]}"; do
    mkdir -p "$models_root/$m/"
    ln -s -f "$base/$m/tabby_config.yml" "$models_root/$m/"
done

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
xdg-mime default yazi.desktop inode/directory # by default, vscode seems to be the default file manager
crontab crontab.bak

systemctl --user enable ssh-agent.service

# </USER>



# <CLEANUP>

yay -Sc --noconfirm

# </CLEANUP>
