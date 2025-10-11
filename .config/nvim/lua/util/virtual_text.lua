local M = {}

M.glassmorphism = {
  virt_text_pos = "overlay",
  hl_mode = "blend",
  format = function(diagnostic)
    return string.format(" ▌%s", diagnostic.message:gsub("\n", " "):sub(1, 50))
  end,
  prefix = function(diagnostic)
    local icons = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    }
    return icons[diagnostic.severity] or " "
  end,
  spacing = 2,
  suffix = " ▐",
}

M.hyprland_floating_card = {
  virt_text_pos = "right_align",
  hl_mode = "combine",
  format = function(diagnostic)
    local msg = diagnostic.message:match("([^\n]*)")
    return string.format("╭─ %s ─╮", msg:sub(1, 40))
  end,
  prefix = function(diagnostic, i, total)
    if i == 1 then return "  " end
    return "  ├─ "
  end,
  suffix = function(diagnostic)
    return " ╰─────╯"
  end,
  spacing = 1,
}

M.osx_big_sur_pill = {
  virt_text_pos = "eol",
  hl_mode = "replace",
  format = function(diagnostic)
    local msg = diagnostic.message:gsub("\n", " "):sub(1, 45)
    return string.format("● %s", msg)
  end,
  prefix = function(diagnostic)
    local prefixes = {
      [vim.diagnostic.severity.ERROR] = "🔴",
      [vim.diagnostic.severity.WARN] = "🟡",
      [vim.diagnostic.severity.INFO] = "🔵",
      [vim.diagnostic.severity.HINT] = "⚪",
    }
    return string.format("%s ", prefixes[diagnostic.severity] or "⚪")
  end,
  spacing = 3,
  current_line = false,
}

M.osx_tahoe_minimalist_zen = {
  virt_text_pos = "inline",
  hl_mode = "blend",
  format = function(diagnostic)
    return diagnostic.message:match("([^\n]*)"):sub(1, 30) .. "…"
  end,
  prefix = function(diagnostic)
    return diagnostic.severity == vim.diagnostic.severity.ERROR and "⚠" or "ℹ"
  end,
  spacing = 4,
  current_line = true, -- Only show on current line
  severity = { min = vim.diagnostic.severity.WARN }, -- Hide hints
}

M.osx_liquid_glass_neon = {
  virt_text_pos = "eol_right_align",
  hl_mode = "combine",
  format = function(diagnostic)
    local msg = diagnostic.message:gsub("\n", " ")
    return string.format("▓▒░ %s ░▒▓", msg:sub(1, 35))
  end,
  prefix = function(diagnostic, i, total)
    local symbols = { "◆", "◇", "◈", "◉" }
    return symbols[diagnostic.severity] .. " "
  end,
  spacing = 2,
  suffix = " ▓▒░",
}

M.context_aware = function(namespace, bufnr)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local is_small_file = line_count < 100

  return {
    virt_text_pos = is_small_file and "eol" or "overlay",
    hl_mode = "blend",
    format = function(diagnostic)
      local max_len = is_small_file and 60 or 30
      return diagnostic.message:sub(1, max_len) .. (diagnostic.message:len() > max_len and "..." or "")
    end,
    prefix = function(diagnostic)
      local icons = { "❌", "⚠️", "ℹ️", "💡" }
      return icons[diagnostic.severity] .. " "
    end,
    current_line = not is_small_file,
    spacing = is_small_file and 4 or 1,
  }
end

M.terminal_retro_ascii = {
  virt_text_pos = "eol",
  format = function(diagnostic)
    return string.format("[%s]", diagnostic.message:match("([^\n]*)"):sub(1, 40))
  end,
  prefix = function(diagnostic, i, total)
    local chars = {
      [vim.diagnostic.severity.ERROR] = ">>",
      [vim.diagnostic.severity.WARN] = ">>",
      [vim.diagnostic.severity.INFO] = "->",
      [vim.diagnostic.severity.HINT] = "..",
    }
    return string.format("%s ", chars[diagnostic.severity] or "->")
  end,
  suffix = function(diagnostic)
    return total > 1 and string.format(" (%d more)", total - 1) or ""
  end,
  spacing = 2,
}

M.ultra_minimal_dots = {
  virt_text_pos = "eol",
  hl_mode = "replace",
  format = function()
    return ""
  end, -- No message text
  prefix = function(diagnostic, i, total)
    local dots = string.rep("●", math.min(total, 5))
    return dots .. " "
  end,
  current_line = true,
  severity = { min = vim.diagnostic.severity.WARN },
}
return M
