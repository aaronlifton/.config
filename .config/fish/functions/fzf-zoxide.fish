function fzf-zoxide -d "Fzf zoxide navigator"
    set -l result (zoxide query -i); and cd "$result"
end
