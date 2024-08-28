return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "sindrets/diffview.nvim", optional = true },
    -- "nvim-telescope/telescope.nvim",
  },
  cmd = { "Neogit" },
  opts = {
    integrations = {
      diffview = true,
      -- telescope = false,
      -- fzf_lua = true,
    },
  },
  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    { "<leader>g<cr>", "<cmd>Neogit commit<cr>", desc = "Neogit - Commit" },
    -- stylua: ignore start
    { "<leader>gN", function() require("neogit").open({ kind = "split" }) end, desc = "Neogit (Split)" },
    -- stylua: ignore end
  },
  config = function(_, opts)
    require("neogit").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitView",
      callback = function(ev)
        vim.keymap.set("n", "gf", function()
          local cfile = vim.fn.expand("<cfile>")
          local f = vim.fn.findfile(cfile)
          if f ~= "" then
            -- vim.cmd("close")
            -- vim.cmd("e " .. f)
            if not require("util.tab").goto_buf_tab(cfile) then vim.cmd("tabnew | e " .. f) end
          end
        end, { buffer = ev.buf })
      end,
    })
  end,
}
