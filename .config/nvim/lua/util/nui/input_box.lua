local BasePopup = require("util.nui.base_popup")
local event = require("nui.utils.autocmd").event

---@class util.nui.InputBox: NuiPopup
---@field selection SelectionRange|nil
---@field super NuiPopup
local InputBox = BasePopup:extend("InputBox")
local NAMESPACE = vim.api.nvim_create_namespace("input_box_selection")
local PRIORITY = vim.highlight.priorities.user

-- vim.cmd([[hi default CursorLineNormal guibg=#222436]])
local should_debug = true

---@param opts base_popup_options
function InputBox:init(opts)
  opts = opts or {}
  opts.size = opts.size or { width = 60, height = 4 }

  self.selection = require("util.selection").get_selection_range()
  if not self.selection then return end
  self.code_bufnr = vim.api.nvim_get_current_buf()
  self.cursor_pos = vim.api.nvim_win_get_cursor(0)
  local code_lines = vim.api.nvim_buf_get_lines(self.code_bufnr, 0, -1, false)

  local mode = vim.fn.mode()
  local cursor_pos = vim.fn.getpos(".")
  local visual_pos = vim.fn.getpos("v")
  local cursor_row = cursor_pos[2]
  local cursor_col = cursor_pos[3]
  local visual_col = visual_pos[3]

  if mode == "V" then
    self.start_row = self.selection.start.lnum - 1
    self.start_col = 0
    self.end_row = self.selection.finish.lnum - 1
    self.end_col = #code_lines[self.selection.finish.lnum]

    self.popup_col = -cursor_col + 1
  else
    self.start_row = self.selection.start.lnum - 1
    self.start_col = math.self.selection.start.col - 1
    self.end_row = self.selection.finish.lnum - 1
    self.end_col = math.min(self.selection.finish.col, #code_lines[self.selection.finish.lnum])

    if cursor_col > visual_col then
      self.popup_col = -1 * (cursor_col - visual_col)
    else
      self.popup_col = 0
    end
  end

  local num_selection_lines = self.selection.finish.lnum - self.selection.start.lnum + 1

  local popup_row = 2
  -- Only adjust position if cursor is at the start of selection
  if cursor_row == self.selection.start.lnum then popup_row = num_selection_lines + 1 end

  opts = vim.tbl_deep_extend("force", {
    relative = "cursor",
    -- TODO: remove
    width = opts.size.width,
    height = opts.size.height,
    --
    position = {
      row = popup_row,
      col = self.popup_col or 0,
    },
    on_mount = function(_popup)
      vim.cmd("startinsert!")
      require("cmp").setup.buffer({
        sources = {
          {
            name = "buffer",
            option = {
              get_bufnrs = require("util.win").editor_bufs,
            },
          },
        },
      })
    end,
    on_submit = opts and opts.on_submit or function() end,
    on_close = opts and opts.on_close or function() end,
    win_options = {
      -- winhighlight = "Normal:Normal,FloatBorder:Normal",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      cursorline = true,
    },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = opts.title or " Prompt ",
        top_align = "center",
      },
    },
    size = {
      width = opts.size.width,
      height = opts.size.height,
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  }, opts or {})

  -- TODO: remove
  self.opts = opts
  InputBox.super.init(self, opts)
end

function InputBox:mount()
  self.selected_code_extmark_id =
    vim.api.nvim_buf_set_extmark(self.code_bufnr, NAMESPACE, self.start_row, self.start_col, {
      hl_group = "Visual",
      hl_mode = "combine",
      end_row = self.end_row,
      end_col = self.end_col,
      priority = PRIORITY,
    })

  local function clear_highlight()
    -- vim.api.nvim_buf_clear_namespace(self.last_bufnr, ns_id, 0, -1)
    if self.selected_code_extmark_id then
      vim.api.nvim_buf_del_extmark(self.code_bufnr, NAMESPACE, self.selected_code_extmark_id)
      self.selected_code_extmark_id = nil
    end
  end

  self:on(event.BufLeave, clear_highlight)
  self:on(event.BufUnload, clear_highlight)

  InputBox.super.mount(self)

  local submit_prompt = function()
    local contents = vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)
    local result = table.concat(contents, "\n")
    self.opts.on_submit(result)
    self:unmount()
  end

  self:set_keymap({
    ["<CR>"] = {
      callback = submit_prompt,
      desc = "Submit prompt",
    },
    ["<C-s>"] = {
      callback = submit_prompt,
      desc = "Submit prompt",
      mode = "i",
    },
  })
end

return InputBox
