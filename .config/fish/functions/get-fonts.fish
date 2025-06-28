function get-fonts
    fc-list :family | grep -v $HOME | cut -d: -f2 | cut -d, -f1 | sort -u
end
