-- stylua: ignore start
-- toggle options
local map = Util.lazy.safe_keymap_set

-- Check if Snacks is available before setting up toggles
vim.defer_fn(function()
  if not _G.Snacks then
    return
  end
  
  Util.lazy.format.snacks_toggle():map("<leader>uf")
  Util.lazy.format.snacks_toggle(true):map("<leader>uF")
  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>ul")
  Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
  Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
  Snacks.toggle.treesitter():map("<leader>uT")
  Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
  Snacks.toggle.dim():map("<leader>uD")
  Snacks.toggle.animate():map("<leader>ua")
  Snacks.toggle.indent():map("<leader>ug")
  Snacks.toggle.scroll():map("<leader>uS")
  Snacks.toggle.profiler():map("<leader>dpp")
  Snacks.toggle.profiler_highlights():map("<leader>dph")
  Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
  Snacks.toggle.zen():map("<leader>uz")

  if vim.lsp.inlay_hint then
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end

  -- lazygit
  if vim.fn.executable("lazygit") == 1 then
    map("n", "<leader>gg", function() Snacks.lazygit( { cwd = Util.lazy.root.git() }) end, { desc = "Lazygit (Root Dir)" })
    map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
    map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
    map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = Util.lazy.root.git() }) end, { desc = "Git Log" })
    map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
  end

  map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
  map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
  map({"n", "x" }, "<leader>gY", function()
    Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
  end, { desc = "Git Browse (copy)" })

  -- floating terminal
  map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
  map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = Util.lazy.root() }) end, { desc = "Terminal (Root Dir)" })
  map("n", "<c-/>",      function() Snacks.terminal(nil, { cwd = Util.lazy.root() }) end, { desc = "Terminal (Root Dir)" })
  map("n", "<c-_>",      function() Snacks.terminal(nil, { cwd = Util.lazy.root() }) end, { desc = "which_key_ignore" })

  -- Terminal Mappings
  map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
  map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
end, 100) -- Defer for 100ms to allow plugins to load

-- stylua: ignore end
