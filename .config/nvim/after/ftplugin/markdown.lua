vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<CR>]], { desc = "Next Heading", buffer = true })
vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<CR>]], { desc = "Prev Heading", buffer = true })

vim.diagnostic.enable(false)
vim.opt_local.spell = false
-- vim.schedule_wrap(function()
--   vim.cmd("lua vim.opt_local.spell = false")
-- end)

-- stylua: ignore start
if LazyVim.has("markdowny.nvim") then
  vim.keymap.set("v", "<C-b>", function() require('markdowny').bold() end, { buffer = 0 })
  vim.keymap.set("v", "<C-i>", function() require('markdowny').italic() end, { buffer = 0 })
  vim.keymap.set("v", "<C-k>", function() require('markdowny').link() end, { buffer = 0 })
  vim.keymap.set("v", "<C-e>", function() require('markdowny').code() end, { buffer = 0 })
end
-- stylua: ignore end

if LazyVim.has("mini.ai") then
  local spec_pair = require("mini.ai").gen_spec.pair
  vim.b.miniai_config = {
    custom_textobjects = {
      ["*"] = spec_pair("*", "*", { type = "greedy" }),
      ["_"] = spec_pair("_", "_", { type = "greedy" }),
      S = {
        {
          "%b{}",
          "\n%s*\n()().-()\n%s*\n[%s]*()", -- normal paragraphs
          "^()().-()\n%s*\n[%s]*()", -- paragraph at start of file
          "\n%s*\n()().-()()$", -- paragraph at end of file
        },
        {
          -- ("[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]"):format(), -- normal sentence
          "[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]", -- normal sentence
          "^[%{%[]?[%s]*()().-[^%s].-()[%.?!]()[%s]", -- sentence at start of paragraph
          "[%.?!][%s]+()().-[^%s].-()()[\n%}%]]?$", -- sentence at end of paragraph
          "^[%s]*()().-[^%s].-()()[%s]+$", -- sentence at that fills paragraph (no final punctuation)
        },
      },
    },
  }
end

-- NOTE: Enable for better workflow with markdown tables
-- local table_keymap_active = false
-- function toggle_table_keymap()
--   if table_keymap_active == true then
--     vim.keymap.del({ "n", "x" }, "g[", { buffer = true })
--     vim.keymap.del({ "n", "x" }, "g]", { buffer = true })
--   else
--     vim.keymap.set({ "n", "x" }, "|[", function()
--       local pos = vim.api.nvim_win_get_cursor(0)
--       local line = vim.api.nvim_get_current_line()
--       local count = 0
--       local line_remaining = string.sub(line, pos[2] + 1)
--       for pipe in string.gmatch(line_remaining, "|") do
--         count = count + 1
--       end
--
--       if count == 1 then
--         vim.cmd("norm 2f|2l")
--       else
--         vim.cmd("norm f|2l")
--       end
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("R", true, false, true), "x!", true)
--     end, { desc = "Next column", buffer = true })
--
--     vim.keymap.set({ "n", "x" }, "[|", function()
--       local pos = vim.api.nvim_win_get_cursor(0)
--       local line = vim.api.nvim_get_current_line()
--       local count = 0
--       local line_before = string.sub(line, 0, pos[2])
--       for pipe in string.gmatch(line_before, "|") do
--         count = count + 1
--       end
--
--       if count == 1 then
--         vim.cmd("norm 3F|2l")
--       else
--         vim.cmd("norm 2F|2l")
--       end
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("R", true, false, true), "x!", true)
--     end, { desc = "Prev column", buffer = true })
--     table_keymap_active = true
--   end
-- end
--
-- local current_buf = vim.api.nvim_get_current_buf()
-- vim.api.nvim_buf_create_user_command(current_buf, "ToggleMarkdownTableKeymap", toggle_table_keymap, {})
-- vim.api.nvim_buf_set_keymap(
--   current_buf,
--   "n",
--   "<leader>uom",
--   "<cmd>ToggleMarkdownTableKeymap<cr>",
--   { desc = "Toggle table keymap" }
-- )
-- require("which-key").add({ mode = "n", { "<leader>uo", group = "Markdown keymap", buffer = current_buf } })
