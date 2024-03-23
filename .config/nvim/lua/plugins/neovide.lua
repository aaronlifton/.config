if not vim.g.neovide then
  return {}
end

-- vim.g.gui_font_face = "FiraCode Nerd Font"
-- vim.g.gui_font_face = "MesloLGLDZ Nerd Font Mono"
RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

-- Keymaps
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i" }, "<C-S-+>", function()
  ResizeGuiFont(1)
end, opts)
vim.keymap.set({ "n", "i" }, "<C-->", function()
  ResizeGuiFont(-1)
end, opts)

-- Options
vim.g.neovide_padding_top = 5
vim.g.neovide_padding_right = 5
vim.g.neovide_padding_left = 5

vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 5.0
vim.g.neovide_floating_blur_amount_y = 5.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10

vim.g.neovide_cursor_antialiasing = false

vim.g.neovide_cursor_vfx_mode = "pixiedust" -- railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_cursor_vfx_opacity = 195.0
-- vim.g.neovide_cursor_vfx_particle_density = 7.0
-- vim.g.neovide_cursor_vfx_particle_speed = 10.0
-- vim.g.neovide_cursor_vfx_particle_phase = 1.5 -- railgun
-- vim.g.neovide_cursor_vfx_particle_cur7l = 1.0 -- railgun

vim.o.guifont = "Hack Nerd Font Mono:h15"
-- vim.o.guifont = "Berkeley Mono Trial:h16"
vim.o.guifont = "GeistMono Nerd Font Mono:h16"

vim.opt.winblend = 20
-- vim.g.neovide_refresh_rate = 75
vim.g.neovide_show_border = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_scroll_animation_length = 0.2

-- keys
vim.g.neovide_input_macos_alt_is_meta = true

-- vim.g.neovide_cursor_animation_length = 0.13
-- vim.g.neovide_cursor_trail_size = 0.8
-- vim.g.neovide_cursor_animate_in_insert_mode = true
-- vim.g.neovide_cursor_animate_command_line = true
-- vim.g.neovide_cursor_unfocused_outline_width = 0.125

-- keys
-- map("n", "æ", "<A-a>", symbol_key_opts)
local map = require("util").keymap.map
local symbol_key_opts = { desc = "which_key_ignore" }

-- map("n", "Ω", "<A-z>", symbol_key_opts)
-- -- map("n", "ê", "<A-e>", symbol_key_opts)
-- -- map("n", "®", "<A-r>", symbol_key_opts)
-- -- map("n", "†", "<A-t>", symbol_key_opts)
-- map("n", "¥", "<A-y>", symbol_key_opts)
-- map("n", "¨", "<A-u>", symbol_key_opts)
-- map("n", "ˆ", "<A-i>", symbol_key_opts)
-- map("n", "ø", "<A-o>", symbol_key_opts)
-- -- map("n", "π", "<A-p>", symbol_key_opts)
-- map("n", "œ", "<A-q>", symbol_key_opts)
-- map("n", "ß", "<A-s>", symbol_key_opts)
-- map("n", "∂", "<A-d>", symbol_key_opts)
-- -- map("n", "ƒ", "<A-f>", symbol_key_opts)
-- -- map("n", "ﬁ", "<A-g>", symbol_key_opts)
-- -- map("n", "µ", "<A-m>", symbol_key_opts)
-- -- map("n", "∑", "<A-w>", symbol_key_opts)
-- map("n", "≈", "<A-x>", symbol_key_opts)
-- map("n", "ç", "<A-c>", symbol_key_opts)
-- map("n", "√", "<A-v>", symbol_key_opts)
-- map("n", "∫", "<A-b>", symbol_key_opts)
-- -- map("n", "˜", "<A-n>") -- don't want to remap this one

return {}
