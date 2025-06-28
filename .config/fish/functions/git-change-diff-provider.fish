function git-change-diff-provider
    set -l provider (git config --get diff.provider)
    if test -z "$provider"
        echo "No diff provider configured. Use 'git config diff.provider <provider>' to set one."
        return 1
    end
    switch $provider
        case difftastic
            # uncommitted changes
            git -c diff.external=difft diff

            # View changes from the most recent commit with difftastic:
            git -c diff.external=difft show --ext-diff

            # View changes from recent commits on the current branch with difftastic:
            git -c diff.external=difft log -p --ext-diff
        case diff-so-fancy
            git diff --color | diff-so-fancy
        case delta
            git diff --color | delta
        case "*"
            git diff --color
    end
end
