-- https://github.com/benlubas/.dotfiles/blob/ead34f267708d40739ea93c556b6b37f605bb148/nvim/lua/benlubas/neorg/extras.lua#L129
-- https://github.com/siteyo/dotfiles/blob/e0f518358cac9462736b0a7e102e90f264bc43c6/config/nvim/lua/config/plugins/neorg.lua#L58
-- https://github.com/nvim-neorg/neorg/wiki/Default-Keybinds

local prefix = "<leader>N"
local workspace_prefix = "<leader>Nw"

---@param workspace string
local function create_file(workspace)
  Snacks.input({
    prompt = "Note name: ",
  }, function(name)
    if not name or name == "" then return end

    local dirman = require("neorg").modules.get_module("core.dirman")
    dirman.create_file(name, workspace, {
      no_open = true, -- open file after creation?
      force = false, -- overwrite file if exists
      metadata = {}, -- key-value table for metadata fields
    })
  end)
end

local function setup_workspaces()
  local neorg = require("neorg")
  local dirman = neorg.modules.get_module("core.dirman")
  -- For each workspace name, create `~/Code/norg/{workspace}/index.norg`
  local workspaces = dirman.config._config.workspaces
  for workspace, path in pairs(workspaces) do
    if not Path:new(path):exists() then vim.fn.mkdir(path, "p") end
  end
end

return {
  "nvim-neorg/neorg",
  -- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = true,
  -- If this fails on OSX: https://github.com/nvim-neorg/tree-sitter-norg/issues/7#issuecomment-1291508121
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
  ft = "norg",
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.keybinds"] = {}, -- Adds default keybindings
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.integrations.nvim-cmp"] = {},
      -- ["core.journal"] = {}, -- Enables support for the journal module
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/Code/notes",
            code = "~/Code/neorg/code",
            nvim = "~/Code/neorg/code/nvim",
            journal = "~/Code/neorg/journal",
            ai = "~/Code/neorg/ai",
          },
          default_workspace = "notes",
          -- index = "index.norg",
          -- autochdir = true,
        },
      },
      -- ["core.presenter"] = {
      --   config = {
      --     zen_mode = "zen-mode",
      --   },
      -- },
      -- ["core.concealer"] = {
      --   config = {
      --     icon_preset = "diamond",
      --     dim_code_blocks = {
      --       -- enabled = false,
      --       conceal = false,
      --     },
      --   },
      -- },
    },
  },
  keys = {
    -- Conflict: gO
    { "g0", ft = "norg", "<cmd>Neorg toc<CR>", desc = "[neorg] Create Table of Contents" },
    -- Conflict: <CR>
    { "<C-]>", ft = "norg", "<Plug>(neorg.esupports.hop.hop-link)", desc = "[neorg] Jump to Link" },
    -- Conflict: <
    -- { "<C-,>", ft = "norg", "<Plug>(neorg.promo.demote.range)", desc = "[neorg] Demote Objects in Range" },
    -- Conflict: >
    -- { "<C-.>", ft = "norg", "<Plug>(neorg.promo.demote.range)", desc = "[neorg] Promote Objects in Range" },

    -- stylua: ignore start
    { prefix, "", desc = "+Neorg" },
    { prefix .. "c", function() create_file("code") end, desc = "Create Code note" },
    { prefix .. "a", function() create_file("ai") end, desc = "Create AI note" },
    { prefix .. "n", function() create_file("notes") end, desc = "Create note" },
    -- { prefix .. "j", function() create_file("journal") end, desc = "Journal" },
    { prefix .. "wc", "<cmd>Neorg workspace code<cr>", desc = "Workspace code" },
    { prefix .. "wj", "<cmd>Neorg workspace journal<cr>", desc = "Workspace journal" },
    { prefix .. "wn", "<cmd>Neorg workspace notes<cr>", desc = "Workspace notes" },
    { workspace_prefix, "", desc = "+workspaces" },
    { workspace_prefix .. "c", "<cmd>Neorg workspace code<cr>", desc = "Code" },
    { workspace_prefix .. "a", "<cmd>Neorg workspace ai<cr>", desc = "AI" },
    { workspace_prefix .. "n", "<cmd>Neorg workspace notes<cr>", desc = "Notes" },
    -- stylua: ignore end
  },
}
