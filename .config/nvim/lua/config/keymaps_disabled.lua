-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Terminal Mappings
-- Disabled while plugins are lazy loaded
-- map('n', '<C-h>', '<Cmd>NvimTmuxNavigateLeft<CR>', { noremap = true, desc = "Go to left window", silent = true })
-- map('n', '<C-j>', '<Cmd>NvimTmuxNavigateDown<CR>', { noremap = true, desc = "Go to lower window", silent = true })
-- map('n', '<C-k>', '<Cmd>NvimTmuxNavigateUp<CR>', { noremap = true, desc = "Go to upper window", silent = true })
-- map('n', '<C-l>', '<Cmd>NvimTmuxNavigateRight<CR>', { noremap = true, desc = "Go to right window", silent = true })
-- map('n', '<C-\\>', '<Cmd>NvimTmuxNavigateLastActive<CR>', { silent = true })
-- map('n', '<C-Space>', '<Cmd>NvimTmuxNavigateNext<CR>', { silent = true })

-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Telescope

-- local MiniExtra = require("mini.extra")
-- map("n", "<leader>e", function()
--   local mini = MiniExtra.pickers.git_files()
-- end, opts)
-- map("n", "<leader>fm", function()
--   MiniExtra.pickers.git_files({ scope = "modified" })
-- end, opts)
-- map("n", "<leader>fu", function()
--   MiniExtra.pickers.git_files({ scope = "untracked" })
-- end, opts)
-- map("n", "<leader>fd", function()
--   MiniExtra.pickers.diagnostic()
-- end, opts)

-- require("telescope").load_extension("project")
-- map("n", "<leader>fw", ":lua  require('telescope').extensions.project.project({})", { noremap = true, silent = true })
