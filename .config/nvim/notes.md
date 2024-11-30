# Notes

## Alternate formatters

[https://github.com/prdanelli/dotfiles/blob/main/neovim/lua/plugins/formatter.lua]

# `vim.nvim_create_user_command` completion for git branches

```lua
local function git_branch_complete(arglead, cmdline, cursorpos)
  -- Get the list of git branches
  local branches = vim.fn.systemlist('git branch --format="%(refname:short)"')
  -- Filter branches that start with the current argument lead
  local matches = vim.tbl_filter(function(branch)
    return vim.startswith(branch, arglead)
  end, branches)
  return matches
end
```

# vim.ui.input vimscript git branch completion

```lua
vim.api.nvim_exec2(
  [[
  fun! GitBranchComplete(ArgLead, CmdLine, CursorPos)
      return system('git branch --format="%(refname:short)" | grep "^' . a:ArgLead . '"')
  endfunction
  ]],
  { output = true }
)
local branch = vim.ui.input("Branch: ", {
  completion = "customlist,GitBranchComplete",
})
```
