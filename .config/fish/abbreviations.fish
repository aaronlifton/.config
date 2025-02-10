abbr cp "cp -i"
abbr mv "mv -i"
abbr mkdir "mkdir -p"
abbr h history
abbr which "type -a"

### Builtin
abbr -a y yadm
abbr -a g git
abbr -a t gtrash
abbr -a grep rg
abbr -a find fd
abbr -a cat bat --style grid

abbr --add tar 'tar -zxvf'

### Lsd
abbr --add ls lsd
abbr --add ll lsd -la
abbr --add lt lsd --tree --depth 2
abbr --add llm lsd -ltr
abbr --add lg lsd -GgF
abbr --add llg lsd -lGgF
abbr --add lsd-size lsd --human-readable --size=short --blocks=size,name -Sr
abbr --add lsd-date lsd -t --date relative -l

### Rg
abbr --add rg- rg -m 80 -M 80 -u
abbr --add rg8 rg -m 80 -M 80 -u
abbr --add rg-mr --position command --set-cursor "rg -l \"%\" | xargs lsd -lt"
abbr -a --position anywhere -- --fwm --files-with-matches

### Git
abbr --add glp git log --pretty="format:%h %G? %aN %s"
abbr --add gdiffhead git diff HEAD^ -- . '!:node_modules'

abbr --add nvp nvimpager

abbr -a !! --position anywhere --function last_history_item
abbr 4dirs --set-cursor=! "$(string join \n -- 'for dir in */' 'cd $dir' '!' 'cd ..' 'end')"
abbr -a L --position anywhere --set-cursor "% | less"

### Functions
abbr --add zn z-nvim
abbr --add fr fzf-rg-bat

### Helpfiles
abbr --add help-kw bat ~/.config/kitty/kitty.conf -r 100:150

### Nvim AI
abbr --add chat-gemini nvim -o1 -c \"Mchat gemini\"
abbr --add chat-pplx nvim -o1 -c \"Mchat pplx\"
abbr --add llm-gemini --set-cursor "llm -m gemini-1.5-pro-latest --system \"You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer.\" \"%\""
abbr --add llm-gemini-flash --set-cursor "llm -m gemini-1.5-flash-latest --system \"You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer.\" \"%\""
# abbr --add llm-gemini-flash --set-cursor "llm -m gemini-1.5-flash-latest --system \"You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer.\" \"%\" | glow"

#### Development
abbr --add ber bundle exec rspec
abbr --add njest APP_ENV=development TZ=UTC npx jest --projects src/jest.config.rtl.js --watch --color --silent
abbr --add jest-debug node --inspect-brk node_modules/.bin/jest --projects src/jest.config.js --no-coverage --colors

# Jest
abbr --add jj TZ=UTC npx jest --watch
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
