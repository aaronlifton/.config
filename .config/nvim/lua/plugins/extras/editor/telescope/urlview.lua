return {
  "axieax/urlview.nvim",
  -- dependencies = { { "nvim-telescope/telescope.nvim", optional = true } },
  cmd = { "UrlView" },
  keys = { { "<leader>sU", "<cmd>UrlView<cr>", desc = "Search Urls" } },
  opts = {
    -- default_picker = "native",
    default_picker = "mini.pick",
  },
  init = function()
    local pickers = require("urlview.pickers")

    local choose = function(item)
      local err = Util.do_open(item)
      if err then vim.notify(err, vim.log.levels.ERROR) end
    end

    local choose_marked = function(items)
      for _, url in ipairs(items) do
        local err = Util.do_open(url)
        if err then vim.notify(err, vim.log.levels.ERROR) end
      end
    end

    pickers["mini.pick"] = function(items, _)
      require("mini.pick").start({
        source = { items = items, choose = choose, choose_marked = choose_marked },
        mappings = {
          copy_url = {
            char = "<M-c>",
            func = function()
              local curline = vim.fn.getline(".")
              vim.fn.setreg("+", curline)
              vim.notify("Copied URL to clipboard: " .. curline, vim.log.levels.INFO)
            end,
          },
        },
      })
    end
  end,
}
