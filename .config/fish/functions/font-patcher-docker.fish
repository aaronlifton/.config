function font-patcher-docker --argument-names in out
    if test -n "$out"
        docker run --rm -v $in:/in:Z -v $out:/out:Z nerdfonts/patcher
    else
        docker run --rm -v $in:/in:Z -v ~/.config/fonts/patched:/out:Z nerdfonts/patcher
    end
end
