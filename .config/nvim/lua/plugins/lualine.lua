return {
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      local colors = {
        [""] = Util.ui.fg("Special"),
        ["Normal"] = Util.ui.fg("Special"),
        ["Warning"] = Util.ui.fg("DiagnosticError"),
        ["InProgress"] = Util.ui.fg("DiagnosticWarn"),
      }

      vim.g.gitblame_display_virtual_text = 0
      local git_blame = require("gitblame")

      table.insert(opts.sections.lualine_c, {
        function()
          return git_blame.get_current_blame_text()
        end,
        cond = function()
          return git_blame.is_blame_text_available()
        end,
      })
      table.insert(opts.sections.lualine_a, function()
        return require("possession.session").session_name or ""
      end)
      -- table.insert(opts.sections.lualine_c, {
      --   function()
      --     return require("NeoComposer.ui").status_recording()
      --   end,
      -- })
      -- table.insert(opts.sections.lualine_y, 2, require("recorder").displaySlots)
      -- table.insert(opts.sections.lualine_z, 2, require("recorder").recordingStatus)
      -- table.insert(opts.sections.lualine_x, 2, {
      --   function()
      --     local icon = require("lazyvim.config").icons.kinds.Copilot
      --     local status = require("copilot.api").status.data
      --     return icon .. (status.message or "")
      --   end,
      --   cond = function()
      --     if not package.loaded["copilot"] then
      --       return
      --     end
      --     local ok, clients = pcall(require("lazyvim.util").lsp.get_clients, { name = "copilot", bufnr = 0 })
      --     if not ok then
      --       return false
      --     end
      --     return ok and #clients > 0
      --   end,
      --   color = function()
      --     if not package.loaded["copilot"] then
      --       return
      --     end
      --     local status = require("copilot.api").status.data
      --     return colors[status.status] or colors[""]
      --   end,
      -- })

      -- table.insert(opts.sections.lualine_x, 2, require("lazyvim.util").lualine.cmp_source("codeium"))
      -- local icon = require("lazyvim.config").icons.kinds.TabNine
      --
      -- table.insert(opts.sections.lualine_x, 2, require("lazyvim.util").lualine.cmp_source("cmp_tabnine", icon))

      opts.extensions = {
        "lazy",
        "man",
        "mason",
        "nvim-dap-ui",
        "overseer",
        "quickfix",
        "toggleterm",
        "trouble",
        "neo-tree",
      }
      return opts
    end,
  },
}
