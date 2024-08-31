local prefix = "<leader>O"

return {
  { import = "plugins.extras.lang.markdown-extended" },
  {
    "MeanderingProgrammer/markdown.nvim",
    opts = {
      preset = "obsidian",
    },
  },
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    keys = {
      { prefix .. "o", "<cmd>ObsidianOpen<CR>", desc = "Open on App" },
      { prefix .. "g", "<cmd>ObsidianSearch<CR>", desc = "Grep" },
      { "<leader>sO", "<cmd>ObsidianSearch<CR>", desc = "Obsidian Grep" },
      { prefix .. "n", "<cmd>ObsidianNew<CR>", desc = "New Note" },
      { prefix .. "<space>", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Files" },
      { prefix .. "b", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
      { prefix .. "t", "<cmd>ObsidianTags<CR>", desc = "Tags" },
      { prefix .. "t", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
      { prefix .. "l", "<cmd>ObsidianLink<CR>", desc = "Link" },
      { prefix .. "L", "<cmd>ObsidianLinks<CR>", desc = "Links" },
      { prefix .. "N", "<cmd>ObsidianLinkNew<CR>", desc = "New Link" },
      { prefix .. "e", "<cmd>ObsidianExtractNote<CR>", desc = "Extract Note" },
      { prefix .. "w", "<cmd>ObsidianWorkspace<CR>", desc = "Workspace" },
      { prefix .. "r", "<cmd>ObsidianRename<CR>", desc = "Rename" },
      { prefix .. "i", "<cmd>ObsidianPasteImg<CR>", desc = "Paste Image" },
      { prefix .. "d", "<cmd>ObsidianDailies<CR>", desc = "Daily Notes" },
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/obsidian/personal/",
        },
      },

      notes_subdir = "Notes",

      daily_notes = {
        folder = "Journal/Entries/Daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "_data_/templates/journal/daily_entry.md",
      },

      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<C-c>"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      templates = {
        subdir = "_data_/templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },

      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,

      attachments = {
        img_folder = "_data_/media",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "obsidian", icon = " " },
      },
    },
  },
}