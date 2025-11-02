# dotfiles

If I ever need to nuke the Linux install on my laptop, this repo documents everything I need to get back up and running again, including a bootstrap script that automates as much of the process as possible. This includes things that are specific to my hardware.

## Pre-Install

0. Manually backup home
    * Desginate new directories to backup by editing `~/Automations/run_rclone_sync.sh` (currently hosted on Google Drive, not Github)
    * Execute `~/Automations/run_rclone_sync.sh -P --fast-list --checkers=32 --transfers=16`

## Install

1. Booting from the *latest* Live USB (can always be found at https://mirrors.mit.edu/archlinux/iso/latest/archlinux-x86_64.iso), immediately connect to a wifi network using the command `iwctl --passphrase=<PASSHRASE> station wlan0 connect <SSID>`

2. Install the latest `archinstall`

3. Choose the following settings in `archinstall` (all else default):
    * `Mirror region`: self-explanatory
    * `Drives`: Main HDD, nuke all partitions, and no separate home partition
    * `hostname`: `kenny-laptop`
    * `User account`: self-explanatory
    * `Profile`: `desktop`, `awesome`, `Intel (open source)`
    * `Audio`: `pipewire`
    * `kernels`: `['linux-zen']`
    * `Network configuration`: `Copy ISO configuration`
    * `Timezone`: self-explanatory

4. *Do not* restart yet. Select "yes" when asked to chroot, call `sudo su - kenny` to switch users, then call `cd ~`

## Post-Install

5. Install `git` with the command `sudo pacman -S git`

6. Clone this repository with the command `git clone https://github.com/colonelwatch/dotfiles .dotfiles`, call `cd .dotfiles && bash ./bootstrap.sh`

7. Restart

## Post-Bootstrap

8. Connect to WiFi network through `nmtui` and manually set DNS to `1.1.1.1`, `1.0.0.1`, and `8.8.8.8`

9. Call `cd .dotfiles && bash ./recovery.sh`, which includes manual prompts and recovery
    * Enter user password to set `fish` as the login shell
    * Authorize home recovery from Google Drive by logging in on the browser
    * Accept github fingerprint (if necessary) to proceed with Logseq graph recovery

10. `connect` and `trust` the Airpods Pro 2 (`C0:95:6D:A7:F1:4D`) through `bluetoothctl`

11. Configure line-in and line-out levels through `pactl` by device:
    * PCM2900C Audio Codec Line-in: 65536
    * PCM2900C Audio Codec Line-out: 65536
    * Airpods Pro 2: *currently uncalibrated*
    * Airpods Pro 2: *controlled by hand*

## Manual Program Configurations

Besides signing in, some programs need specific configurations that cannot be just carried over.
* Configure Firefox into its permanent privacy mode
* Sign into the Chrome browser with my personal email
* Set up Zotero
    * Disable syncing attachment files
    * Enable Zotero syncing with zotero.org
    * Enable Zotero plugin with LibreOffice
    * Run `bash patch_zotero.sh` in `Automations/patch_zotero`
* Configure the Logseq repository at `~/Logseq`:
    * Checkout the `dev` branch
    * Enable the pre-commit scripts with `pre-commit install`
* Open Logseq graph at `~/Logseq` and add the Git plugin

## Virtualization

It may be useful to test this repository on a VM before nuking the laptop.

1. Download the latest archlinux ISO at https://mirrors.mit.edu/archlinux/iso/latest/archlinux-x86_64.iso

2. Create a new virtual machine using `virt-manager` using `archlinux-x86_64.iso` as the CD ISO

3. Proceed with the above directions