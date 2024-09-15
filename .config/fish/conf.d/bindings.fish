function configure_custom_fzf_bindings --on-variable fish_key_bindings
    set -f key_sequences \e\cb # \c = control, \e = escape
    # If fzf bindings already exists, uninstall it first for a clean slate
    if functions --query _custom_fzf_uninstall_bindings
        _custom_fzf_uninstall_bindings
    end

    for mode in default insert
        bind --mode $mode $key_sequences[1] fzf-git-branches
    end

    function _custom_fzf_uninstall_bindings --inherit-variable key_sequences
        bind --erase -- $key_sequences
        bind --erase --mode insert -- $key_sequences
    end
end

configure_custom_fzf_bindings
