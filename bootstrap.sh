# SYSTEM CONFIGURATION

sudo cp -f root/pacman.conf /etc/
sudo pacman -Syuu --noconfirm

sudo pacman -S bolt linux-zen-headers nvidia-dkms udiskie udisks2 --noconfirm # necessary for eGPU setup

# setting frequency to the maximum is needed before calling the undervolt
sudo pacman -S cpupower --noconfirm
sudo cp -f root/etc/default/cpupower /etc/default/
sudo cpupower frequency-set --governor performance
sudo systemctl enable cpupower.service

sudo pacman -S intel-undervolt --noconfirm
sudo cp -f root/etc/intel-undervolt.conf /etc/
sudo intel-undervolt apply
sudo systemctl enable intel-undervolt.service
sudo systemctl enable intel-undervolt-loop.service

sudo cp -f root/etc/systemd/zram-generator.conf /etc/systemd/ # expands swap space to RAM size

sudo pacman -S cronie networkmanager samba jre-openjdk libimobiledevice --noconfirm # system essentials
sudo systemctl enable cronie.service
sudo systemctl enable NetworkManager.service

sudo pacman -S bluez bluez-utils --noconfirm
sudo cp -f root/etc/bluetooth/main.conf /etc/bluetooth/
sudo systemctl enable bluetooth.service

sudo pacman -S acpi alsa-utils brightnessctl ttf-font-awesome playerctl xclip --noconfirm # used by AwesomeWM exts



# PROGRAM INSTALLATION

sudo pacman -S gnome-keyring --noconfirm # deps not covered in proceeding installs

# installing yay manually before using yay to get other AUR programs
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg --syncdeps --rmdeps --noconfirm
sudo pacman -U *.pkg.tar.zst --noconfirm
cd ..
rm -rf yay-bin

sudo pacman -S rclone --noconfirm # used for restore and automatic backups of home

sudo pacman -S ttf-jetbrains-mono otf-ipafont --noconfirm # fonts
yay -S ttf-ms-win10-auto --noconfirm --removemake --answerdiff=None --sudoloop # msfonts known to need sudoloop

yay -S ncurses5-compat-libs --noconfirm --removemake --answerdiff=None
wget https://www.passmark.com/downloads/pt_linux_x64.zip -O ~/pt_linux_x64.zip
unzip ~/pt_linux_x64.zip
sudo cp -f ~/PerformanceTest/pt_linux_x64 /usr/bin/pt # typical calls are: `pt` or `pt -r 1`
rm -rf ~/pt_linux_x64.zip ~/PerformanceTest

sudo pacman -S vim man rofi pcmanfm vlc fish zip unzip ranger nm-connection-editor --noconfirm # desktop essentials
yay -S macchina-bin gtk-theme-numix-solarized piavpn-bin --noconfirm --removemake --answerdiff=None
sudo pacman -S firefox discord thunderbird --noconfirm # web essentials
yay -S google-chrome slack-desktop zoom logseq-desktop-bin --noconfirm --removemake --answerdiff=None
sudo pacman -S steam lutris --noconfirm # gaming
sudo pacman -S ruby --noconfirm # programming
yay -S visual-studio-code-bin --noconfirm --removemake --answerdiff=None
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3_install.sh
sudo pacman -S audacity calibre gimp inkscape imagemagick libreoffice-fresh qemu-full --noconfirm # other tools
yay -S zotero-bin --noconfirm --removemake --answerdiff=None

sudo systemctl enable piavpn.service

gem install jekyll bundler
bash ~/miniconda3_install.sh -b # conda will soon be intialized by importing the fish config

sudo pacman -Sc --noconfirm
yay -Sc --noconfirm
rm ~/miniconda3_install.sh

sudo cp -f root/usr/share/applications/steam.desktop /usr/share/applications/
sudo cp -f root/usr/share/applications/audacity.desktop /usr/share/applications/
sudo cp -f root/usr/share/applications/org.inkscape.Inkscape.desktop /usr/share/applications/



# USER-SPACE CONFIGURATION

crontab crontab.bak

git submodule update --init --recursive
mkdir -p ~/.config

mkdir -p ~/.config/rclone # not symlink b/c will contain keys
cp ~/.dotfiles/config/rclone/rclone.conf ~/.config/rclone/
# rclone is not authorized yet, so authorize manually in recovery.sh

ln -s -f ~/.dotfiles/home/.bashrc ~/
ln -s -f ~/.dotfiles/home/.gtkrc-2.0 ~/
ln -s -f ~/.dotfiles/home/.gitconfig ~/
ln -s -f ~/.dotfiles/home/.Xresources ~/
ln -s -f ~/.dotfiles/config/awesome ~/.config/
ln -s -f ~/.dotfiles/config/alacritty ~/.config/
ln -s -f ~/.dotfiles/config/chrome-flags.conf ~/.config/
ln -s -f ~/.dotfiles/config/fish ~/.config/
ln -s -f ~/.dotfiles/config/gtk-3.0 ~/.config/
ln -s -f ~/.dotfiles/config/macchina ~/.config/
ln -s -f ~/.dotfiles/config/lutris ~/.config/
ln -s -f ~/.dotfiles/config/rofi ~/.config/