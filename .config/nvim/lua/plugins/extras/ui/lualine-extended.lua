-- local lsp_names = function()
--   local names = {}
--   for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
--     table.insert(names, server.name)
--   end
--   return "[" .. table.concat(names, " ") .. "]"
-- end
-- local lsp = function()
--   local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
--   if #buf_clients == 0 then return "" end
--
--   return " " .. " " .. lsp_names()
-- end
-- local formatter = function()
--   if not LazyVim.format.enabled() then return "" end
--
--   local formatters = require("conform").list_formatters(0)
--   if #formatters == 0 then return "" end
--
--   return "󰛖 "
-- end
-- local linter = function()
--   local linters = require("lint").get_running(0)
--   if #linters == 0 then return "" end
--
--   return "󱉶 "
-- end
--
-- local lsp_status = {
--   "lsp_status",
--   icon = "", -- f013
--   symbols = {
--     -- Standard unicode symbols to cycle through for LSP progress:
--     spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
--     -- Standard unicode symbol for when LSP is done:
--     done = " ", -- "✓"
--     -- Delimiter inserted between LSP names:
--     separator = " ",
--   },
--   -- List of LSP names to ignore (e.g., `null-ls`):
--   ignore_lsp = {},
--
--
-- local starship = function()
--   return require("util.lualine.starship")()
-- end

return {
  "nvim-lualine/lualine.nvim",
  optional = true,
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

    opts.sections.lualine_x[2] = LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
      local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
      if #clients > 0 then
        -- client = clients[1]
        -- local status = require("copilot.api").check_status(client).data.status
        -- return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
        return "error"
      end
    end)

    table.insert(opts.sections.lualine_x, 2, { "lsp_status" })
    -- table.insert(opts.sections.lualine_x, 2, require("util.lualine.avante"))
    -- if vim.g.lualine_info_extras == false then
    --   -- table.insert(opts.sections.lualine_x, 2, lsp_status)
    --   table.insert(opts.sections.lualine_x, 2, { "lsp_status" })
    --   -- table.insert(opts.sections.lualine_x, 2, lsp)
    --   table.insert(opts.sections.lualine_x, 2, formatter)
    --   table.insert(opts.sections.lualine_x, 2, linter)
    --   -- table.insert(opts.sections.lualine_x, 2, require("util.lualine.codecompanion"))
    --   table.insert(opts.sections.lualine_x, 2, require("util.lualine.avante"))
    --   -- table.insert(opts.sections.lualine_x, 2, starship)
    --   if package.loaded["mcphub"] then
    --     table.insert(opts.sections.lualine_x, 2, require("mcphub.extensions.lsp_status"))
    --   end
    -- end
    -- opts.sections.lualine_y = { "progress" }
    -- opts.sections.lualine_z = {
    --   { "location", separator = "" },
    --   {
    --     function()
    --       return ""
    --     end,
    --     padding = { left = 0, right = 1 },
    --   },
    -- }
    -- opts.extensions = {
    --   "lazy",
    --   "man",
    --   "mason",
    --   -- "nvim-dap-ui",
    --   -- "overseer",
    --   "quickfix",
    --   "trouble",
    --   "neo-tree",
    --   "fzf",
    -- }
  end,
}
