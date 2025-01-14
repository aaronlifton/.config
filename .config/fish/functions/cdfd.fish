function cdfd -d "cd into the first fd result" --argument-names query
    set -l result (fd -t d -uu $query | head -n 1)
    if test -n "$result"
        cd $result
    else
        echo "No results found for $query"
    end
end
