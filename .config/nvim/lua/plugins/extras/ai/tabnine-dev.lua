return {
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    dir = "/Users/aaron/Code/nvim-plugins/tabnine-nvim/",
    event = { "LazyFile" },
    cmd = {
      "TabnineChat",
      "TabnineChatClear",
      "TabnineChatClose",
      "TabnineChatNew",
      "TabnineDisable",
      "TabnineEnable",
      "TabnineHub",
      "TabnineHubUrl",
      "TabnineLogin",
      "TabnineLogout",
      "TabnineStatus",
      "TabnineToggle",
    },
    config = function(_, opts)
      require("tabnine").setup({
        disable_auto_comment = true,
        -- accept_keymap = "<Tab>",
        -- This is *effectively* disabled. There's no true way to disable it.
        accept_keymap = "<C-[>", -- Default: "<Tab>"        debounce_ms = 800,
        dismiss_keymap = "<C-]>",
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil, -- absolute path to Tabnine log file
        debounce_ms = 500, -- Faster pls. Default: 800
      })
    end,
  },
}
