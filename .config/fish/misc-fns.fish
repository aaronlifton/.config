
function llr --wraps eza --description "lists the 5 most recently accessed files"
    eza -lag --header --across --sort accessed --color always | head -n 5
end

function eza -d "eza with auto-git"
    if git rev-parse --is-inside-work-tree &>/dev/null
        command eza --git --classify $argv
    else
        command eza --classify $argv
    end
end

# -- Git aliases --
function git-mr
    if test (count $argv) -gt 0
        git log --oneline --name-only HEAD~$ARGV[1]..HEAD
    else
        git log --oneline --name-only HEAD~10..HEAD
    end
end

# -- Functions --
function mancode --wraps man --description "open manpage in vscode"
    man -p cat $argv[1] | code -
end

function manvim --wraps man --description "open manpage in nvimpager"
    man -p cat $argv[1] | nvimpager
end

function nvimcat --wraps man --description "read file in nvimpager"
    cat $argv[1] | nvimpager
end

function testecho --description testecho
    echo $argv[1]
end

function gdeletemergedcurrent --wraps git --description 'delete all local branches that is already merged to current branch (excludes master and main)'
    git branch --merged | grep -v "\*" | grep -v master | grip -v main | xargs -n 1 git branch -d
    git remote prune origin
end

function gsearch --description "search google"
    curl "https://www.google.com/search?q=" | $argv[1]
end
function printpath --description "prints the path variable"
    string split " " (echo $path)
end

# edit functions
function editfish --description "Edit fish configuration"
    nvim ~/.config/fish/config.fish
end

function createSharedRootGroup --description "adds user provided via argument to a shared group with root"
    set -lx username $argv[1]
    set -lx sharedRootGroup $(dscl . list /Groups | grep "sharedroot" | awk '{print $1}')
    if [$sharedRootGroup = "sharedroot"]
        return
    else
        sudo dscl . create /Groups/sharedroot PrimaryGroupID 101
        sudo dscl . append /Groups/sharedroot GroupMembership $username
        sudo dscl . append /Groups/sharedroot GroupMembership root
        echo $(dscl . list /Groups | grep -C 5 "sharedroot")
    end
end

function shareFolderWithRoot --description "recursively chowns a folder to sharedroot group"
    set -lx folder $argv[1]
    set -lx sharedRootGroup $(dscl . list /Groups | grep "sharedroot" | awk '{print $1}')
    if $sharedRootGroup = sharedroot
        sudo chown -R :sharedroot $folder
    else
        echo "sharedroot group does not exist"
    end
end


# navigation functions
function viewfish --description "View fish configuration"
    bat -r 48:429 ~/.config/fish/config.fish
end

function cdnvim --description "cd into nvim configuration"
    cd ~/.config/nvim
end

function searchnvim --description "run fd in the nvim configuration directory"
    eval (fd mini.ai $lazy_path | awk 'NR == 1')
end

function editnvim --description "Edit nvim configuration"
    cdnvim
    nvim ~/.config/nvim
end

function viewnvim --description "view nvim configuration"
    bat ~/.config/nvim/lua/config/keymaps.lua
end

function editkarabiner --description "Edit karabiner configuration"
    nvim ~/.config/karabiner.edn
end

function viewkarabiner --description "view karabiner configuration"
    bat ~/.config/karabiner.edn
end

function edithammerspoon --description "Edit hammerspoon configuration"
    cd ~/.hammerspoon; and nvim ~/.hammerspoon/
end

function update-wez --description "Update wezterm"
    brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest
end
function editwezterm --description "Edit wezterm configuration"
    nvim ~/.config/wezterm/wezterm.lua
end

function viewwez --description "View wezterm configuration"
    bat ~/.config/wezterm/wezterm.lua
end

function editskhd --description "Edit skhd configuration"
    nvim ~/.config/skhd/
end

function editstarship --description "Edit starship configuration"
    nvim ~/.config/starship.toml
end

function cd-dls --description "cd into ~/Downloads"
    cd ~/Downloads
end

function cd-code --description "cd into ~/Code"
    cd ~/Code
end

function cd-obsidian --description "cd into obsidian vault"
    cd $OBSIDIAN_VAULT_PATH
end

function editobsidian --description "Edit obsidian vault"
    cd $OBSIDIAN_VAULT__CONFIG_PATH; and nvim $OBSIDIAN_VAULT_CONFIG_PATH
end

function cdnix --description "Edit nix-os config"
    cd ~/.config/nixos-config
end

# /navigation functions

# tmux
function edittmux --description "Edit tmux configuration"
    nvim ~/.config/tmux/
end

function viewtmux --description "view tmux configuration"
    # bat ~/.config/tmux/tmux.conf -l bash
    bat ~/.config/tmux/tmux.conf -l bash --paging=always --pager="less -RX"
end

function tmux-reload --description "Reload tmux"
    tmux source-file ~/Users/$USER/.config/tmux/tmux.conf /.tmux.conf
end

function tmux-start1 --description "Start tmux session with tmux config and karabiner config"
    tmux new-session -d 'nvim ~/.config/tmux' \; split-window -d editnvim \; attach
end

function tmux-vim-attach --description "Attach to tmux session and open vim"
    tmux new-session -d 'nvim ~/.config/tmux' \; split-window -d nvim \; attach
end

# tmuxp functions
function tmuxp-attach --description "attach to tmux session"
    tmuxp attach $argv[1]
end

function tmuxp-list --description "list tmux sessions"
    tmuxp list
end

function tmuxp-switch --description "switch tmux session"
    tmuxp switch $argv[1]
end

function tmuxp-start --description "start tmux session"
    tmuxp start $argv[1]
end
# /tmuxp functions

function tmxe --description "Edit tmuxinator configuration"
    if $argv[1]
        set -l configName $argv[1]
    else
        set -l configName default
    end
    nvim ~/.config/tmuxinator/ #$configName
end

function gen-tmxe --description "Generate tmuxinator configuration"
    tmuxinator new $argv[1]

end
#/tmux

function get-bundle-id --description "Get bundle identifier"
    set -l bundleId $argv[1]
    osascript -e "id of app \"$bundleId\""
end

# TODO: Use faster preset and better compression
function compress-video --description "Compress a video file"
    ffmpeg -i $argv[1] -c:v libx265 -preset slow -x265-params crf=20:no-sao=1:aq-mode=3 -vsync 0 -pix_fmt yuv420p10le $argv[2].mp4
end

# Copilot bindings

function create-svelte-ts-app --description "Create svelte ts app"
    degit sveltejs/template $argv[1]
end

function create-vite-app-with-tailwind --description "Create vite app with tailwind"
    vite $argv[1] -- --template react-ts --tsconfig ./tsconfig.tailwind.json --postcss ./postcss.config.js
end

function create-vite-app --description "Create vite app"
    vite $argv[1] -- --template react-ts
end

function create-react-app --description "Create react app"
    npx create-react-app $argv[1]
end
# /Copilot bindings

function editkitty --description "Edit kitty configuration"
    cd ~/.config/kitty
    nvim .
end

function editalacritty --description "Edit alacritty configuration"
    cd ~/.config/alacritty/
    nvim .
end

function editbat --description "Edit bat configuration"
    cd ~/.config/bat
    nvim .
end

function editconfig --description "Edit entire conf folder"
    cd ~/.config
    nvim .
end

function editvscode --description "Edit vscode configuration"
    nvim ~/Library/Application\ Support/Code/User/settings.json
end

function editvscodekeybindings --description "Edit vscode keybindings configuration"
    nvim ~/Library/Application\ Support/Code/User/keybindings.json
end

function editgit --description "Edit git configuration"
    nvim ~/.gitconfig
end

function editssh --description "Edit ssh configuration"
    nvim ~/.ssh/config
end
# /edit functions

# top/ps functions
function ps-nvim --description "View memory usage of nvim processes"
    echo "ps -avx | grep nvim"
    ps -avx | grep nvim
end

# ssh functions
function genkey --description "Generate ssh key"
    ssh-keygen -t ed25519 -C $argv[1]
end


function sshkey-copy --description "Copy ssh key"
    pbcopy <~/.ssh/id_ed25519.pub
end
# /ssh functions

function mkcd
    mkdir -p $argv[1]; and cd $argv[1]
end
# /navigation functions

# OpenAI/search functions
function genopenaikey --description "Generate openai key"
    open https://beta.openai.com/account/api-keys
end

function openai_edits_api
    h 'can you generate a golang script that reads from stdin and sends that to the OpenAI Code Edits API endpoint - include only the code nothing else' | string replace '```' '' >openai_edits_api.go
    h 'can you generate the commands to build and run the golang script - only include the commands' | string replace '```' '' >openai_edits_api.sh
    data_gpt 'can you generate some tests for the following golang script' (cat openai_edits_api.go | string collect) | string replace '```' '' >openai_edits_api_test.go
    data_gpt 'can you generate a makefile for a golang project with the following files' (ls) | string replace '```' '' >Makefile
end

function ollama-mistral --description "ollama mistral7b"
    ollama run mistral --port 11344
end

function ollama-mistral-repl
    ollama
    olllamagpt $argv[1] | string repl
    ollama run mistral --port 11344
end

function ollama-mistral7b --description "ollama mistral7b"
    ollama run mistral7b --port 11344
end

function img_gpt -a prompt
    set create_img (curl https://api.openai.com/v1/images/generations -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d '{
        "prompt": "'$prompt'",
        "n": 1,
        "size": "1024x1024"
    }')
    echo $create_img | jq
    set url (echo $create_img | jq -r '.data[0].url')
    set rand_num (random 1 1000000)
    curl -s $url -o img-"$rand_num".png
end

# function aichat --description "Ask GPT-3.5 Turbo a question"
#     set prompt $argv
#     curl https://api.openai.com/v1/chat/completions \
#         -H "Content-Type: application/json" \
#         -H "Authorization: Bearer $OPENAI_API_KEY" \
#         -d '
# {
#     "model": "gpt-4o-mini",
#     "response_format": { "type": "json_object" },
#     "temperature": 0.7,
#     "messages": [{
#         "role": "system",
#         "content": "You are a helpful assistant designed to output JSON. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer."
#     }]
# }
# ' | jq -r '.choices[0].message.content'
# end

function aichat --description "Ask GPT-3.5 Turbo a question"
    set prompt $argv
    set response (curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d '
{
    "model": "gpt-4o-mini",
    "response_format": { "type": "json_object" },
    "temperature": 0.7,
    "messages": [{
        "role": "system",
        "content": "You are a helpful assistant designed to output JSON. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer."
    }]
}
')
    if test $status -ne 0
        echo "Error: Failed to connect to OpenAI API"
        return 1
    end

    set error (echo $response | jq -r '.error.message')
    if test "$error" != null
        echo "API Error: $error"
        return 1
    end

    echo "Tokens used: "(echo $response | jq '.usage.total_tokens')
    # echo $response | jq -r '.choices[0].message.content'
    set content (echo $response | jq -r '.choices[0].message.content')

    # Try to parse the content as JSON and extract response field if it exists
    set parsed_response (echo $content | jq -r '.response // empty')
    if test -n "$parsed_response"
        echo $parsed_response
    else
        echo $content
    end
end

# -- Eza --
# function ll --wraps eza --description "list files as a grid with headers"
#     eza -laG --header
# end
# function lla --wraps eza --description "List files as a grid with headers, going across"
#     eza -laG --header --across
# end

# function convert-jpg-svg -s source -o output
#     convert $source -threshold 50% -type bilevel $output.pbm
#     potrace -s output.pbm -o $output.svg
#     rm $output.pbm
#
#     return $output.svg
# end

function convert-jpg-svg --description 'Convert a JPG image to SVG format'
    set -l source $argv[1]
    set -l output $argv[2]

    convert $source -threshold 50% -type bilevel $output.pbm
    potrace -s $output.pbm -o $output.svg
    rm $output.pbm

    echo $output.svg
end

function multipass-restart --description "Restart multipass"
    multipass stop
    killall qemu-system-aarch64
    ju mmuu
    killall multipassd
    multipass start
end

function simple-gpg --description "GPG encryption"
    if $argv[2]
        set output $argv[2]
    else
        set output $argv[1].gpg
    end
    gpg --pinentry-mode loopback \
        --passphrase PASSWORD $argv[1] --output $output

    gpg --symmetric --cipher-algo AES256 --pinentry-mode loopback \
        --passphrase PASSWORD $argv[1] --output $output
end

function pgp-decrypt --description "GPG decryption (Simple)"
    gpg --decrypt $argv[0]
end

function complex-gpg --description "GPG encryption (Complex)"
    gpg \
        --symmetric \
        --cipher-algo aes256 \
        --digest-algo sha512 \
        --cert-digest-algo sha512 \
        --compress-algo none -z 0 \
        --s2k-mode 3 \
        --s2k-digest-algo sha512 \
        --s2k-count 65011712 \
        --force-mdc \
        --pinentry-mode loopback --passphrase PASSWORD \
        --armor \
        --no-symkey-cache \
        --output $argv[2] \
        $argv[1]
end

# 1pass
function get-api-cred --description "Get credential from 1Password"
    op item get "Neovim ChatGPT" --fields credential
end

function preview --description "Preview files in a directory with fzf and bat"
    eza -g --header $argv[1] --sort name | fzf --preview "bat --color=always --style=numbers --line-range=:1000 $argv[1]/{}"
end

function rgpreview --description "Search with rg and preview with fzf and bat"
    rg -M 80 $argv[1] --files-with-matches | fzf --preview "bat -l $argv[2] --color=always --line-range=:1000 {}"
end

function rg-preview --description "Search with rg and preview with fzf and bat"
    rg -u --files-with-matches -e $argv[1] | fzf --preview "bat --color=always --style=numbers --line-range=:1000 {1}"
end

function fd2preview --description "Pipe output to a file and preview it with fzf and bat"
    fd --sort name $argv[1] | fzf --preview "bat --color=always --style=numbers --line-range=:1000 $argv[1]/{}"
end

function fd2preview2 --description "Pipe output to a file and preview it with fzf and bat"
    fd --type file --hidden --follow --exclude .git --exclude node_modules --exclude .venv --exclude .cache --exclude .DS_Store --exclude .gitignore --exclude .gitmodules --exclude .gitattributes --exclude .gitkeep --exclude .gitlab-ci.yml --exclude .gitlab --exclude .gitlab-ci $argv[1]
end

function back --description "Go back to previous directory"
    z -t
end

function fwrd --description "Go forward to next directory"
    z -
end

function imgcat --description "Display image in terminal"
    /Applications/WezTerm.app/Contents/MacOS/wezterm imgcat $argv[1]
    # use imgcat if wezterm is installed an an osx application
    # otherwise use kitty +kitten icat
    # kitty +kitten icat $argv[1]
end

# Replaced by function `ls-fonts`
# function lsfonts --description "View a list of fonts"
#     # eza -g --header ~/Library/Fonts --sort name | fzf
#     lsd -la ~/Library/Fonts | fzf
# end
# alias viewfonts=lsfonts

function fkill --description "Kill process by name"
    ps aux | grep $argv[1] | awk '{print $2}' | xargs kill
end

function texi --description "Install texlive"
    sudo tlmgr install $argv[1]
end

function last_history_item
    echo $history[1]
end

function list-services --description "List OSX services"
    launchctl list | awk '{print $3}' | fzf
end

function mov-to-webm --description "Convert mov to webm"
    # ffmpeg -i input.mp4 -loop 1 -an -vf scale=400:-2,fps=fps=20 output.webp
    ffmpeg -i input.mov -c:v libvpx-vp9 -pix_fmt yuva420p output.webm
end

function cyrun --description "Run cypress"
    node_modules/.bin/cypress open
end

function pull-site --description "Download a URL and all it's files"
    set -lx html wget --mirror --convert-links --adjust-extension --page-requisites "{{url}}"
end
