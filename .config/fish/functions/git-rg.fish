function git-rg --description "Search git files with rg"
    set -l diff_filter $argv[1]
    set -l query $argv[2]
    set -l valid_filters A C D M R T U X B AD AM AR AT AU AX CD CM CR CT CU CX MD MR MT MU MX RD RM RT RU RX TD TM TR TU TX UD UM UR UT UX
    if not contains -- $diff_filter $valid_filters
        echo "Error: Invalid diff filter. Valid filters are: $valid_filters"
        return 1
    end
    rg $query $(git diff HEAD --name-only --diff-filter=$diff_filter)
end
