# Commands to run in interactive sessions can go here
set -g fish_cache_dir $__fish_config_dir/tmp
if not test -d $fish_cache_dir
    command mkdir -p $fish_cache_dir
end

if status is-interactive
    if type -q atuin
        set -l atuin_cache $fish_cache_dir/atuin_init.fish
        set -l atuin_bin (command -v atuin)
        if not test -f $atuin_cache; or test $atuin_cache -ot $atuin_bin
            command atuin init fish >$atuin_cache
        end
        source $atuin_cache
    end
    if type -q starship
        set -l starship_cache $fish_cache_dir/starship_init.fish
        set -l starship_bin (command -v starship)
        if not test -f $starship_cache; or test $starship_cache -ot $starship_bin
            command starship init fish --print-full-init >$starship_cache
        end
        source $starship_cache
    end

    # [5.102] [PARSE ERROR] Unknown DCS escape code: $f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}�...
    # if status is-interactive
    #     printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
    # end

    if type -q direnv
        set -l direnv_cache $fish_cache_dir/direnv_hook.fish
        set -l direnv_bin (command -v direnv)
        if not test -f $direnv_cache; or test $direnv_cache -ot $direnv_bin
            command direnv hook fish >$direnv_cache
        end
        source $direnv_cache
    end

    # envman integration (skip generated loader to avoid per-shell touch calls)
    if not set -q ENVMAN_LOAD
        set -l envman_dir ~/.config/envman
        if test -d $envman_dir
            for env_file in ENV.env PATH.env
                set -l candidate $envman_dir/$env_file
                if test -s $candidate
                    source $candidate
                end
            end

            set -x ENVMAN_LOAD loaded

            if not set -q g_envman_load_fish
                for helper in function.fish alias.env
                    set -l candidate $envman_dir/$helper
                    if test -s $candidate
                        source $candidate
                    end
                end
                set -g g_envman_load_fish loaded
            end
        end
    end

    # eval (zellij setup --generate-auto-start fish | string collect)
end


# Custom fisher path
set -Ux fisher_path ~/.config/fish/fisher
! set --query fisher_path[1] || test "$fisher_path" = $__fish_config_dir && exit

set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

for file in $fisher_path/conf.d/*.fish
    source $file
end

scheme set catppuccin
# fish_config theme choose Catppuccin\ Mocha

source ~/.config/fish/user_variables.fish
source ~/.config/fish/abbreviations.fish
source ~/.config/fish/aliases.fish

# Python
#. ~/code/venv/bin/activate.fish

if test -e "/Users/$USER/.config/fish/secrets.fish"
    source ~/.config/fish/secrets.fish
end
if test -e "/Users/$USER/.config/fish/local-env.fish"
    source "/Users/$USER/.config/fish/local-env.fish"
end

# Google cloud
if test -e "/Users/$USER/Code/google-cloud-sdk/path.fish.inc"
    source "/Users/$USER/Code/google-cloud-sdk/path.fish.inc"
end

# bun
# set -x BUN_INSTALL "$HOME/.bun"
# fish_add_path $BUN_INSTALL/bin

alias pwdcopy=cppwd

# Prompt
# . $HOME/.config/fish/prompt.fish
# . $HOME/.config/fish/kubectl.fish

# NOTE: this interferes with Warp (https://docs.warp.dev/support-and-billing/known-issues#list-of-incompatible-tools)
# status --is-interactive; and /opt/homebrew/bin/rbenv init - fish | source

# Cargo
source "$HOME/.cargo/env.fish"
# source $"($nu.home-path)/.cargo/env.nu"  # For nushell

# usage: help eza
functions -c help fhelp

if type -q bat
    alias bathelp='bat --plain --language=help'
end

alias restart-ldc=restart-last-docker-container

set -lx warp_terminal test "$TERM_PROGRAM" != WarpTerminal
if ! $warp_terminal
    fzf --fish | source
end

# Wasmer
# export WASMER_DIR="/Users/$USER/.wasmer"
# [ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

#function ct --wraps=bat --description 'alias ct=bat'
#    bat $argv
#end
#function ctp --wraps='bat --paging=always' --description 'alias ctp=bat --paging=always'
#    bat --paging=always $argv
#end
#function sc --wraps='source $XDG_CONFIG_HOME/fish/config.fish' --description 'alias r=source $XDG_CONFIG_HOME/fish/config.fish'
#    source $XDG_CONFIG_HOME/fish/config.fish $argv
#end

source ~/.config/fish/zoxide.fish

# source /opt/homebrew/opt/asdf/libexec/asdf.fish

if not functions -q fhelp
    functions -c help fhelp
end

function help --description "Use bat to view help files"
    if not type -q bat
        fhelp $argv
        return
    end

    if test (count $argv) -gt 0
        command $argv[1] --help 2>&1 | command bat --plain --language=help
    else
        fhelp
    end
end

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

~/.local/bin/mise activate fish | source

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
