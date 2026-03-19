function gem-codex --argument-names gem prompt --description "Ask codex about gems"
    # cd /Users/$USER/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems
    # set gem dry-validation
    # set prompt "What are the key APIs in this gem?"

    if test -z "$gem"
        echo "gem not provided"
        return 1
    end

    if test -z "$prompt"
        echo "prompt not provided"
        return 1
    end

    echo gem: $gem
    echo prompt: $prompt
    python3 ~/.config/fish/python/gem-codex.py $gem --ask $prompt
end
