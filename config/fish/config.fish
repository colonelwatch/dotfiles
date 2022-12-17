if status is-interactive
    # Commands to run in interactive sessions can go here
    macchina
end

set fish_greeting
set EDITOR vim

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/kenny/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

