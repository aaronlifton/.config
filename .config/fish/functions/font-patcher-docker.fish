function font-patcher-docker --argument-names in out
    docker run --rm -v $in:/in:Z -v ~/.config/fonts/patched:/out:Z nerdfonts/patcher
end
