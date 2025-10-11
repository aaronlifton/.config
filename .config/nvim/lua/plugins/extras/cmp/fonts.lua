return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "amarakon/nvim-cmp-fonts",
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    cmp.setup.filetype({ "conf", "config", "kitty", "fish", "toml" }, {
      sources = cmp.config.sources({
        {
          name = "fonts",
          option = {
            space_filter = "-",
            -- disallow_fullfuzzy_matching = false,
            enabled = function()
              -- disable completion if the cursor is `Comment` syntax group.
              return not cmp.config.context.in_syntax_group("Comment")
            end,
          },
        },
      }),
    })

    local ag = vim.api.nvim_create_augroup("CmpFonts", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = ag,
      callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then return end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
      end,
    })
  end,
}
