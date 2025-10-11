function createSharedRootGroup --description "adds user provided via argument to a shared group with root"
    set -lx username $argv[1]
    set -lx sharedRootGroup (dscl . list /Groups | grep "sharedroot" | awk '{print $1}')
    if test "$sharedRootGroup" = "sharedroot"
        return
    else
        sudo dscl . create /Groups/sharedroot PrimaryGroupID 101
        sudo dscl . append /Groups/sharedroot GroupMembership $username
        sudo dscl . append /Groups/sharedroot GroupMembership root
        chown :shared_root /usr/local/texlive/texmf-local/tex/latex/local
        echo (dscl . list /Groups | grep -C 5 "sharedroot")
    end
end
