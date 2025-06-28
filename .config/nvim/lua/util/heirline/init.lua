local M = {
  utils = {},
  state = {
    CodeCompanionInProgress = false,
    AvanteInProgress = false,
  },
}

local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local hl = require("heirline-components.core.hl")
local hc_utils = require("heirline-components.core.utils")
local root_dir = LazyVim.lualine.root_dir()
local pretty_path = LazyVim.lualine.pretty_path()
local c = {}
local current_theme = vim.cmd.colorscheme()
if current_theme == "tokyonight-moon" then
  ---@diagnostic disable-next-line: cast-local-type
  c = require("tokyonight.colors").styles["moon"]
elseif current_theme == "astrodark" then
  c = require("astrotheme.lib.util").set_palettes(require("astrotheme").config)
end
local colors = {
  error_icon = LazyVim.config.icons.diagnostics.Error,
  warn_icon = LazyVim.config.icons.diagnostics.Warn,
  info_icon = LazyVim.config.icons.diagnostics.Info,
  hint_icon = LazyVim.config.icons.diagnostics.Hint,
}
local mode_colors = {
  n = c.blue,
  i = c.green,
  v = c.cyan,
  V = c.cyan,
  ["\22"] = c.cyan,
  c = "orange",
  s = c.purple,
  S = c.purple,
  ["\19"] = c.purple,
  R = c.orange,
  r = c.orange,
  ["!"] = c.red,
  t = "green",
}
if current_theme == "astrodark" then
  ---@diagnostic disable: undefined-field
  mode_colors = {
    n = c.syntax.blue,
    i = c.ui.green,
    v = c.ui.purple,
    V = c.ui.purple,
    ["\22"] = c.ui.purple,
    c = c.ui.yellow,
    s = c.ui.purple,
    S = c.ui.purple,
    ["\19"] = c.ui.purple,
    R = c.ui.red,
    r = c.ui.red,
    ["!"] = c.ui.red,
    t = c.ui.orange,
  }
  ---@diagnostic enable: undefined-field
end

-- Mode component similar to AstroNvim
M.Mode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      ["n"] = { "NORMAL", "normal" },
      ["no"] = { "O-PENDING", "normal" },
      ["nov"] = { "O-PENDING", "normal" },
      ["noV"] = { "O-PENDING", "normal" },
      ["no\22"] = { "O-PENDING", "normal" },
      ["niI"] = { "NORMAL", "normal" },
      ["niR"] = { "NORMAL", "normal" },
      ["niV"] = { "NORMAL", "normal" },
      ["nt"] = { "NORMAL", "normal" },
      ["ntT"] = { "NORMAL", "normal" },
      ["v"] = { "VISUAL", "visual" },
      ["vs"] = { "VISUAL", "visual" },
      ["V"] = { "V-LINE", "visual" },
      ["Vs"] = { "V-LINE", "visual" },
      ["\22"] = { "V-BLOCK", "visual" },
      ["\22s"] = { "V-BLOCK", "visual" },
      ["s"] = { "SELECT", "visual" },
      ["S"] = { "S-LINE", "visual" },
      ["\19"] = { "S-BLOCK", "visual" },
      ["i"] = { "INSERT", "insert" },
      ["ic"] = { "INSERT", "insert" },
      ["ix"] = { "INSERT", "insert" },
      ["R"] = { "REPLACE", "replace" },
      ["Rc"] = { "REPLACE", "replace" },
      ["Rx"] = { "REPLACE", "replace" },
      ["Rv"] = { "V-REPLACE", "replace" },
      ["Rvc"] = { "V-REPLACE", "replace" },
      ["Rvx"] = { "V-REPLACE", "replace" },
      ["c"] = { "COMMAND", "command" },
      ["cv"] = { "EX", "command" },
      ["ce"] = { "EX", "command" },
      ["r"] = { "PROMPT", "inactive" },
      ["rm"] = { "MORE", "inactive" },
      ["r?"] = { "CONFIRM", "inactive" },
      ["!"] = { "SHELL", "inactive" },
      ["t"] = { "TERMINAL", "terminal" },
    },
    mode_colors = mode_colors,
  },
  provider = function(self)
    return " %2(" .. self.mode_names[self.mode] .. "%) "
  end,
  hl = function(self)
    local color = self.mode_colors[self.mode:sub(1, 1)]
    return {
      fg = c.fg,
      bg = c[color] or c.blue,
      bold = true,
    }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

-- Fill component
M.Fill = {
  provider = "%=",
}

-- Command info component
M.CmdInfo = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ":%3.5(%S%)",
  hl = {
    fg = c.fg,
  },
}

-- Virtual environment component
M.VirtualEnv = {
  condition = function()
    return vim.env.VIRTUAL_ENV ~= nil or vim.env.CONDA_DEFAULT_ENV ~= nil
  end,
  provider = function()
    local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
    if venv then
      local name = vim.fn.fnamemodify(venv, ":t")
      return " " .. name
    end
    return ""
  end,
  hl = {
    fg = c.yellow,
    bold = true,
  },
}

-- TreeSitter component
M.TreeSitter = {
  condition = function()
    local ok, ts = pcall(require, "nvim-treesitter.parsers")
    if not ok then return false end
    return ts.has_parser()
  end,
  provider = " ",
  hl = {
    fg = c.green,
    bold = true,
  },
}

-- Navigation component (similar to ruler)
M.Nav = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file
  provider = " %3l:%-2c %3P%% ",
  hl = {
    fg = c.fg,
  },
}

-- Breadcrumbs component for winbar
M.Breadcrumbs = {
  condition = function()
    return vim.bo.filetype ~= "" and conditions.lsp_attached()
  end,
  init = function(self)
    local ok, navic = pcall(require, "nvim-navic")
    if ok and navic.is_available() then
      self.breadcrumbs = navic.get_location()
    else
      -- Fallback to document symbols if navic is not available
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients({
        bufnr = bufnr,
      })
      for _, client in pairs(clients) do
        if client.server_capabilities.documentSymbolProvider then
          self.breadcrumbs = "LSP"
          break
        end
      end
    end
  end,
  provider = function(self)
    return self.breadcrumbs and (" > " .. self.breadcrumbs) or ""
  end,
  hl = {
    fg = c.fg,
  },
}

-- Separated path component for winbar
M.SeparatedPath = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  provider = function(self)
    if self.filename == "" then return "" end
    local path = vim.fn.fnamemodify(self.filename, ":~:.:h")
    if path == "." then return "" end
    return path .. "/"
  end,
  hl = {
    fg = c.comment,
  },
}

local Root = {
  provider = root_dir[1],
  -- color = root_dir["color"],
  condition = root_dir["cond"],
}
local Path = {
  provider = pretty_path,
  hl = {
    fg = "cyan",
  },
}
M.FileNameBlock = {
  -- let's first set up some attributes needed by this component and its children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = {
    fg = c.blue5,
  },
}
-- We can now define some children separately and add them later

M.FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, {
      default = true,
    })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return {
      fg = self.icon_color,
    }
  end,
}

--- A function to build a complete file information component
---@param opts? table Optional configuration for the file info component
---@return table # The Heirline component table
-- @usage local heirline_component = require("util.heirline").file_info()
function M.file_info(opts)
  opts = vim.tbl_extend("force", {
    show_icon = true,
    show_filename = true,
    show_flags = true,
    filename_opts = {
      relative = "cwd",
      length = 3,
      modified_sign = "",
    },
  }, opts or {})

  local components = {}

  -- File icon component
  if opts.show_icon then table.insert(components, M.FileIcon) end

  -- Filename component with LazyVim's pretty path logic
  if opts.show_filename then
    table.insert(components, {
      provider = function(self)
        local result = get_pretty_path(opts.filename_opts)

        -- If result is a string (fallback case), return it directly
        if type(result) == "string" then return result end

        -- If result is a table of components, concatenate the text parts
        local text = ""
        for _, part in ipairs(result) do
          if type(part) == "table" and part.provider then text = text .. part.provider end
        end
        return text
      end,
      hl = function()
        if vim.bo.modified then
          return {
            fg = utils.get_highlight("MatchParen").fg,
            bold = true,
          }
        else
          return {
            fg = utils.get_highlight("Directory").fg,
          }
        end
      end,
    })
  end

  -- File flags (modified, readonly)
  if opts.show_flags then table.insert(components, M.FileFlags) end

  -- Return the complete component
  return {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
    hl = {
      fg = c.blue5,
    },
    unpack(components),
    {
      provider = "%<", -- truncation point
    },
  }
end

-- Pretty path function adapted from LazyVim's lualine utility
local function get_pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "MatchParen",
    directory_hl = "Comment",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3,
  }, opts or {})

  local path = vim.fn.expand("%:p")

  if path == "" then return "[No Name]" end

  -- Normalize path separators
  path = path:gsub("\\", "/")

  -- Get root directory (try to use LazyVim root detection if available)
  local root = vim.fn.getcwd()
  if LazyVim and LazyVim.root and LazyVim.root.get then root = LazyVim.root.get({
    normalize = true,
  }) end

  local cwd = vim.fn.getcwd()

  -- Make path relative
  if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  elseif path:find(root, 1, true) == 1 then
    path = path:sub(#root + 2)
  end

  local sep = "/"
  local parts = vim.split(path, "/")

  -- Truncate path if too long
  if opts.length > 0 and #parts > opts.length then
    parts = { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts) }
  end

  -- Build the display path
  local result = {}

  -- Add directory part with highlighting
  if #parts > 1 then
    local dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep) .. sep
    table.insert(result, {
      provider = dir,
      hl = {
        fg = utils.get_highlight("Comment").fg,
      },
    })
  end

  -- Add filename with appropriate highlighting
  local filename = parts[#parts] or ""
  if vim.bo.modified then
    filename = filename .. opts.modified_sign
    table.insert(result, {
      provider = filename,
      hl = {
        fg = utils.get_highlight("MatchParen").fg,
        bold = true,
      },
    })
  else
    table.insert(result, {
      provider = filename,
      hl = {
        fg = utils.get_highlight("Bold").fg or utils.get_highlight("Normal").fg,
        bold = true,
      },
    })
  end

  -- Add readonly indicator
  if vim.bo.readonly then
    table.insert(result, {
      provider = opts.readonly_icon,
      hl = {
        fg = utils.get_highlight("MatchParen").fg,
      },
    })
  end

  return result
end

M.FileName = {
  provider = function(self)
    local result = get_pretty_path({
      relative = "cwd",
      length = 3,
      modified_sign = "",
    })

    -- If result is a string (fallback case), return it directly
    if type(result) == "string" then return result end

    -- If result is a table of components, concatenate the text parts
    local text = ""
    for _, part in ipairs(result) do
      if type(part) == "table" and part.provider then text = text .. part.provider end
    end
    return text
  end,
  hl = function()
    if vim.bo.modified then
      return {
        fg = utils.get_highlight("MatchParen").fg,
        bold = true,
      }
    else
      return {
        fg = utils.get_highlight("Directory").fg,
      }
    end
  end,
}

M.FileNameFlex = {
  flexible = 2,
  {
    -- Full path
    provider = function(self)
      local result = get_pretty_path({
        relative = "cwd",
        length = 0, -- No truncation
        modified_sign = "",
      })

      if type(result) == "string" then return result end

      local text = ""
      for _, part in ipairs(result) do
        if type(part) == "table" and part.provider then text = text .. part.provider end
      end
      return text
    end,
    hl = function()
      if vim.bo.modified then
        return {
          fg = utils.get_highlight("MatchParen").fg,
          bold = true,
        }
      else
        return {
          fg = utils.get_highlight("Directory").fg,
        }
      end
    end,
  },
  {
    -- Shortened path
    provider = function(self)
      local result = get_pretty_path({
        relative = "cwd",
        length = 2,
        modified_sign = "",
      })

      if type(result) == "string" then return result end

      local text = ""
      for _, part in ipairs(result) do
        if type(part) == "table" and part.provider then text = text .. part.provider end
      end
      return text
    end,
    hl = function()
      if vim.bo.modified then
        return {
          fg = utils.get_highlight("MatchParen").fg,
          bold = true,
        }
      else
        return {
          fg = utils.get_highlight("Directory").fg,
        }
      end
    end,
  },
  {
    -- Just filename
    provider = function(self)
      local filename = vim.fn.expand("%:t")
      if filename == "" then return "[No Name]" end
      if vim.bo.modified then filename = filename .. "" end
      return filename
    end,
    hl = function()
      if vim.bo.modified then
        return {
          fg = utils.get_highlight("MatchParen").fg,
          bold = true,
        }
      else
        return {
          fg = utils.get_highlight("Directory").fg,
        }
      end
    end,
  },
}

M.FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = {
      fg = c.green,
    },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = {
      fg = c.orange,
    },
  },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

M.FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return {
        fg = "cyan",
        bold = true,
        force = true,
      }
    end
  end,
}

-- let's add the children to our FileNameBlock component
M.FileNameBlock = utils.insert(
  M.FileNameBlock,
  M.FileIcon,
  utils.insert(M.FileNameModifer, M.FileName), -- a new table where FileName is a child of FileNameModifier
  M.FileFlags,
  {
    provider = "%<",
  } -- this means that the statusline is cut here when there's not enough space
)

M.FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = {
    fg = utils.get_highlight("Type").fg,
    bold = true,
  },
}

M.FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= "unix" and fmt:upper()
  end,
}
M.FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize < 1024 then return fsize .. suffix[1] end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
  end,
}
M.FileLastModified = {
  -- did you know? Vim is full of functions!
  provider = function()
    local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
    return (ftime > 0) and os.date("%c", ftime)
  end,
}
-- We're getting minimalist here!
M.Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
}
-- I take no credits for this! 🦁
M.ScrollBar = {
  static = {
    sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    -- Another variant, because the more choice the better.
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = {
    fg = c.fg,
    bg = c.bg,
  },
}
M.LSPActive = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },

  -- You can keep it simple,
  -- provider = " [LSP]",

  -- Or complicate things a bit and get the servers names
  provider = function()
    local names = {}
    for i, server in
      pairs(vim.lsp.get_clients({
        bufnr = 0,
      }))
    do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "]"
  end,
  hl = {
    fg = c.green,
    bold = true,
  },
}

-- I personally use it only to display progress messages!
-- See lsp-status/README.md for configuration options.
-- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
M.LSPMessages = {}
if package.loaded["lsp-progress"] then
  M.LSPMessages = {
    provider = require("lsp-progress").progress(),
    hl = hl.get_hlgroup("LspProgress", { fg = c.fg_dark, bg = c.bg }),
  }
end

M.Diagnostics = {
  condition = conditions.has_diagnostics,
  -- Example of defining custom LSP diagnostic icons, you can copypaste in your config:
  -- vim.diagnostic.config({
  --  signs = {
  --    text = {
  --      [vim.diagnostic.severity.ERROR] = '',
  --      [vim.diagnostic.severity.WARN] = '',
  --      [vim.diagnostic.severity.INFO] = '',
  --      [vim.diagnostic.severity.HINT] = '',
  --    },
  --  },
  -- })
  -- Fetching custom diagnostic icons

  -- If you defined custom LSP diagnostics with vim.fn.sign_define(), use this instead
  -- Note defining custom LSP diagnostic this way its deprecated, though
  -- static = {
  --    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
  --    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
  --    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
  --    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  -- },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.ERROR,
    })
    self.warnings = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.WARN,
    })
    self.hints = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.HINT,
    })
    self.info = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.INFO,
    })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = "![",
  },
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (colors.error_icon .. self.errors .. " ")
    end,
    hl = {
      fg = utils.get_highlight("DiagnosticError").fg,
    },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (colors.warn_icon .. self.warnings .. " ")
    end,
    hl = {
      fg = utils.get_highlight("DiagnosticWarn").fg,
    },
  },
  {
    provider = function(self)
      return self.info > 0 and (colors.info_icon .. self.info .. " ")
    end,
    hl = {
      fg = utils.get_highlight("DiagnosticInfo").fg,
    },
  },
  {
    provider = function(self)
      return self.hints > 0 and (colors.hint_icon .. self.hints)
    end,
    hl = {
      fg = utils.get_highlight("DiagnosticHint").fg,
    },
  },
  {
    provider = "]",
  },
}
M.Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    local buf = vim.api.nvim_get_current_buf()
    local s = MiniDiff.get_buf_data(buf).summary
    self.status_dict = s
    self.has_changes = s.add ~= 0 or s.delete ~= 0 or s.change ~= 0
  end,

  hl = {
    fg = c.orange,
  },

  { -- git branch name
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = {
      bold = true,
    },
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "(",
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = {
      fg = "SnacksPickerGitStatusAdded",
    },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = {
      fg = "SnacksPickerGitStatusDeleted",
    },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = {
      fg = "SnacksPickerGitStatusModified",
    },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
  },
}
M.DAPMessages = {
  condition = function()
    local session = require("dap").session()
    return session ~= nil
  end,
  provider = function()
    return " " .. require("dap").status()
  end,
  hl = "Debug",
  -- see Click-it! section for clickable actions
}
M.WorkDir = {
  provider = function()
    local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
    local cwd = vim.fn.getcwd(0)
    cwd = vim.fn.fnamemodify(cwd, ":~")
    if not conditions.width_percent_below(#cwd, 0.25) then cwd = vim.fn.pathshorten(cwd) end
    local trail = cwd:sub(-1) == "/" and "" or "/"
    return icon .. cwd .. trail
  end,
  hl = {
    fg = c.blue,
    bold = true,
  },
}
M.WorkDirFlex = {
  init = function(self)
    self.icon = (vim.fn.haslocaldir(0) == 1 and "" or "") .. " " .. " "
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ":~")
  end,
  hl = {
    fg = c.blue,
    bold = true,
  },

  flexible = 1,

  {
    -- evaluates to the full-lenth path
    provider = function(self)
      local trail = self.cwd:sub(-1) == "/" and "" or "/"
      return self.icon .. self.cwd .. trail .. " "
    end,
  },
  {
    -- evaluates to the shortened path
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      local trail = self.cwd:sub(-1) == "/" and "" or "/"
      return self.icon .. cwd .. trail .. " "
    end,
  },
  {
    -- evaluates to "", hiding the component
    provider = "",
  },
}
M.TerminalName = {
  -- we could add a condition to check that buftype == 'terminal'
  -- or we could do that later (see #conditional-statuslines below)
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
    return " " .. tname
  end,
  hl = {
    fg = c.blue,
    bold = true,
  },
}
M.HelpFileName = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = {
    fg = utils.get_highlight("Directory").fg,
  },
}
M.Snippets = {
  -- check that we are in insert or select mode
  condition = function()
    return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
  end,
  provider = function()
    local forward = (vim.fn["UltiSnips#CanJumpForwards"]() == 1) and "" or ""
    local backward = (vim.fn["UltiSnips#CanJumpBackwards"]() == 1) and " " or ""
    return backward .. forward
  end,
  hl = {
    fg = c.red,
    bold = true,
  },
}
M.SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then self.search = search end
  end,
  provider = function(self)
    local search = self.search
    return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
  end,
}
M.MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  provider = " ",
  hl = {
    fg = c.orange,
    bold = true,
  },
  utils.surround({ "[", "]" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = {
      fg = c.green,
      bold = true,
    },
  }),
  update = { "RecordingEnter", "RecordingLeave" },
}
vim.opt.showcmdloc = "statusline"
M.ShowCmd = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ":%3.5(%S%)",
}

M.Grapple = {
  condition = function()
    return package.loaded["grapple"] and require("grapple").exists()
  end,
  provider = function(self)
    return "󰛢 " .. require("grapple").name_or_index()
  end,
  hl = {
    fg = c.fg_dark,
    bold = true,
  },
}
M.Flutter = {
  condition = function()
    return package.loaded["flutter-tools"]
  end,
  provider = function(elf)
    return vim.g.flutter_tools_decorations.app_version
  end,
}
-- M.WakaTime = {
--   condition = function()
--     return package.loaded["wakastat"] and require("wakastat").exists()
--   end,
--   provider = function()
--     return require("wakastat").wakatime()
--   end,
--   hl = {
--     fg = c.fg_dark,
--     bold = true,
--   },
-- }
M.WakaTime = {
  provider = function()
    return " " .. require("wakastat").wakatime() .. " "
  end,
  hl = { fg = c.cyan, bg = "NONE" },
}

local AiProgressDetectors = {
  CodeCompanionProgress = {
    condition = function()
      return package.loaded["codecompanion"]
    end,
    provider = function()
      local icon = " "
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            M.state.CodeCompanionInProgress = true
          elseif request.match == "CodeCompanionRequestFinished" then
            M.state.CodeCompanionInProgress = false
          end
        end,
      })
      return M.state.CodeCompanionInProgress and icon or nil
    end,
  },
  AvanteInProgress = {
    condition = function()
      return package.loaded["avante"]
    end,

    provider = function()
      local sidebar = require("avante").get()
      return sidebar and sidebar.is_generating and " " or nil -- 🦙
    end,
  },
}

M.AiProgress = {
  condition = function()
    for _, detector in pairs(AiProgressDetectors) do
      if detector.condition() then return true end
    end
  end,
  provider = function()
    local icons = {}
    for _, detector in pairs(AiProgressDetectors) do
      if detector.condition() then
        local icon = detector.provider()
        if icon then table.insert(icons, icon) end
      end
    end
    return table.concat(icons, " ")
  end,
  hl = {
    fg = c.blue5,
    bold = false,
  },
}

-- function M.utils.stylize(str, opts)
--   opts = vim.tbl_extend("force", {
--     padding = { left = 0, right = 0 },
--     separator = { left = "", right = "" },
--     show_empty = false,
--     escape = true,
--     icon = { kind = "NONE", padding = { left = 0, right = 0 } },
--   }, opts)
--   local icon = M.utils.pad_string(LazyVim.config.icons.kinds[opts.icon.kind], opts.icon.padding)
--   return str
--       and (str ~= "" or opts.show_empty)
--       and opts.separator.left .. M.utils.pad_string(icon .. (opts.escape and escape(str) or str), opts.padding) .. opts.separator.right
--     or ""
-- end

function M.utils.width(is_winbar)
  return vim.o.laststatus == 3 and not is_winbar and vim.o.columns or vim.api.nvim_win_get_width(0)
end

function M.utils.pad_string(str, padding)
  padding = padding or {}
  return str and str ~= "" and (" "):rep(padding.left or 0) .. str .. (" "):rep(padding.right or 0) or ""
end

M.GitBranch = function()
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  if branch == "" then
    -- vim.notify("Not in a git repository", vim.log.levels.WARN)
    return {}
  end
  return hc_utils.stylize(branch, {
    icon = { kind = "git_branch", padding = { left = 1, right = 0 } },
    padding = { left = 0, right = 1 },
    separator = { left = "", right = "" },
  })
end

M.GitBranch2 = {
  icon = { kind = "git_branch", padding = { left = 1, right = 0 } },
  padding = { left = 0, right = 1 },
  separator = { left = "", right = "" },
  provider = function()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
    if branch == "" then return "" end
    return branch
  end,
}

M.GitBranch3 = {
  icon = { kind = "git_branch", padding = { left = 1, right = 0 } },
  padding = { left = 0, right = 1 },
  separator = { left = "", right = "" },
  --[[ Truncates and formats Git branch names for display in lualine:
    First segment: Uppercase, truncated to 1 character.
    Middle segments: Lowercase, truncated to 1 character.
    Last segment: Unchanged.
    Separator: › between truncated segments and the last segment.

    Example Input/Output:
    Branch										Name	Output
    backend/setup/tailwind		Bs›tailwind
    feature/add-ui						Fa›add-ui
    main											main
  ]]
  provider = function(branch)
    if branch == '' or branch == nil then
      return 'No Repo'
    end

    -- Function to truncate a segment to a specified length
    local function truncate_segment(segment, max_length)
      if #segment > max_length then
        return segment:sub(1, max_length)
      end
      return segment
    end

    -- Split the branch name by '/'
    local segments = {}
    for segment in branch:gmatch('[^/]+') do
      table.insert(segments, segment)
    end

    -- Truncate all segments except the last one
    for i = 1, #segments - 1 do
      segments[i] = truncate_segment(segments[i], 1) -- Truncate to 1 character
    end

    -- If there's only one segment (no '/'), return it as-is
    if #segments == 1 then
      return segments[1]
    end

    -- Capitalize the first segment and lowercase the rest (except the last one)
    segments[1] = segments[1]:upper() -- First segment uppercase
    for i = 2, #segments - 1 do
      segments[i] = segments[i]:lower() -- Other segments lowercase
    end

    -- Combine the first segments with no separator and add '›' before the last segment
    local truncated_branch = table.concat(segments, '', 1, #segments - 1) .. '›' .. segments[#segments]

    -- Ensure the final result doesn't exceed a maximum length
    local max_total_length = 15
    if #truncated_branch > max_total_length then
      truncated_branch = truncated_branch:sub(1, max_total_length) .. '…'
    end

    return truncated_branch
  end,
  --[[ Truncates and formats Git branch names for display in lualine:
    First segment: Uppercase, truncated to 1 character.
    Middle segments: Lowercase, truncated to 1 character.
    Last segment: Unchanged.
    Separator: › between truncated segments and the last segment.

    Example Input/Output:
		Branch										Name	Output
		backend/setup/tailwind		Bs›tailwind
		feature/add-ui						Fa›add-ui
		main											main
	]]
  fmt = function(branch)
    if branch == '' or branch == nil then
      return 'No Repo'
    end

    -- Function to truncate a segment to a specified length
    local function truncate_segment(segment, max_length)
      if #segment > max_length then
        return segment:sub(1, max_length)
      end
      return segment
    end

    -- Split the branch name by '/'
    local segments = {}
    for segment in branch:gmatch('[^/]+') do
      table.insert(segments, segment)
    end

    -- Truncate all segments except the last one
    for i = 1, #segments - 1 do
      segments[i] = truncate_segment(segments[i], 1) -- Truncate to 1 character
    end

    -- If there's only one segment (no '/'), return it as-is
    if #segments == 1 then
      return segments[1]
    end

    -- Capitalize the first segment and lowercase the rest (except the last one)
    segments[1] = segments[1]:upper() -- First segment uppercase
    for i = 2, #segments - 1 do
      segments[i] = segments[i]:lower() -- Other segments lowercase
    end

    -- Combine the first segments with no separator and add '›' before the last segment
    local truncated_branch = table.concat(segments, '', 1, #segments - 1) .. '›' .. segments[#segments]

    -- Ensure the final result doesn't exceed a maximum length
    local max_total_length = 15
    if #truncated_branch > max_total_length then
      truncated_branch = truncated_branch:sub(1, max_total_length) .. '…'
    end

    return truncated_branch
  end,
,
}

return M
