if vim.g.outline_plugin == "outline.nvim" then
  return {
    {
      "folke/edgy.nvim",
      keys = {
        {
          "<D-e>",
          function()
            local windows = vim.api.nvim_list_wins()
            for _, win in ipairs(windows) do
              local buf = vim.api.nvim_win_get_buf(win)
              local name = vim.api.nvim_buf_get_name(buf)
              -- set current buf
              vim.cmd("echo '" .. name .. "'")
              local subname
              if name:find("edgy") == 1 then
                subname = name.match(name, "^edgy://(%w+)")
              end

              if subname == "Outline" then
                vim.api.nvim_set_current_win(win)
                vim.cmd("buffer " .. buf)
              end
            end
          end,
          desc = "Outline",
        },
        {
          "<D-S-e>",
          function()
            require("edgy").goto_main()
          end,
          desc = "Close",
        },
      },
    },
  }
else
  local Util = require("lazyvim.util")

  return {
    {
      "folke/edgy.nvim",
      optional = true,
      opts = function(_, opts)
        local edgy_idx = Util.plugin.extra_idx("ui.edgy")
        local aerial_idx = Util.plugin.extra_idx("editor.aerial")

        if not aerial_idx then
          return
        end

        if edgy_idx and edgy_idx > aerial_idx then
          Util.warn("The `edgy.nvim` extra must be **imported** before the `aerial.nvim` extra to work properly.", {
            title = "LazyVim",
          })
        end

        opts.right = opts.right or {}
        table.insert(opts.right, {
          title = "Aerial",
          ft = "aerial",
          pinned = true,
          open = "AerialOpen",
        })
      end,
    },
  }
end
