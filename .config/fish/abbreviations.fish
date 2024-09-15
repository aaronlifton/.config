abbr -a y yadm
abbr -a g git
abbr -a t gtrash
abbr -a grep rg
abbr -a find fd

abbr --add tar 'tar -zxvf'
# abbr --add ls eza
abbr --add ls lsd
abbr --add ll eza --across --icons --group-directories-first
abbr --add lt eza --tree --level=2 -a --long --header --accessed --git
abbr --add lla eza -la --header --across
abbr --add lll eza -la --header
abbr --add llg eza -la --header --git --git-repos
abbr --add lls \
    eza -Fulb --color-scale-mode gradient --color-scale --total-size --sort size \
    --icons

abbr --add ezallm eza -s modified --reverse
alias llm="eza -s modified --reverse"

abbr --add ezamrd eza -s created --reverse ~/Downloads/ | head -n 5
alias llrcd="eza -s created --reverse ~/Downloads/ | head -n 5"

abbr --add ezamrc eza -s created --reverse ./
alias llrc="eza -s created --reverse ./"

abbr --add ezamrm eza -s modified --reverse ./
alias llrm="ezamrm eza -s modified --reverse ./"

abbr --add ezalll eza --icons --group --header --group-directories-first --long
abbr --add ezallg eza --icons --group --header --group-directories-first --long --git --git-repos
abbr --add ezallr eza --icons --group --header --group-directories-first --long --reverse
abbr --add ezallt eza --icons --group --header --group-directories-first --long --sort accessed --reverse
abbr --add ezallc eza --icons --group --header --group-directories-first --long --sort created --reverse
abbr --add ezallm eza --icons --group --header --group-directories-first --long --sort modified --reverse
abbr --add rg- rg -m 80 -M 80 -u
abbr --add rg8 rg -m 80 -M 80 -u

abbr --add glp git log --pretty="format:%h %G? %aN %s"
abbr --add gdiffhead git diff HEAD^ -- . '!:node_modules'

abbr --add cat bat --style grid

abbr -a --position anywhere -- --fwm --files-with-matches

abbr -a !! --position anywhere --function last_history_item
abbr 4dirs --set-cursor=! "$(string join \n -- 'for dir in */' 'cd $dir' '!' 'cd ..' 'end')"
abbr -a L --position anywhere --set-cursor "% | less"
