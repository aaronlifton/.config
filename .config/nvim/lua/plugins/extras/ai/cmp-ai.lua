return {
  {
    "tzachar/cmp-ai",
    dependencies = "nvim-lua/plenary.nvim",
    config = function(_, opts)
      local cmp_ai = require("cmp_ai.config")

      -- https://github.com/tzachar/cmp-ai
      -- https://codestral.mistral.ai/v1/fim/completions
      -- https://codestral.mistral.ai/v1/chat/completions
      cmp_ai:setup({
        max_lines = 1000,
        provider = "Codestral",
        provider_options = {
          model = "codestral-latest",
        },
        notify = true,
        notify_callback = function(msg)
          vim.notify(msg)
        end,
        run_on_every_keystroke = true,
        ignored_file_types = {
          -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "tzachar/cmp-ai" },
    },
    opts = function(_, opts)
      -- table.insert(opts.sources, { name = "cmp_ai" })
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-x>"] = cmp.mapping(
          cmp.mapping.complete({
            config = {
              sources = cmp.config.sources({
                { name = "cmp_ai" },
              }),
            },
          }),
          { "i" }
        ),
      })
    end,
  },
}
