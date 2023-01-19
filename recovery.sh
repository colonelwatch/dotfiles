chsh -s /bin/fish # change default shell to fish

fish -c "conda config --set auto_activate_base false" # disable conda auto-activation

rm -rf ~/.thunderbird # remove default thunderbird config (should be empty folder)

rclone config reconnect remote: --auto-confirm
rclone copy remote: ~ -P --fast-list --checkers=32 --transfers=16

chmod 600 ~/.ssh/id_rsa # set the correct permissions for private keys
git clone git@github.com:colonelwatch/logseq ~/Logseq # only works after ssh key is recovered