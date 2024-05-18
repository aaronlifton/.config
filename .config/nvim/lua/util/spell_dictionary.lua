local M = {}

function M.add_to_vale_dictionary()
  local cword = vim.fn.expand("<cword>")
  if cword == "" then
    return
  end

  local path = ".vale/styles/config/vocabularies/Me/accept.txt"
  local file = io.open(path, "a")
  if file == nil then
    print("Could not open file: " .. path)

    M.ask_to_create_file()
  end

  if file then
    file:write(cword .. "\n")
    file:close()
    vim.api.nvim_echo({ { "Added " .. cword .. " to dictionary", "Comment" } }, true, {})
  end
end

M.ask_to_create_file = function()
  local Menu = require("nui.menu")
  -- local event = require("nui.utils.autocmd").event

  local menu = Menu({
    position = "50%",
    size = {
      width = 60,
      height = 5,
    },
    border = {
      style = "single",
      text = {
        top = "[Create .vale/styles/config/vocabularies/Me/accept.txt?]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = {
      Menu.item("Yes"),
      Menu.item("No"),
    },
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function() end,
    on_submit = function(item)
      if item.text == "Yes" then
        vim.api.nvim_echo({ { "Creating file...", "Comment" } }, true, {})
        local dirpath = ".vale/styles/config/vocabularies/Me/"
        os.execute("mkdir -p " .. dirpath)
        local path = dirpath .. "/accept.txt"
        local file = io.open(path, "w")
        if file == nil then
          print("Could not open file: " .. path)
          return
        end
        file:close()
      end
    end,
  })

  menu:mount()
end

return M
