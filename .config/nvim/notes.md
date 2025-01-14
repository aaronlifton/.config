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

## modes

Help file [[/opt/homebrew/Cellar/neovim/0.10.3/share/nvim/runtime/doc/map.txt]]

There are seven sets of mappings

- For Normal mode: When typing commands.
- For Visual mode: When typing commands while the Visual area is highlighted.
- For Select mode: like Visual mode but typing text replaces the selection.
- For Operator-pending mode: When an operator is pending (after "d", "y", "c", etc.). See below: |omap-info|.
- For Insert mode. These are also used in Replace mode.
- For Command-line mode: When entering a ":" or "/" command.
- For Terminal mode: When typing in a |:terminal| buffer.

```help

*mapmode-x* *mapmode-s*
Some commands work both in Visual and Select mode, some in only one.  Note
that quite often "Visual" is mentioned where both Visual and Select mode
apply. |Select-mode-mapping|
NOTE: Mapping a printable character in Select mode may confuse the user.  It's
better to explicitly use :xmap and :smap for printable characters.  Or use
:sunmap after defining the mapping.

*mapmode-nvo* *mapmode-n* *mapmode-v* *mapmode-o* *mapmode-t*

There are seven sets of mappings
- For Normal mode: When typing commands.
- For Visual mode: When typing commands while the Visual area is highlighted.
- For Select mode: like Visual mode but typing text replaces the selection.
- For Operator-pending mode: When an operator is pending (after "d", "y", "c",
etc.).  See below: |omap-info|.
- For Insert mode.  These are also used in Replace mode.
- For Command-line mode: When entering a ":" or "/" command.
- For Terminal mode: When typing in a |:terminal| buffer.

Special case: While typing a count for a command in Normal mode, mapping zero
is disabled.  This makes it possible to map zero without making it impossible
to type a count with a zero.

*mapmode-nvo* *mapmode-n* *mapmode-v* *mapmode-o* *mapmode-t*

There are seven sets of mappings
- For Normal mode: When typing commands.
- For Visual mode: When typing commands while the Visual area is highlighted.
- For Select mode: like Visual mode but typing text replaces the selection.
- For Operator-pending mode: When an operator is pending (after "d", "y", "c",
etc.).  See below: |omap-info|.
- For Insert mode.  These are also used in Replace mode.
- For Command-line mode: When entering a ":" or "/" command.
- For Terminal mode: When typing in a |:terminal| buffer.

Special case: While typing a count for a command in Normal mode, mapping zero
is disabled.  This makes it possible to map zero without making it impossible
to type a count with a zero.

*mapmode-ic* *mapmode-i* *mapmode-c* *mapmode-l*
Some commands work both in Insert mode and Command-line mode, some not:

COMMANDS				                        MODES ~
                                        Insert  Command-line	Lang-Arg ~
:map!  :noremap!  :unmap!  :mapclear!	    yes	       yes	   -
:imap  :inoremap  :iunmap  :imapclear	    yes		-	   -
:cmap  :cnoremap  :cunmap  :cmapclear	     -	       yes	   -
:lmap  :lnoremap  :lunmap  :lmapclear	    yes*       yes*	  yes*

* If 'iminsert' is 1, see |language-mapping| below.

The original Vi did not have separate mappings for
Normal/Visual/Operator-pending mode and for Insert/Command-line mode.
Therefore the ":map" and ":map!" commands enter and display mappings for
several modes.  In Vim you can use the ":nmap", ":vmap", ":omap", ":cmap" and
":imap" commands to enter mappings for each mode separately.

*omap-info*
Operator-pending mappings can be used to define a movement command that can be
used with any operator.  Simple example: >
:omap { w
makes "y{" work like "yw" and "d{" like "dw".

To ignore the starting cursor position and select different text, you can have
the omap start Visual mode to select the text to be operated upon.  Example
that operates on a function name in the current line: >
onoremap <silent> F :<C-U>normal! 0f(hviw<CR>
The CTRL-U (<C-U>) is used to remove the range that Vim may insert.  The
Normal mode commands find the first '(' character and select the first word
before it.  That usually is the function name.

To enter a mapping for Normal and Visual mode, but not Operator-pending mode,
first define it for all three modes, then unmap it for
Operator-pending mode: >
:map    xx something-difficult
:ounmap xx

Likewise for a mapping for Visual and Operator-pending mode or Normal and
Operator-pending mode.
```
