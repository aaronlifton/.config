-- local function get_prompt(prompt)
--   return require("sidekick.config").cli.prompts[prompt]
-- end

local state = {}

local function timed_send(msg)
  local timer = vim.uv.new_timer()
  -- If sending consecutive files, add a space between them
  local msg = state.sent[msg] and " " .. msg or msg

  require("sidekick.cli").send({ msg = msg })
  state.sent_file = true
  timer:start(1000, 0, function()
    state.sent_file = false
  end)
end

return {
  { import = "lazyvim.plugins.extras.ai.sidekick" },
  {
    "folke/sidekick.nvim",
    config = {
      nes = {
        enabled = false,
        trigger = { events = {} },
      },
      copilot = {
        status = {
          enabled = false,
        },
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

      -- stylua: ignore start
      { "<c-.>", function() Util.sidekick.focus_tui_window("codex") end, desc = "Sidekick Toggle", mode = { "n", "t", "i", "x" } },
      { "<leader>aN", function() require("sidekick.nes").toggle() end, mode = { "n" }, desc = "Toggle NES" },

      -- TUIs
      { "<leader>ac", function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end, desc = "Sidekick Codex Toggle" },
      { "<leader>aC", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick Claude Toggle" },
      { "<leader>a<C-c>", function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end, desc = "Sidekick Copilot Toggle" },

      -- Sends
      { "<leader>al", function() require("sidekick.cli").send({ msg = "{line}" }) end, desc = "Sidekick Send Line", mode = {"n", "v"} },

      -- Diagnostics
      { "<leader>ad", function()
        require("sidekick.cli").send({ msg = "Can you help me fix these diagnostics?\n{diagnostics_curline}" })
      end, desc = "Sidekick Send Diagnostics (Current Line)" },
      { "<leader>aD", function() require("sidekick.cli").send({ msg = "Can you help me fix the diagnostics in {file}?\n{diagnostics}" }) end, desc = "Sidekick Send Diagnostics" },
      { "<leader>a<M-d>", function()
        require("sidekick.cli").send({ msg = "Can you explain how to fix these diagnostics?\n{diagnostics_curline}" })
      end, desc = "Sidekick Send Diagnostics (Current Line)" },

      { "<leader>ah", function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.filetype.match({ buf = buf })
        if ft == nil or type(ft) ~= "string" then return end

        local lang = vim.treesitter.language.get_lang(ft)
        local msg = ("How do I go about solving this myself? I'm trying to learn %s.\n{diagnostics_curline}"):format(lang)
        require("sidekick.cli").send({ msg = msg })
      end, desc = "Sidekick Help" },

      { "<leader>ae", function() require("sidekick.cli").send({ msg = "Explain {this}" }) end, desc = "Sidekick Explain", mode = { "v" } },
      -- "avante: focus" uses <leader>aF 
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Sidekick Send File" },
      -- Git review
      { "<leader>g<M-r>", function() require("sidekick.cli").send({ msg = "Can you review my changes?" }) end, desc = "Sidekick Review Changes" },
      -- stylua: ignore end
    },
    init = function()
      -- NOTE: There doesn't seem to be a current way to remove the
      -- vim.ui.select override in ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/fzf.lua:199
      -- so we set it again here to ensure `mini.pick` is the default `vim.ui.select`
      LazyVim.on_very_lazy(function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
          require("lazy").load({ plugins = { "mini.pick" } })
          vim.ui.select = MiniPick.ui_select
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
          return Diag.get(
            ctx,
            { lnum = lnum - 1, severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN } }
          )
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
