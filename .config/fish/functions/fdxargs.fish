function fdxargs --description "Run a command with fd matches via xargs" --argument-names pattern
    if test -z "$pattern"
        echo "usage: fdxargs <pattern> <command> [args...]" >&2
        return 1
    end

    if test (count $argv) -lt 2
        echo "usage: fdxargs <pattern> <command> [args...]" >&2
        return 1
    end

    set -l matches_file (mktemp)
    command fd -0 --regex -- "$pattern" > $matches_file

    if not test -s $matches_file
        command rm -f $matches_file
        return 1
    end

    command xargs -0 $argv[2..-1] < $matches_file
    set -l status_code $status
    command rm -f $matches_file
    return $status_code
end
