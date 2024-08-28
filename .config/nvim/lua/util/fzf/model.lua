local chat = require("model.core.chat")
local M = {}

local function get_mchat_buffers()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "mchat"
  end, vim.api.nvim_list_bufs())
end

local function entry_maker(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local display = lines[1]

  local chat_buf = chat.parse(lines)
  if chat_buf.contents.config.system then display = display .. " > " .. chat_buf.contents.config.system end

  display = display .. " [" .. tostring(#chat_buf.contents.messages) .. "]"

  return string.format(
    " %-15s %15s",
    fzf_utils.ansi_codes.yellow(tostring(bufnr)),
    fzf_utils.ansi_codes.blue(tostring(display)),
    I
  )
end

local function previewer()
  vim.api.nvim_win_set_buf(preview_winid, entry.bufnr)
end

local function fzf()
  local fzf_lua = require("fzf-lua")
  local previewer = fzf_lua.defaults.buffers.previewer
  local opts = {
    fzf_opts = { ["--header-lines"] = 1 },
    prompt = "Mchat>",
    fzf_colors = true,
    actions = {
      ["default"] = function(selected)
        local _, lnum, col, filepath = selected[1]:match("(.)%s+(%d+)%s+(%d+)%s+(.*)")
        vim.cmd("e " .. filepath)
        vim.defer_fn(function()
          vim.fn.cursor(lnum, col)
          vim.cmd("normal! zz")
        end, 50)
      end,
    },
    previewer = previewer,
  }
  fzf_lua.fzf_exec(entries, opts)
end
