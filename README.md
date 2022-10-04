# dotfiles

If I ever need to nuke the Linux install on my XPS, this repo documents everything I need to get back up and running again, including a bootstrap script that automates as much of the process as possible. This includes things that are specific to my hardware.

## Install

1. Booting from the Live USB with `archinstall` 2.5.0, immediately connect to a wifi network using the command `iwctl --passphrase=<PASSHRASE> station wlan0 connect <SSID>`
    * Currently, using `archinstall` 2.5.1 is bugged for my configuration

2. The GPG key database usually gets corrupted, so ignore signatures by calling `vim /etc/pacman.conf` then changing the line `SigLevel    = Required DatabaseOptional` to `SigLevel    = Never`.

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

## Post-Install

4. Install `git` with the command `sudo pacman -S git`

5. `git clone` this repository and execute `bootstrap.sh`

## Post-Bootstrap

6. Authorize thunderbolt devices through `boltctl`

7. `connect` and `trust` the Samsung Galaxy Buds Plus (`80:7B:3E:52:53:F4`) through `bluetoothctl`

8. Add `mitigations=off i915.enable_fbc=1` flags to kernel

9. Configure firefox in permanent privacy mode

10. Restart

11. Load backed-up home files (`Zotero`, `Calibre Library`, etc) from USB or Google Drive