return {
  "nvzone/timerly",
  dependencies = "nvzone/volt",
  cmd = "TimerlyToggle",
  opts = {}, -- optional
  build = function()
    local desktop_path = vim.fn.expand("~/.local/share/applications/timerly.desktop")
    if vim.fn.filereadable(desktop_path) == 0 then
      vim.fn.mkdir(vim.fn.fnamemodify(desktop_path, ":h"), "p")
      local file = assert(io.open(desktop_path, "w"))
      local content = table.concat({
        "[Desktop Entry]",
        "Type=Application",
        "Version=1.0",
        "Name=Timerly",
        "Icon=clockify",
        "Exec=st -g 42x19 -e nvim +':Timer'",
        "Terminal=false",
        "Categories=Utility;System;ConsoleOnly",
        "Keywords=timer;clock;time;task;",
        "",
      }, "\n")
      file:write(content)
      file:close()
    end
  end,
  init = function()
    vim.api.nvim_create_user_command("Timer", function()
      vim.o.showtabline = 0
      vim.o.laststatus = 0
      vim.wo.number = false
      vim.o.scl = "no"
      vim.o.cmdheight = 0
      vim.cmd("TimerlyToggle")
    end, {})
  end,
}
