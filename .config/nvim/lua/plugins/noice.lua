return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = {
        skip = true,
      },
    })
    table.insert(opts.routes, 1, {
      filter = {
        ["not"] = {
          event = "lsp",
          kind = "progress",
        },
        cond = function()
          return not focused
        end,
      },
      view = "notify_send",
      opts = { stop = false },
    })
    opts.presets.lsp_doc_border = true
    opts.commands = {
      all = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    }
  end,
}
