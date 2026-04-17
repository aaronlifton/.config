function git-new-branch-with-file --argument-names branchname path commitmsg
    set -lx prevbranch $(command git rev-parse --abbrev-ref HEAD)

    git fetch origin

    git switch dev

    git pull --ff-only origin dev

    git switch -c $branchname

    git checkout $prevbranch -- api-docs-sdks/openapi.yaml

    git commit -m $commitmsg
end
