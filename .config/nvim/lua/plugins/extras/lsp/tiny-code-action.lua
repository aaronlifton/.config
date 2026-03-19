return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = "LspAttach",
    keys = {
      {
        "<leader>ca",
        function()
          -- ---@type vim.lsp.buf.code_action.Opts
          -- local opts = {}
          require("tiny-code-action").code_action({})
        end,
        mode = { "n", "x" },
        desc = "Code Action",
        noremap = true,
        silent = true,
      },
    },
    opts = {
      backend = "difftastic",
      buffer = {
        hotkeys = true,
        hotkeys_mode = "text_diff_based", -- can also be a function(titles, used_hotkeys) returning a list of hotkey strings
      },
      picker = "snacks",
      backend_opts = {
        difftastic = {
          -- header_lines_to_remove = 1,
          --
          -- -- The arguments to pass to difftastic
          -- args = {
          --   "--color=always",
          --   "--display=inline",
          --   "--syntax-highlight=on",
          -- },
        },
      },

      -- -- The icons to use for the code actions
      -- -- You can add your own icons, you just need to set the exact action's kind of the code action
      -- -- You can set the highlight like so: { link = "DiagnosticError" } or  like nvim_set_hl ({ fg ..., bg..., bold..., ...})
      -- signs = {
      --   quickfix = { "", { link = "DiagnosticWarning" } },
      --   others = { "", { link = "DiagnosticWarning" } },
      --   refactor = { "", { link = "DiagnosticInfo" } },
      --   ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
      --   ["refactor.extract"] = { "", { link = "DiagnosticError" } },
      --   ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
      --   ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
      --   ["source"] = { "", { link = "DiagnosticError" } },
      --   ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
      --   ["codeAction"] = { "", { link = "DiagnosticWarning" } },
      -- },
    },
  },
}
