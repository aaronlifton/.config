function ppid
    set pid $argv[1]
    set parent_pid (ps -p $pid -o ppid | sed -n 2p | cut -c 5-)
    ps -p $parent_pid
end
