chsh -s /bin/fish # change default shell to fish

fish -c "conda config --set auto_activate_base false" # disable conda auto-activation

rm -rf ~/.thunderbird # remove default thunderbird config (should be empty folder)

rclone config reconnect remote: --auto-confirm  # reconnect rclone remote...
rclone copy remote:.ssh/ ~/.ssh/ -P --fast-list # ... but just recover ssh keys ...
chmod 600 ~/.ssh/id_rsa ~/.ssh/config           # ... and then set the correct permissions ...
rsync -aP kenny@kenny-server:~/Laptop/ ~/       # ... and then recover from local server using rsync
# rclone copy remote: ~ -P --fast-list --checkers=32 --transfers=16 # ... and recover from cloud using rclone

ensure_model() {
    local repo_id="$1" revision="${2:-}" name folder
    if [ -z "$repo_id" ]; then
        echo "ensure_model: repo_id is empty" >&2
        return 1
    fi

    name="$(basename "$repo_id")"
    folder="$HOME/.local/share/localai/models/tabbyAPI/$name"
    if [ ! -d "$folder" ]; then
        local cmd=(localai launch -- download "$repo_id")
        if [ -n "$revision" ]; then
            cmd+=(--revision "$revision")
        fi
        trap 'rm -rf "$folder"' EXIT
        "${cmd[@]}"
        local dl_status=$?
        trap - EXIT
        if [ "$dl_status" -ne 0 ] || [ ! -d "$folder" ]; then
            rm -rf "$folder"
            echo "ensure_model: download failed or did not produce $folder" >&2
            return 1
        fi
    fi

    ln -s -f "$HOME/.dotfiles/home/.local/share/localai/models/tabbyAPI/$name/tabby_config.yml" \
             "$folder/tabby_config.yml"
}

# restored local model backups (rsync above), fill in any gaps from HuggingFace
ensure_model yeasah/Ornith-1.5-35B-A3B-exl3 6.00bpw
ensure_model JRramirez-UAB/Swift-1.5-Qwen3.8-Flash-Next-EXL3-2.25bpw-48GB
ensure_model erlidev/Swift-1.5-Qwen3.8-27B-EXL3 SC_5.00bpw_H6_V6

chmod +x ~/Automations/anti_burn_in/*.py # make sure the scripts here are executable

chmod 600 ~/.ssh/id_rsa # set the correct permissions for private keys
git clone git@github.com:colonelwatch/logseq ~/Logseq # only works after ssh key is recovered

gh auth login -p https -h github.com -w
