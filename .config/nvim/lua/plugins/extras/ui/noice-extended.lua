local skip = {
  notify = {
    "No information available",
    "textDocument/codeLens",
    "Query error",
    -- https://github.com/yioneko/vtsls/issues/159
    "Request textDocument/inlayHint failed",
    "Unable to init vim.regex",
    "getting file for InlayHint",
    "not supported by",
    "LSP error",
    -- "typed: false",
    -- "TypeScript Server Error",
  },
  lsp = {
    progress = {
      "Searching",
      "Processing",
      "semantic token",
      "(0%)", -- Remove stuck lua_ls progress
    },
  },
}

return {
  "folke/noice.nvim",
  optional = true,
  opts = function(_, opts)
    local routes = {}

    for _, pattern in ipairs(skip.notify) do
      table.insert(routes, {
        filter = {
          event = "notify",
          find = pattern,
        },
        opts = {
          skip = true,
        },
      })
    end

    for _, pattern in ipairs(skip.lsp.progress) do
      table.insert(routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          find = pattern,
        },
        opts = {
          skip = true,
        },
      })
    end

    vim.list_extend(opts.routes, routes)

    opts.presets.lsp_doc_border = true
    -- opts.presets.bottom_search = false
    if LazyVim.has_extra("coding.nvim-cmp") then opts.popupmenu = { backend = "cmp" } end

    -- opts.lsp.override["cmp.entry.get_documentation"].enabled = false
  end,
  keys = {
    {
      "<leader>snt",
      function()
        require("noice.integrations.fzf").open({})
      end,
      desc = "Noice Picker",
    },
  },
}

-- return {
--   "folke/noice.nvim",
--   opts = function(_, opts)
--     table.insert(opts.routes, {
--       filter = {
--         event = "notify",
--         find = "No information available",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     table.insert(opts.routes, {
--       filter = {
--         event = "notify",
--         find = "not supported by",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     table.insert(opts.routes, {
--       filter = {
--         find = "typed: false",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     table.insert(opts.routes, {
--       filter = {
--         event = "notify",
--         find = "TypeScript Server Error",
--       },
--       opts = {
--         skip = true,
--       },
--     })
--     local focused = true
--     vim.api.nvim_create_autocmd("FocusGained", {
--       callback = function()
--         focused = true
--       end,
--     })
--     vim.api.nvim_create_autocmd("FocusLost", {
--       callback = function()
--         focused = false
--       end,
--     })
--     -- from folke
--     table.insert(opts.routes, 1, {
--       filter = {
--         ["not"] = {
--           event = "lsp",
--           kind = "progress",
--         },
--         cond = function()
--           return not focused
--         end,
--       },
--       view = "notify_send",
--       opts = { stop = false },
--     })
--     opts.commands = {
--       all = {
--         -- options for the message history that you get with `:Noice`
--         view = "split",
--         opts = { enter = true, format = "details" },
--         filter = {},
--       },
--     }
--     -- opts.status = { lsp_progress = { event = "lsp", kind = "progress" } }
--     opts.presets.lsp_doc_border = true
--     opts.presets.bottom_search = false
--     -- opts.lsp.message.enabled = false
--     return opts
--   end,
-- }
