function astronvimv4 --description "Set AstroNvim to the correct version"
    # Check if current version is v0.10.1
    if string match -q 'nightly.*Used' (bob list)
        bob use nightly
        echo "AstroNvimV4 requires Neovim v0.9.5+ (Not including nightly)\n...Switched to v0.10.4"
        NVIM_APPNAME=astronvim nvim

    else
        NVIM_APPNAME=astronvim nvim
    end
end
