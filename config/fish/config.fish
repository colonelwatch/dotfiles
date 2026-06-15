if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_config theme choose solarized --color-theme=light
end

set fish_greeting

set -gx EDITOR nvim
set -gx GEM_HOME "$(gem env user_gemhome)"
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# pyenv options
set -gx PYTHON_CONFIGURE_OPTS '--enable-optimizations --with-lto'
set -gx PYTHON_CFLAGS '-march=native -mtune=native'
set -gx MAKE_OPTS "-j$(nproc)"

fish_add_path -g "$GEM_HOME/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/kenny/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# Unlike other interactive cmds, run macchina last to stop a graphical glitch
if status is-interactive
    macchina
end
