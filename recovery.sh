chsh -s /bin/fish # change default shell to fish

fish -c "conda config --set auto_activate_base false" # disable conda auto-activation

rm -rf ~/.thunderbird # remove default thunderbird config (should be empty folder)

rclone config reconnect remote: --auto-confirm  # reconnect rclone remote...
rclone copy remote:.ssh/ ~/.ssh/ -P --fast-list # ... but just recover ssh keys ...
chmod 600 ~/.ssh/id_rsa ~/.ssh/config           # ... and then set the correct permissions ...
rsync -aP kenny@kenny-server:~/Laptop/ ~/       # ... and then recover from local server using rsync
# rclone copy remote: ~ -P --fast-list --checkers=32 --transfers=16 # ... and recover from cloud using rclone

chmod +x ~/Automations/anti_burn_in/*.py # make sure the scripts here are executable

chmod 600 ~/.ssh/id_rsa # set the correct permissions for private keys
git clone git@github.com:colonelwatch/logseq ~/Logseq # only works after ssh key is recovered

gh auth login -p https -h github.com -w
