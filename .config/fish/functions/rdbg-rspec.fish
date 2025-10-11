function rdbg-rspec --description "rdbg a rspec file"
    rdbg -n --open --port 38698 -c -- bundle exec rspec $argv[1]
end
