function git-diff-renames --description 'Get diff renames'
    set -l source_branch $argv[1]
    set -l pattern $argv[2]
    set -l extra_args $argv[3..-1]
    git diff --name-only $source_branch --diff-filter=R $extra_args | rg $pattern | sed 's/^{.*?}\(.*\)/\1/'
end
