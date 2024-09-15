function mrd
    # * zoxide query -ls | head -n 40 | awk '{print $2}' | fzf --preview 'eza -1 {}'
    set -lx path $(zoxide query -ls | head -n 40 | awk '{print $2}' | fzf --preview "fd . --relative-path {}")
    cd $path
end
