if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

set -gx EDITOR nvim
set -gx GEM_HOME "$(gem env user_gemhome)"

fish_add_path -g "$GEM_HOME/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/kenny/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# Unlike other interactive cmds, run macchina last to stop a graphical glitch
if status is-interactive
    macchina
end
