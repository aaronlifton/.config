function install-deps
    # Asdf
    brew install asdf
    # Rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rustup update
end
