complete -c git-absorb -s b -l base -d 'Use this commit as the base of the absorb stack' -r
complete -c git-absorb -l gen-completions -d 'Generate completions' -r -f -a "{bash	'',fish	'',nushell	'',zsh	'',powershell	'',elvish	''}"
complete -c git-absorb -s n -l dry-run -d 'Don\'t make any actual changes'
complete -c git-absorb -s f -l force -d 'Skip safety checks'
complete -c git-absorb -s v -l verbose -d 'Display more output'
complete -c git-absorb -s r -l and-rebase -d 'Run rebase if successful'
complete -c git-absorb -s w -l whole-file -d 'Match the change against the complete file'
complete -c git-absorb -s F -l one-fixup-per-commit -d 'Only generate one fixup per commit'
complete -c git-absorb -s h -l help -d 'Print help'
complete -c git-absorb -s V -l version -d 'Print version'
