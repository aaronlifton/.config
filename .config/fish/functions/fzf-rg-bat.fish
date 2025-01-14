function fzf-rg-bat
    set RG_PREFIX 'rg -i --files-with-matches'
    if test (count $argv) -gt 1
        set RG_PREFIX "$RG_PREFIX $argv[1..-2]"
        echo $RG_PREFIX
    end
    set -l file $file
    set -l query $argv[-1]
    set -l fzf_output (
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$argv[-1]'" \
        fzf --sort \
            --print-query \
            --preview='test ! -z {} && \
                rg -i -C 20 --no-heading --color always {q} {} | \
                bat --style=numbers,changes --color=always \
                --file-name {} --language=$(basename {} | cut -d. -f2)' \
            --disabled -q "$query" \
            --bind "change:reload:$RG_PREFIX {q}" \
            )
    if test -n "$fzf_output"
        # First line is the query, second line is the selected file
        set query $fzf_output[1]
        set file $fzf_output[2]
        set -l line_number (rg -i -n "$query" "$file" | head -1 | cut -d: -f1)
        echo "opening $file at line $line_number"
        nvim +$line_number $file
    end
end
