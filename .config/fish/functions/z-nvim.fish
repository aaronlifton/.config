function z-nvim --description "Cd into a directory with zoxide and then open nvim"
    z $argv
    nvim .
end
