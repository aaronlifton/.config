local lsp = function()
  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #buf_clients == 0 then
    return ""
  end

  return " "
end

local formatter = function()
  local formatters = require("conform").list_formatters(0)
  if #formatters == 0 then
    return ""
  end

  return "󰛖 "
end

local linter = function()
  local linters = require("lint").linters_by_ft[vim.bo.filetype]
  if #linters == 0 then
    return ""
  end

  return "󱉶 "
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options.component_separators = { left = "", right = "" }
    opts.options.section_separators = { left = "", right = "" }

    opts.sections.lualine_a = { { "mode", icon = "" } }
    opts.sections.lualine_c[4] = {
      LazyVim.lualine.pretty_path({
        filename_hl = "Bold",
        modified_hl = "MatchParen",
        directory_hl = "Conceal",
      }),
    }

    table.insert(opts.sections.lualine_x, 2, lsp)
    table.insert(opts.sections.lualine_x, 2, formatter)
    -- table.insert(opts.sections.lualine_x, 2, linter)
    table.insert(opts.sections.lualine_x, 2, {
      linter,
      on_click = function(num_clicks, mouse_button, mods)
        local data = { num_clicks = num_clicks, mouse_button = mouse_button, mods = mods }
        vim.api.nvim_echo({ { "mods: " .. vim.inspect(data) } }, true, {})
        -- local linters = require("lint").linters_by_ft[vim.bo.filetype]
        --
        -- if num_clicks == 1 and mouse_button == 1 and #mods == 0 then
        --   vim.api.nvim_echo({ { "Linters: " .. table.concat(linters, ", "), "Normal" } }, true, {})
        -- end
      end,
    })
    opts.sections.lualine_y = { "progress" }
    opts.sections.lualine_z = {
      { "location", separator = "" },
      {
        function()
          return ""
        end,
        padding = { left = 0, right = 1 },
      },
    }
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
      "fzf",
    }
  end,
}
