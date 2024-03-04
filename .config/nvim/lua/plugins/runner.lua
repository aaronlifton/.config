return {
  {
    "MarcHamamji/runner.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("runner").setup({
        filetype = {
          markdown = function(...)
            local markdownCompileOptions = {
              Normal = "pdf",
              Presentation = "beamer",
            }
            vim.ui.select(vim.tbl_keys(markdownCompileOptions), {
              prompt = "Select preview mode:",
            }, function(opt, _)
              if opt then
                require("code_runner.hooks.preview_pdf").run({
                  command = "pandoc",
                  args = { "$fileName", "-o", "$tmpFile", "-t", markdownCompileOptions[opt] },
                  preview_cmd = "/bin/zathura --fork",
                })
              else
                print("Not Preview")
              end
            end)
          end,
          java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
          lua = "lua",
          python = "python3 -u",
          typescript = "deno run",
          rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
          javascript = "node",
          shellscript = "bash",
        },
      })
    end,
  },
  {
    "CRAG666/code_runner.nvim",
    config = true,
  },
  -- {
  --   "CRAG666/betterTerm.nvim",
  --   enabled = false,
  --   config = function(_, opts)
  --     require("betterTerm").setup()
  --   end,
  --   keys = {
  --     { "<C-;>", "<cmd>lua require('betterTerm').open()<CR>", desc = "Open betterTerm", mode = { "n" } },
  --     { "<C-s>", "<cmd>lua require('betterTerm').select()<CR>", desc = "Select terminal", mode = { "t" } },
  --   },
  -- },
}
