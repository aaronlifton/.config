local lsp_names = function()
  local names = {}
  for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, server.name)
  end
  return "[" .. table.concat(names, " ") .. "]"
end
local lsp = function()
  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #buf_clients == 0 then return "" end

  return " " .. " " .. lsp_names()
end
local formatter = function()
  if not LazyVim.format.enabled() then return "" end

  local formatters = require("conform").list_formatters(0)
  if #formatters == 0 then return "" end

  return "󰛖 "
end
local linter = function()
  local linters = require("lint").get_running(0)
  if #linters == 0 then return "" end

  return "󱉶 "
end

-- local starship = function()
--   return require("util.lualine.starship")()
-- end

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

    if vim.g.lualine_info_extras == true then
      table.insert(opts.sections.lualine_x, 2, lsp)
      table.insert(opts.sections.lualine_x, 2, formatter)
      table.insert(opts.sections.lualine_x, 2, linter)
      table.insert(opts.sections.lualine_x, 2, require("util.lualine.codecompanion"))
      -- table.insert(opts.sections.lualine_x, 2, starship)
    end
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
      "trouble",
      "neo-tree",
      "fzf",
    }
  end,
}
