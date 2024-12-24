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
# alias llm="eza -s modified --reverse"

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
abbr --add rg-mr --position command --set-cursor "rg -l \"%\" | xargs lsd -lt"

abbr --add glp git log --pretty="format:%h %G? %aN %s"
abbr --add gdiffhead git diff HEAD^ -- . '!:node_modules'

abbr --add cat bat --style grid

abbr -a --position anywhere -- --fwm --files-with-matches

abbr -a !! --position anywhere --function last_history_item
abbr 4dirs --set-cursor=! "$(string join \n -- 'for dir in */' 'cd $dir' '!' 'cd ..' 'end')"
abbr -a L --position anywhere --set-cursor "% | less"

abbr --add ber bundle exec rspec
abbr --add njest APP_ENV=development TZ=UTC npx jest --projects src/jest.config.rtl.js --watch --color --silent
abbr --add lsd-size lsd --human-readable --size=short --blocks=size,name -Sr
abbr --add lsd-date lsd -t --date relative -l

# Nvim AI
abbr --add chat-gemini nvim -o1 -c \"Mchat gemini\"
abbr --add chat-pplx nvim -o1 -c \"Mchat pplx\"
abbr --add llm-gemini --set-cursor "llm -m gemini-1.5-pro-latest --system \"You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer.\" \"%\""
abbr --add llm-gemini-flash --set-cursor "llm -m gemini-1.5-flash-latest --system \"You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer.\" \"%\""
# abbr --add llm-gemini-flash --set-cursor "llm -m gemini-1.5-flash-latest --system \"You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer.\" \"%\" | glow"



# Jest
## Researcher
abbr --add jest-researcher TZ=UTC npx jest --projects jest.config.rtl.js --coverage=false --watch
abbr --add jr TZ=UTC npx jest --projects jest.config.rtl.js --coverage=false --watch
abbr --add jest-researcher-enz TZ=UTC npx jest --projects jest.config.enz.js --coverage=false --watch
abbr --add jre TZ=UTC npx jest --projects jest.config.enz.js --coverage=false --watch

## Client
abbr --add jest-client TZ=UTC APP_ENV=development npx jest --projects src/jest.config.rtl.js --coverage=false --watch
abbr --add jc TZ=UTC APP_ENV=development npx jest --projects src/jest.config.rtl.js --coverage=false --watch
abbr --add jest-client-enz TZ=UTC APP_ENV=development npx jest --projects src/jest.config.js --coverage=false --watch
abbr --add jce TZ=UTC APP_ENV=development npx jest --projects src/jest.config.js --coverage=false --watch

## Boss
abbr --add jest-boss TZ=utc NODE_ENV=test npx jest --projects jest.config.rtl.js --watch --no-cache
abbr --add jb TZ=utc NODE_ENV=test npx jest --projects jest.config.rtl.js --watch --no-cache
abbr --add jest-boss-enz TZ=utc NODE_ENV=test npx jest --projects jest.config.enz.js --watch --no-cache
abbr --add jbe TZ=utc NODE_ENV=test npx jest --projects jest.config.enz.js --watch --no-cache

## Cucumber
abbr --add cucumber-e2e LOG_LEVEL=debug BROWSER=chromium:headless npx cucumber-js --tags
abbr --add gulp-e2e --set-cursor "npx gulp test --group=%"
