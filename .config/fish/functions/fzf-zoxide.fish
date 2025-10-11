function fzf-zoxide -d "Fzf zoxide navigator"
    set -lx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS --no-sort --exact
    set -l result (zoxide query -i); and cd "$result"
end
