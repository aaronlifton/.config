
# use custom function instead of fish built in git prompt due to performance
# (fish git prompt uses diff which can be slow)
function git_prompt
    set -l git_status_origin (command git status -s -b 2> /dev/null)
    printf ''

    set -l is_repo (string join0 $git_status_origin)

    if test -z $is_repo
        # git status returns error (not a git repo)
        printf ''
    else
        echo $git_status_origin | string match --regex '\[.*ahead.*\]' --quiet
        set -l ahead $status
        echo $git_status_origin | string match --regex '\[.*behind.*\]' --quiet
        set -l behind $status
        set -l branch (echo $git_status_origin | string replace -r  '## ([\S]+).*' '$1' | string replace -r '(.+)\.\.\..*' '$1')

        # # simply check for modified/deleted/rename, match only 1
        echo $git_status_origin | string match --regex '[MDR ][MDR ] .*' --quiet
        set -l git_dirty $status

        # simply check for ?? in the list of files, match only 1
        echo $git_status_origin | string match --regex '\?\? .*' --quiet
        set -l git_untracked $status

        if test "$git_dirty" -eq 0
            printf ' (%s%s' (set_color red)
        else
            printf ' (%s%s' (set_color yellow)
        end


        # Use branch name if available
        if test -n "$branch"
            printf $branch
        else
            # for new branch, git branch will return nothing, use branch name from git status
            set -l git_status_no_commits_branch (echo $git_status_origin | string replace '## No commits yet on ' '')
            printf $git_status_no_commits_branch
        end

        if test "$git_untracked" -eq 0
            printf '%s*' (set_color purple)
        end

        if test -s .git/refs/stash # stash exists - check on .git/refs/stash file
            printf '%s$' (set_color green)
        end

        # if local repo is ahead, show up arrow
        if test "$ahead" -eq 0
            printf '%s↑' (set_color cyan)
        end

        # if local repo is behind, show down arrow
        if test "$behind" -eq 0
            printf '%s↓' (set_color magenta)
        end

        printf '%s)' (set_color normal)
    end
end

# function kubectl_context
#     if test -e ~/.kube/config; and type -q kubectl
#         set -l current_context (kubectl config current-context)
#         printf ' %s[' (set_color normal)
#         printf '%s%s' (skubectl_contextet_color cyan) $current_context
#         printf '%s]' (set_color normal)
#     else
#         printf ''
#     end
# end

function fish_prompt
    printf '%s%s%s' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    printf '%s%s ☕️ ' (git_prompt) #(kubectl_context)
    set_color normal
end
