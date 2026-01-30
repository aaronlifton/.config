-- Install docs
-- nvim --headless +"DevdocsInstall rust"
-- nvim --headless +"DevdocsInstall javascript"
local use_glow = false
return {
  {
    "luckasRanarison/nvim-devdocs",
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
    -- Needed when installing docs -- via `nvim --headless +"DevdocsInstall"`
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>sE", "<cmd>DevdocsOpen<cr>", desc = "Devdocs" },
      { "<leader>se", "<cmd>DevdocsOpenCurrent<cr>", desc = "Devdocs Current" },
      { "<leader>se", "<cmd>DevdocsOpenCurrent<cr>", desc = "Devdocs Current" },
    },
    opts_extend = { "ensure_installed" },
    opts = {
      dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
      telescope = {}, -- passed to the telescope picker
      float_win = { -- passed to nvim_open_win(), see :h api-floatwin
        relative = "editor",
        height = 25,
        width = 100,
        border = "rounded",
      },
      wrap = false, -- text wrap, only applies to floating window
      previewer_cmd = use_glow and "glow" or nil, -- for example: "glow"
      cmd_args = { "-s", "~/.config/themes/glow/tokyo_night.json", "-w", "80" }, -- example using glow: { "-s", "dark", "-w", "80" }
      cmd_ignore = {}, -- ignore cmd rendering for the listed docs
      picker_cmd = true, -- use cmd previewer in picker preview
      picker_cmd_args = { "-p" }, -- example using glow: { "-s", "dark", "-w", "50" }
      after_open = function(bufnr)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", {})
      end,
      ensure_installed = {
        "fish-3.6",
        "git",
        "javascript",
        "jest",
        "lua-5.4",
        "node",
        "npm",
        "python-3.14.0",
        "rails-7.2",
        "rails-8.1.2",
        "react",
        "ruby-3.3",
        "ruby-3.4.8",
        "typescript",
      },
    },
  },
}
