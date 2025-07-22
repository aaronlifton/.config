if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
else
    # https://github.com/rust-lang/rustup/blob/master/src/cli/self_update/env.fish
    echo '# rustup shell setup
if not contains "{cargo_bin}" $PATH
    # Prepending path in case a system-installed rustc needs to be overridden
    set -x PATH "{cargo_bin}" $PATH
end' >"$HOME/.cargo/env.fish"
end
