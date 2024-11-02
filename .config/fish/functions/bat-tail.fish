function bat-tail -d "Tail a file with bat"
    set -l file $argv[1]
    tail -f $file | bat -f -l log --style="header,grid"
end
