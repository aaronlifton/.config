local persisted = require("persisted")
local p_config = require("persisted.config")

local sep = require("persisted.utils").dir_pattern()

---Escapes special characters before performing string substitution
---@param str string
---@param pattern string
---@param replace string
---@param n? integer
---@return string
---@return integer
local function escape_pattern(str, pattern, replace, n)
  pattern = string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  replace = string.gsub(replace, "[%%]", "%%%%") -- escape replacement

  return string.gsub(str, pattern, replace, n)
end

---Fire an event
---@param event string
local function fire(event)
  vim.api.nvim_exec_autocmds("User", { pattern = "Persisted" .. event })
end

local M = {}

local function list_sessions()
  local sessions = {}

  for index, session in pairs(persisted.list()) do
    local session_name = escape_pattern(session, p_config.save_dir, "")
      :gsub("%%", sep)
      :gsub(vim.fn.expand("~"), sep)
      :gsub("//", "")
      :sub(1, -5)

    if vim.fn.has("win32") == 1 then
      session_name = escape_pattern(session_name, sep, ":\\", 1)
      session_name = escape_pattern(session_name, sep, "\\")
    end

    local branch, dir_path

    if string.find(session_name, "@@", 1, true) then
      local splits = vim.split(session_name, "@@", { plain = true })
      branch = table.remove(splits, #splits)
      dir_path = vim.fn.join(splits, "@@")
    else
      dir_path = session_name
    end

    sessions[index] = {
      branch = branch,
      text = session,
      dir = dir_path,
      file = dir_path,
    }
  end

  -- {
  --   _path = "C:/Users/hasan/dotfiles",
  --   dir = "C:\\Users\\hasan\\dotfiles",
  --   file = "C:\\Users\\hasan\\dotfiles",
  --   idx = 1,
  --   score = 1000,
  --   text = "C:\\Users\\hasan\\AppData\\Local\\nvim-data\\sessions\\C%Users%hasan%dotfiles.vim"
  -- }

  return sessions
end

function M.persisted()
  Snacks.picker.pick({
    layout = "dropdown",
    source = "Persisted Sessions",
    format = "file",
    finder = list_sessions,
    win = {
      input = {
        keys = {
          ["<c-x>"] = { "delete_session", mode = { "i", "n" } },
          ["<c-s>"] = { "live_grep", mode = { "i", "n" } },
          ["<c-r>"] = { "oldfiles", mode = { "i", "n" } },
          ["<c-t>"] = { "tabedit", mode = { "i", "n" } },
          ["<c-w>"] = { "change_dir", mode = { "i", "n" } },
          ["<c-f>"] = { "find_files", mode = { "i", "n" } },
          -- ['<c-d>'] = { 'delete_project', mode = { 'i', 'n' } },
        },
      },
    },
    confirm = function(p, item)
      -- dd(item)
      p:close()
      fire("PickerLoadPre")
      vim.schedule(function()
        persisted.load({ session = item.text })
      end)
      fire("PickerLoadPost")
    end,
    actions = {
      delete_session = function(p, item)
        local msg = "Delete selected session?"
        -- msg = msg:format(#item, #selected > 1 and 's' or '')

        if vim.fn.confirm(msg, "&Yes\n&No", 1) == 1 then
          vim.fn.delete(vim.fn.expand(item.text))
          p:close()
        end
      end,
      find_files = function(_, item)
        ---@diagnostic disable-next-line: missing-fields
        Snacks.picker.pick("files", { cwd = item.file })
      end,
      tabedit = function(_, item)
        vim.cmd("tabedit")
        ---@diagnostic disable-next-line: missing-fields
        Snacks.picker.pick("files", { cwd = item.file })
      end,
      live_grep = function(_, item)
        Snacks.picker.pick("grep", { cwd = item.file })
      end,
      oldfiles = function(_, item)
        ---@diagnostic disable-next-line: missing-fields
        Snacks.picker.pick("recent", { filter = { cwd = item.file } })
      end,
    },
  })
end

-- local project = require('project_nvim.project')
-- local history = require('project_nvim.utils.history')
-- local results = history.get_recent_projects()

--keymap('n', '<leader>nn', function()
--  ---@type snacks.picker.Config
--  Snacks.picker({
--    -- layout = 'dropdown',
--    layout = {
--      layout = {
--        box = 'horizontal',
--        width = 0.8,
--        height = 0.8,
--        {
--          box = 'vertical',
--          border = 'rounded',
--          title = 'Project picker',
--          { win = 'input', height = 1, border = 'bottom' },
--          { win = 'list', border = 'none' },
--        },
--      },
--    },
--    win = {
--      input = {
--        keys = {
--          ['<c-s>'] = { 'live_grep', mode = { 'i', 'n' } },
--          ['<c-r>'] = { 'oldfiles', mode = { 'i', 'n' } },
--          ['<c-t>'] = { 'tabedit', mode = { 'i', 'n' } },
--          ['<c-w>'] = { 'change_dir', mode = { 'i', 'n' } },
--          ['<c-d>'] = { 'delete_project', mode = { 'i', 'n' } },
--        },
--      },
--    },
--    -- cmd = 'fd',
--    -- finder = function()
--    --   return list_sessions()
--    --   -- local items = {}
--    --   -- for _, item in ipairs(results) do
--    --   --   items[#items + 1] = {
--    --   --     file = item,
--    --   --     text = item,
--    --   --   }
--    --   -- end
--    --   -- return items
--    -- end,
--    format = function(item, _)
--      local file = item.file
--      local ret = {}
--      local a = Snacks.picker.util.align
--      local icon, icon_hl = Snacks.util.icon(file.ft, 'directory')
--      ret[#ret + 1] = { a(icon, 3), icon_hl }
--      ret[#ret + 1] = { ' ' }
--      ret[#ret + 1] = { a(file, 20) }

--      return ret
--    end,
--    actions = {

--    },
--  })
--end)

return M.persisted
