if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/kenny/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

if status is-interactive # macchina is called last because it seems to prevent a glitch
    macchina
end