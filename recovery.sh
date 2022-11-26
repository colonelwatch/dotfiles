rm -rf ~/.thunderbird # remove default thunderbird config (should be empty folder)

rclone config reconnect remote: --auto-confirm
rclone copy remote: ~ -P --fast-list --checkers=32 --transfers=16

git clone git@github.com:colonelwatch/logseq ~/Logseq # only works after ssh key is recovered

chsh -s /bin/fish