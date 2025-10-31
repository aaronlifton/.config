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
local enable_tabs = false
if enable_tabs then
  local keys = {}

  -- stylua: ignore start
  for i = 1, 9 do
    table.insert(keys, { "<leader>b" .. i, "<cmd>LualineBuffersJump " .. i .. "<cr>", desc = "Buffer " .. i })
  end

  -- table.insert(keys, { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" })
  -- table.insert(keys, { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" })
  -- table.insert(keys, { "<space><", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" })
  -- table.insert(keys, { "<space>>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" })
  -- -- Consider removing this in favor of snacks scratch buffer
  -- table.insert(keys, { "<leader>.", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" })
  -- table.insert(keys, { "<leader>b<C-,t", function() require("bufferline").move_to(1) end, desc = "Move buffer to start" })
  -- table.insert(keys, { "<leader>b<C-.>", function() require("bufferline").move_to(-1) end, desc = "Move buffer to end" })
  --
  -- table.insert(keys, { "<leader>bS", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" })
  -- table.insert(keys, { "<leader>bs", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" })
  -- table.insert(keys, { "<leader>b<C-s>", "<Cmd>BufferLineSortByTabs<CR>", desc = "Sort By Tabs" })
  -- table.insert(keys, { "<leader>b<M-s>", function() require('bufferline').sort_by(Util.bufferline.sort.category_sort) end, desc = "Custom Sort"})

  table.insert(keys, { "<leader><Tab>r", function()
    Snacks.input({
      prompt = "Rename Tab: ",
      completion = "customlist,v:lua.Util.tabline.complete.tab",
    }, function(name)
      if not name or name == "" then return end

      vim.cmd("LualineRenameTab " .. name)
    end)
  end, desc = "Rename Tab"})
  -- stylua: ignore end
end

return {
  { "akinsho/bufferline.nvim", enabled = not enable_tabs },
  {
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

      -- opts.sections.lualine_x[2] = LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
      --   local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
      --   if #clients > 0 then
      --     -- client = clients[1]
      --     -- local status = require("copilot.api").check_status(client).data.status
      --     -- return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
      --     return "error"
      --   end
      -- end)

      table.insert(opts.sections.lualine_x, 2, { "lsp_status" })

      -- vim.list_extend(opts.extensions, { "avante" })
      --------------------------------------------------------------------------

      if enable_tabs then
        opts.tabline = {
          lualine_a = { "buffers" },
          -- lualine_b = { "branch" },
          -- lualine_b = { "filename" },
          -- lualine_c = { "filename" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              "tabs",
              mode = 2,
              tab_max_length = 40, -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
              max_length = vim.o.columns / 3, -- Maximum width of tabs component.
              -- Note:
              -- It can also be a function that returns
              -- the value of `max_length` dynamically.
              show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
              symbols = {
                modified = "[+]", -- Text to show when the file is modified.
              },
              fmt = function(name, context)
                -- Show + if buffer is modified in tab
                local buflist = vim.fn.tabpagebuflist(context.tabnr)
                local winnr = vim.fn.tabpagewinnr(context.tabnr)
                local bufnr = buflist[winnr]
                local mod = vim.fn.getbufvar(bufnr, "&mod")

                local prefix = ""
                if name and #name > 0 then prefix = name end
                return prefix .. (mod == 1 and " +" or "")
              end,
            },
          },
        }
      end

      -- opts.winbar = {
      --   lualine_a = {},
      -- }
      --
      -- opts.inactive_winbar = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { "filename" },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {},
      -- }

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
    keys = {},
  },
}
