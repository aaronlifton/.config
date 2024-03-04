return {
  {
    -- "huynle/ogpt.nvim",
    dir = "/Users/aaron/projects/ogpt.nvim",
    enabled = false,
    -- dev = true,
    -- dir = "/Users/aaron/.local/share/nvim/lazy/ogpt.nvim",
    event = "VeryLazy",
    -- opts = {
    --   -- api_host_cmd = "ollama run mistral",
    --   api_host_cmd = "ollama",
    --   actions = {
    --     code_completion = {
    --       -- type = "chat",
    --       opts = {
    --         --   system = [[you are a copilot; a tool that uses natural language processing (nlp)
    --         -- techniques to generate and complete code based on user input. you help developers write code more quickly and efficiently by
    --         -- generating boilerplate code or completing partially written code. respond with only the resulting code snippet. this means:
    --         -- 1. do not include the code context that was given
    --         -- 2. only place comments in the code snippets
    --         -- ]],
    --         --   strategy = "display",
    --         params = {
    --           model = "deepseek-coder:6.7b",
    --         },
    --       },
    --     },
    --     edit_code_with_instructions = {
    --       -- type = "chat",
    --       opts = {
    --         -- strategy = "edit_code",
    --         -- delay = true,
    --         params = {
    --           model = "deepseek-coder:6.7b",
    --         },
    --       },
    --     },
    --     edit_with_instructions = {
    --       -- type = "chat",
    --       opts = {
    --         -- strategy = "edit",
    --         -- delay = true,
    --         params = {
    --           model = "mistral:7b",
    --         },
    --       },
    --     },
    --   },
    -- },
    -- keys = {
    --   -- { "c<CR>", "<cmd>OGPTRun code_completion<CR>", "Code Completion", mode = { "n", "v" } },
    --   { "<leader>c", name = "OGPT" },
    --   { "<leader>e", "<cmd>OGPTRun edit_with_instructions<CR>", "Edit with instruction", mode = { "n", "v" } },
    --   {
    --     "<leader>c",
    --     "<cmd>OGPTRun edit_code_with_instructions<CR>",
    --     "Edit code with instruction",
    --     mode = { "n", "v" },
    --   },
    --   {
    --     "<leader>h",
    --     "<cmd>OGPTRun edit_code_with_instructions2cii2",
    --     mode = { "n", "v" },
    --   },
    --   { "<leader>g", "<cmd>ogptrun grammar_correction<cr>", "Grammar Correction", mode = { "n", "v" } },
    --   { "<leader>t", "<cmd>OGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
    --   { "<leader>k", "<cmd>OGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
    --   { "<leader>d", "<cmd>OGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
    --   { "<leader>a", "<cmd>OGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
    --   { "<leader>o", "<cmd>OGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
    --   { "<leader>s", "<cmd>OGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
    --   { "<leader>f", "<cmd>OGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
    --   { "<leader>x", "<cmd>OGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
    --   { "<leader>r", "<cmd>OGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
    --   { "<leader>l", "<cmd>OGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
    -- },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    setup = function(_, opts)
      require("ogpt").setup(opts)
    end,
  },
}
