local Box = require("util.nui.box")
local event = require("nui.utils.autocmd").event

---@class InputBox: NuiPopup
local InputBox = Box:extend("InputBox")
local ns_id = vim.api.nvim_create_namespace("input_box_selection")

function InputBox:init(options)
  local height = 4

  local row_position = 2 -- Default position is 2 lines below

  self.last_bufnr = vim.api.nvim_get_current_buf()
  self.mode = vim.fn.mode()

  if self.mode:match("[vV]") then
    local v = self.mode == "v"
    local cursor_pos = vim.fn.getpos(".")
    local visual_pos = vim.fn.getpos("v")
    local cursor_row = cursor_pos[2]
    local cursor_col = cursor_pos[3]
    local visual_row = visual_pos[2]
    local visual_col = visual_pos[3]

    -- Store positions for highlighting
    local cursor_row_before = cursor_row <= visual_row
    self.start_row = math.min(cursor_row, visual_row)
    if v then
      if cursor_row_before then
        self.start_col = cursor_col
      else
        self.start_col = visual_col
      end
    else
      self.start_col = 0
    end
    self.end_row = math.max(cursor_row, visual_row)
    if v then
      if cursor_row_before then
        self.end_col = visual_col
      else
        self.end_col = cursor_col
      end
    else
      self.end_col = 0
    end

    local selection_lines = math.abs(visual_row - cursor_row) + 1

    -- Only adjust position if cursor is at the start of selection
    if cursor_row == self.start_row then row_position = selection_lines + 2 end
    -- If cursor is at end of selection, keep default row_position of 2
  end

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
      vim.cmd("startinsert!")
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
  if self.start_row and self.end_row then
    -- vim.api.nvim_echo({
    --   {
    --     vim.inspect({
    --       start_row = self.start_row,
    --       end_row = self.end_row,
    --       start_col = self.start_col,
    --       end_col = self.end_col,
    --     }),
    --     "Normal",
    --   },
    -- }, true, {})
    local end_offset
    if self.mode == "v" then
      end_offset = 1
    else
      end_offset = 0
    end

    vim.schedule(function()
      vim.highlight.range(
        self.last_bufnr,
        ns_id,
        "Visual",
        { self.start_row - 1, self.start_col },
        { self.end_row - end_offset, self.end_col },
        { priority = 100 }
      )
    end)

    local function clear_highlight()
      vim.api.nvim_buf_clear_namespace(self.last_bufnr, ns_id, 0, -1)
    end

    self:on(event.BufLeave, clear_highlight)
    self:on(event.BufUnload, clear_highlight)
  end

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
end

return InputBox
