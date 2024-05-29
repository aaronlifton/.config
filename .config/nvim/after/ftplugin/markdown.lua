vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<CR>]], { desc = "Next Heading", buffer = true })
vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<CR>]], { desc = "Prev Heading", buffer = true })

local filename = vim.fn.expand("%:t")
local current_path = vim.fn.expand("%:p")
local is_doc = string.find(current_path, "aaron/Documents") ~= nil

-- if vim.bo.buftype == "help" or filename == "README.md" or filename == "CHANGELOG.md" or is_doc then
vim.diagnostic.disable()
-- end
-- vim.opt_local.spell = false

-- LazyVim.toggle("spell", { false })
-- LazyVim.toggle.diagnostics()
-- LazyVim.lsp.disable("marksman")
-- LazyVim.lsp.disable("vale")
-- end

local function motion_t(current_pos, char)
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  local line = vim.api.nvim_get_current_line()
  local start_row = current_pos[1]

  local pipe_index = string.find(line, char, current_pos[2])
  if pipe_index then
    if pipe_index == #line then
      if current_pos[1] == line_count then
        return
      end
      local new_start_pos = { current_pos[1] + 1, 0 }
      motion_t(new_start_pos, char)
    else
      local new_pos = { start_row, pipe_index + 1 }
      vim.api.nvim_win_set_cursor(0, new_pos)
    end
  end
end

local function motion_t_reverse(current_pos, char)
  local line = vim.api.nvim_get_current_line()
  local start_row = current_pos[1]

  local pipe_index = string.find(line, char, 0)
  if pipe_index then
    local new_pos = { start_row, math.min(0, pipe_index - 1) }
    vim.api.nvim_win_set_cursor(0, new_pos)
  end
end

local table_keymap_active = false
function toggle_table_keymap()
  if table_keymap_active == true then
    vim.keymap.del({ "n", "x" }, "g[", { buffer = true })
    vim.keymap.del({ "n", "x" }, "g]", { buffer = true })
    -- vim.api.nvim_del_keymap("n", "g[")
    -- vim.api.nvim_del_keymap("n", "g]")
  else
    vim.keymap.set({ "n", "x" }, "g]", function()
      -- local current_pos = vim.api.nvim_win_get_cursor(0)
      -- motion_t(current_pos, "|")
      local pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local count = 0
      local line_remaining = string.sub(line, pos[2] + 1)
      for pipe in string.gmatch(line_remaining, "|") do
        count = count + 1
      end

      if count == 1 then
        vim.cmd("norm 2f|2l")
      else
        vim.cmd("norm f|2l")
      end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("R", true, false, true), "x!", true)
    end, { desc = "Next column", buffer = true })

    vim.keymap.set({ "n", "x" }, "g[", function()
      local pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local count = 0
      local line_before = string.sub(line, 0, pos[2])
      for pipe in string.gmatch(line_before, "|") do
        count = count + 1
      end

      if count == 1 then
        vim.cmd("norm 3F|2l")
      else
        vim.cmd("norm 2F|2l")
      end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("R", true, false, true), "x!", true)
    end, { desc = "Prev column", buffer = true })
    table_keymap_active = true
  end
end

vim.keymap.set({ "n", "x" }, "<leader>uom", toggle_table_keymap, { desc = "Toggle table keymap", buffer = true })
local current_buf = vim.api.nvim_get_current_buf()
require("which-key").register({ ["<leader>uo"] = { name = "Filetype keymaps" } }, { mode = "n", buffer = current_buf })
