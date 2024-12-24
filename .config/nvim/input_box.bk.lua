local Box = require("util.nui.box")

---@class InputBox
---@field position
local InputBox = Box:extend("InputBox")

function InputBox:init(options)
  local height = 4

  local row_position = 2 -- Default position is 2 lines below

  -- If in visual mode, adjust position based on selection size and cursor position
  local mode = vim.fn.mode()
  if mode:match("[vV]") then
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_row = start_pos[2]
    local end_row = end_pos[2]
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1]

    -- Calculate number of lines in selection
    local selection_lines = math.abs(end_row - start_row) + 1

    -- Only adjust position if cursor is at the start of selection
    if cursor_row == math.min(start_row, end_row) then row_position = selection_lines + 2 end
    -- If cursor is at end of selection, keep default row_position of 2
  end
  -- vim.api.nvim_echo({ { "row_position: ", "Title" }, { vim.inspect(row_position), "Normal" } }, true, {})

  options = vim.tbl_deep_extend("force", {
    title = "Input Box",
    relative = "cursor",
    width = 60,
    height = height,
    position = {
      row = row_position,
      col = 0,
    },
    on_mount = function(popup)
      -- vim.cmd("startinsert!")
    end,
    on_submit = options and options.on_submit or function(content) end,
    on_close = options and options.on_close or function() end,
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, options or {})

  InputBox.super.init(self, options)
  self.options = options
end

function InputBox:mount()
  InputBox.super.mount(self)

  self:set_keymap({
    ["<CR>"] = {
      callback = function()
        local contents = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)
        local result = table.concat(contents, "\n")
        self.options.on_submit(result)
        self:unmount()
      end,
      desc = "Submit content",
    },
    ["<ESC>"] = {
      callback = function()
        self.options.on_close()
        self:unmount()
      end,
      desc = "Close box",
    },
    ["<C-c>"] = {
      callback = function()
        self.options.on_close()
        self:unmount()
      end,
      desc = "Close box",
    },
  })

  -- InputBox.super.mount(self)
end

return InputBox
