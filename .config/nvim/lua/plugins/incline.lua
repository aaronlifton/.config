local function get_diagnostic_label(props)
  local icons = { error = "", warn = "", info = "", hint = "" }
  local label = {}

  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then
      table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
    end
  end
  if #label > 0 then
    table.insert(label, { "| " })
  end
  return label
end
local function get_git_diff(props)
  local icons = { removed = "", changed = "", added = "" }
  local labels = {}
  -- local signs = vim.api.nvim_buf_get_var(props.buf, "gitsigns_status_dict")
  local signs = vim.b.gitsigns_status_dict
  if not signs then
    return
  end
  for name, icon in pairs(icons) do
    if tonumber(signs[name]) and signs[name] > 0 then
      table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
    end
  end
  if #labels > 0 then
    table.insert(labels, { "| " })
  end
  return labels
end

return {
  {
    "b0o/incline.nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
      -- require("incline").setup({
      --   render = function(props)
      --     local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      --     local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
      --     local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "bold"
      --
      --     local buffer = {
      --       { get_diagnostic_label(props) },
      --       { get_git_diff(props) },
      --       { ft_icon, guifg = ft_color },
      --       { " " },
      --       { filename, gui = modified },
      --     }
      --     return buffer
      --   end,
      -- })
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local helpers = require("incline.helpers")
          local buffer = {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#44406e",
          }
          return buffer
        end,
      })
    end,
  },
}
