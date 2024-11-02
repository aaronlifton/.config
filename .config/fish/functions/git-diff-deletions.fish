function git-diff-deletions --description 'Get diff deletions with parent
context'
    set -l source $argv[1]
    set -l lang $argv[2]
    if test $lang = yaml
        git diff main -- $source | grep '^-' >deletions.txt
        # Parse the YAML structure and pair deletions with the nearest parent key
        awk '
      /^-/ {
        # This is a deletion line
        deletion = $0
        # Find the nearest parent key
        for (i = NR-1; i > 1; i--) {
          if (lines[i] ~ /^[^[:space:]]+:/) {
            parent_key = lines[i]
            break
          }
        }
        print parent_key, deletion
      }
      {
        # Store the line for future reference
        lines[NR] = $0
      }
    ' deletions.txt
    end
end
