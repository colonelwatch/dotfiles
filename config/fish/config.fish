if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_config theme choose solarized --color-theme=light
end

set fish_greeting

set -gx EDITOR nvim
set -gx GEM_HOME "$(gem env user_gemhome)"
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# set XDG spec (for life of script, so below behaves like new silent defaults)
set -l XDG_DATA_HOME "$HOME"/.local/share
set -l XDG_CONFIG_HOME "$HOME"/.config
set -l XDG_STATE_HOME "$HOME"/.local/state
set -l XDG_CACHE_HOME "$HOME"/.cache

# use XDG spec
set -gx BUNDLE_USER_CACHE "$XDG_CACHE_HOME"/bundle
set -gx BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME"/bundle/config
set -gx BUNDLE_USER_PLUGIN "$XDG_DATA_HOME"/bundle
set -gx PYENV_ROOT "$XDG_DATA_HOME"/pyenv
set -gx SCREENRC "$XDG_CONFIG_HOME"/screen/screenrc
set -gx SCREENDIR "$XDG_RUNTIME_DIR"/screen
set -gx TRITON_HOME "$XDG_CACHE_HOME"/triton

# pyenv setup and build options
set -gx PYTHON_CONFIGURE_OPTS '--enable-optimizations --with-lto'
set -gx PYTHON_CFLAGS '-march=native -mtune=native'
set -gx MAKE_OPTS "-j$(nproc)"
pyenv init - fish | source

fish_add_path -g "$GEM_HOME/bin"
fish_add_path -g "$HOME"/.local/bin

eval "$(fnm env)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/kenny/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# Unlike other interactive cmds, run macchina last to stop a graphical glitch
if status is-interactive
    macchina
end
