-- local function get_prompt(prompt)
--   return require("sidekick.config").cli.prompts[prompt]
-- end

return {
  { import = "lazyvim.plugins.extras.ai.sidekick" },
  {
    "folke/sidekick.nvim",
    config = {
      nes = {
        enabled = false,
      },
    },
    keys = {
      -- {
      --     "<tab>",
      --     function()
      --       -- if there is a next edit, jump to it, otherwise apply it if any
      --       if not require("sidekick").nes_jump_or_apply() then
      --         return "<Tab>" -- fallback to normal tab
      --       end
      --     end,
      --     expr = true,
      --     desc = "Goto/Apply Next Edit Suggestion",
      --   },
      {
        "<c-.>",
        function()
          -- require("sidekick.cli").toggle()
          Util.sidekick.focus_tui_window("codex")
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      -- stylua: ignore start
      { "<leader>aN", function() require("sidekick.nes").toggle() end, mode = { "n" }, desc = "Toggle NES" },

      -- TUIs
      { "<leader>ac", function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end, desc = "Sidekick Codex Toggle" },
      -- { "<leader>ac", function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end, desc = "Sidekick Codex Toggle" },
      { "<leader>aC", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick Claude Toggle" },
      { "<leader>a<C-c>", function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end, desc = "Sidekick Claude Toggle" },

      -- Sends
      { "<leader>al", function() require("sidekick.cli").send({ msg = " {line}" }) end, desc = "Sidekick Send Line", mode = {"n", "v"} },
      { "<leader>ad", function()
        require("sidekick.cli").send({ msg = "Can you help me fix these diagnostics?\n{diagnostics_curline}" })
      end, desc = "Sidekick Send Diagnostics" },
      { "<leader>aD", function() require("sidekick.cli").send({ msg = "Can you help me fix the diagnostics in {file}?\n{diagnostics}" }) end, desc = "Sidekick Send Diagnostics" },
      { "<leader>ae", function() require("sidekick.cli").send({ msg = "Explain {this}" }) end, desc = "Sidekick Explain" },
      -- "avante: focus" uses <leader>aF 
      { "<leader>af", function() require("sidekick.cli").send({ msg = " {file}" }) end, desc = "Sidekick Send File" },

      -- Git
      { "<leader>g<C-r>", function() require("sidekick.cli").send({ msg = "Can you review my changes?" }) end, desc = "Sidekick Review Changes" },
      -- stylua: ignore end
    },
    init = function()
      -- NOTE: There doesn't seem to be a current way to remove the
      -- vim.ui.select override in ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/fzf.lua:199
      -- so we set it again here to ensure mini.pick is the default vim.ui.select
      LazyVim.on_very_lazy(function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
          require("lazy").load({ plugins = { "mini.pick" } })
          vim.ui.select = MiniPick.ui_select
          vim.api.nvim_echo({ { vim.inspect("here"), "Normal" } }, true, {})
          return vim.ui.select(...)
        end

        local Context = require("sidekick.cli.context")
        setmetatable(Context, {
          __index = Context.context,
          __newindex = function(_, key, value)
            Context.context[key] = value
          end,
        })
        -- Add current line diagnostics context
        Context.diagnostics_curline = function(ctx)
          local lnum = vim.api.nvim_win_get_cursor(0)[1]
          local Diag = require("sidekick.cli.context.diagnostics")
          return Diag.get(ctx, { lnum = lnum - 1, severity = vim.diagnostic.severity.ERROR })
        end
        -- Change diagnostics context to only show errors
        Context.diagnostics = function(ctx)
          local Diag = require("sidekick.cli.context.diagnostics")
          return Diag.get(ctx, { severity = vim.diagnostic.severity.ERROR })
        end
      end)
    end,
  },
}
