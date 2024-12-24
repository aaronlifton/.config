# Notes

## Alternate formatters

[https://github.com/prdanelli/dotfiles/blob/main/neovim/lua/plugins/formatter.lua]

## `vim.nvim_create_user_command` completion for git branches

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

## vim.ui.input vimscript git branch completion

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

## Javascript snippets

- https://github.com/search?q=path%3A**%2Fnvim%2Fsnippets%2F**%2Fjavascript.json+async&type=code

- https://github.com/richban/system/blob/46efe696c3995e6c735e4285b301bdaba0be0864/dotfiles/config/nvim/snippets/javascript/javascript.json#L72

## Cmp plugins before switch to blink

- cmp-extended
- cmp.dap
- cmp.git
