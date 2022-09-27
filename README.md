# dotfiles

If I ever need to nuke the Linux install on my XPS, this repo documents 
everything I need to get back up and running again, including a bootstrap script 
that automates as much of the process as possible. This includes things that 
are specific to my hardware.

## Setup

1. Booting from the Live USB, immediately connect to a wifi network using the 
command `iwctl --passphrase=<PASSHRASE> station wlan0 connect <SSID>`

2. Grab the latest copy of archinstall using the command `pacman -Sy archinstall`

3. Choose the following settings in `archinstall` (all else default):
    * `Mirror region`: self-explanatory
    * `Drives`: Main HDD, nuke all partitions, and no separate home partition
    * `hostname`: `kenny-xps`
    * `User account`: self-explanatory
    * `Profile`: `desktop`, `awesome`, `Intel (open source)`
    * `Audio`: `pipewire`
    * `kernels`: `['linux-lts']`
    * `Network configuration`: `Copy ISO configuration`
    * `Timezone`: self-explanatory

4. Install `git` with the command `sudo pacman -S git`

5. `git clone` this repository and execute `bootstrap.sh`

6. Follow any of the remaining manual steps and react to any errors