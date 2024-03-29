-- Only replace cmds, not search; only replace the first instance
local function cmd_abbrev(abbrev, expansion)
  local cmd = "cabbr "
    .. abbrev
    .. ' <c-r>=(getcmdpos() == 1 && getcmdtype() == ":" ? "'
    .. expansion
    .. '" : "'
    .. abbrev
    .. '")<CR>'
  vim.cmd(cmd)
end

return {
  "Tyler-Barham/floating-help.nvim",
  enabled = false,
  config = function()
    require("floating-help").setup(
      -- Defaults
      {
        width = 80, -- Whole numbers are columns/rows
        height = 0.9, -- Decimals are a percentage of the editor
        position = "E", -- NW,N,NW,W,C,E,SW,S,SE (C==center)
        border = "rounded", -- rounded,double,single
        onload = function(query_type)
          vim.cmd("echo 'Query type: " .. query_type .. "'")
        end, -- optional callback to be executed after help contents has been loaded
      }
    )

    -- Redirect `:h` to `:FloatingHelp`
    cmd_abbrev("h", "FloatingHelp")
    cmd_abbrev("help", "FloatingHelp")
    cmd_abbrev("helpc", "FloatingHelpClose")
    cmd_abbrev("helpclose", "FloatingHelpClose")
  end,
  keys = {
    {
      "n",
      "<D-1>",
      "<cmd>lua require('floating_help').toggle()<CR>",
      desc = "Toggle Help",
    },
    {
      "n",
      "<D-2>",
      "<cmd>lua require('floating_help').open('t=cppman', vim.fn.expand('<cword>'))<CR>",
      desc = "Search Cppman",
    },
    {
      "n",
      "<D-3>",
      "<cmd>lua require('floating_help').open('t=man', vim.fn.expand('<cword>'))<CR>",
      desc = "Search Man",
    },
  },
}
