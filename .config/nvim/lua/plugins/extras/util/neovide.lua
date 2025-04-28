if not vim.g.neovide then return {} end

local map = vim.keymap.set
local g = vim.g

local state = {
  current_font = nil,
}
local default_linespace = 8 -- default 0

-- Font
-- See https://github.com/neovide/neovide/blob/main/website/docs/configuration.md#display
local fonts = {
  firacode = {
    face = "FiraCode Nerd Font",
    size = 16,
  },
  meslo = {
    face = "MesloLGLDZ Nerd Font Mono",
    size = 16,
  },
  berkeley = {
    face = "Berkeley Mono Trial",
    size = 16,
  },
  monolisa = {
    face = "MonoLisa Nerd Font Mono",
    size = 15,
    scale = 0.9,
    linespace = 12,
  },
  geist = {
    face = "GeistMono Nerd Font Mono",
    size = 16,
  },
  hack = {
    face = "Hack Nerd Font Mono",
    size = 15,
  },
  firacode_symbols = {
    face = "Fira Code,Symbols Nerd Font Mono",
    size = 34,
    scale = 0.3,
  },
  cascadia = {
    face = "Cascadia Code Light,MesloLGS NF,Hack Nerd Font",
    size = 15,
  },
  iosevka = {
    face = "Iosevka SS08 Light",
    size = 18,
    options = "#e-subpixelantialias",
  },
  jetbrains = {
    face = "JetBrainsMono Nerd Font",
    size = 14,
    linespace = 0,
  },
}

local function set_font(name)
  local font = fonts[name:lower()]
  if not font then
    vim.notify("Font " .. name .. " not found", vim.log.levels.ERROR)
    return
  end

  g.gui_font_face = font.face
  g.gui_font_size = font.size
  vim.o.guifont = font.face .. ":h" .. font.size .. (font.options or "")
  if font.scale then g.neovide_scale_factor = font.scale end

  if font.linespace then
    vim.opt.linespace = font.linespace
  else
    vim.opt.linespace = default_linespace
  end

  state.current_font = name
end

-- Set default font
-- set_font("jetbrains")
set_font("monolisa")

vim.opt.winblend = 20

--------------------------------------------------------------------------------

RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s", g.gui_font_face, g.gui_font_size)
  -- SetGuiFont(g.gui_font_face, g.gui_font_size)
end

ResizeGuiFont = function(delta)
  g.gui_font_size = g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function()
  vim.g.gui_font_size = fonts[state.current_font].size
  RefreshGuiFont()
end

local opts = { noremap = true, silent = true }
map({ "n", "i" }, "<C-=>", function()
  ResizeGuiFont(1)
end, opts)
map({ "n", "i" }, "<C-->", function()
  ResizeGuiFont(-1)
end, opts)
map({ "n", "i" }, "<C-0>", function()
  ResetGuiFont()
end, opts)

local function update_scale_factor(delta)
  g.neovide_scale_factor = g.neovide_scale_factor * delta
  RefreshGuiFont()
end
local function set_scale_factor(factor)
  g.neovide_scale_factor = factor
  RefreshGuiFont()
end

local scale_increment = 0.05 -- 0.25
map("n", "<D-=>", function()
  update_scale_factor(1 + scale_increment)
end)
map("n", "<D-->", function()
  update_scale_factor(1 / (1 + scale_increment))
end)
map("n", "<D-0>", function()
  set_scale_factor(1)
end)

g.neovide_theme = "dark" -- "auto"
g.neovide_hide_mouse_when_typing = true
g.neovide_fullscreen = false

-- Keys
g.neovide_input_use_logo = true
g.neovide_input_macos_option_key_is_meta = "only_left" -- "both"

-- Options
g.neovide_padding_top = 5
g.neovide_padding_right = 5
g.neovide_padding_left = 5
g.neovide_padding_bottom = 0

g.neovide_window_blurred = true
g.neovide_floating_blur_amount_x = 5.0
g.neovide_floating_blur_amount_y = 5.0
-- g.neovide_floating_blur_amount_x = 2.0
-- g.neovide_floating_blur_amount_y = 2.0
g.neovide_floating_shadow = true
g.neovide_floating_z_height = 10

-- g.neovide_light_angle_degrees = 45
-- g.neovide_light_angle_degrees = 45
-- g.neovide_light_radius = 5

-- g.neovide_cursor_antialiasing = false
g.neovide_cursor_animation_length = 0.04 -- Default 0.06
g.neovide_scroll_animation_length = 0.2
g.neovide_cursor_trail_length = 0.01
g.neovide_cursor_antialiasing = true
g.neovide_cursor_animate_in_insert_mode = true
-- g.neovide_cursor_animation_length = 0.02 -- Default 0.06
-- g.neovide_cursor_animation_length = 0.13
-- g.neovide_cursor_trail_size = 0.8
-- g.neovide_cursor_unfocused_outline_width = 0.125
-- g.neovide_cursor_animate_in_normal_mode = true
-- g.neovide_cursor_animate_in_visual_mode = true
-- g.neovide_cursor_animate_in_replace_mode = true
-- g.neovide_cursor_animate_in_command_mode = true

-- g.neovide_cursor_vfx_mode = "pixiedust" -- railgun, torpedo, pixiedust, sonicboom, ripple, wireframe

-- Railgun
g.neovide_cursor_vfx_mode = "railgun" -- railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
g.neovide_cursor_vfx_particle_phase = 1.5 -- railgun
g.neovide_cursor_vfx_particle_curl = 1.0 -- railgun

g.neovide_cursor_vfx_opacity = 195.0 -- 200.0
g.neovide_cursor_vfx_particle_speed = 30.0 -- 10.0
g.neovide_cursor_vfx_particle_lifetime = 0.3 -- 0.5 (railgun, torpedo, pixiedust)
-- g.neovide_cursor_vfx_particle_highlight_lifetime = 0.2 -- 0.2 (sonicboom, ripple, wireframe)
g.neovide_cursor_vfx_particle_density = 1.0 -- 0.7

-- Railgun easing
local Easing = require("util.neovide.Easing")
Easing.bezier()
local bezier = Easing.new("bezier")
local configs = bezier:generateConfigs(5)
bezier:setConfig(configs[1])

-- This setting is only effective when not using vsync, for example by passing --no-vsync on the commandline.
g.neovide_refresh_rate = 60 -- StudioDisplay @ 60Hz
-- g.neovide_refresh_rate = 120 -- StudioDisplay @ ProMotion (120hz) (Not released yet, rumored for 2025)
g.neovide_show_border = true
g.neovide_remember_window_size = true

local gamma = {
  default = { 0.0, 0.5 },
  alacritty = { 0.8, 0.1 },
  kitty_osx = { 1.7, 30.0 },
  kitty = { 1.0, 0.0 },
}
local function set_gamma(name)
  local g = gamma[name:lower()]
  if not g then
    vim.notify("Gamma " .. name .. " not found", vim.log.levels.ERROR)
    return
  end
  g.neovide_text_gamma = g[1]
  g.neovide_text_contrast = g[2]
end

-- set_gamma("alacritty")
set_gamma("kitty_osx")

-- https://neovide.dev/faq.html#how-can-i-use-cmd-ccmd-v-to-copy-and-paste
-- if g.neovide then
--   vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
--   vim.keymap.set("v", "<D-c>", '"+y') -- Copy
--   vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
--   vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
--   vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
--   vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
--   vim.keymap.set({ "v", "t" }, "<D-v>", '"+P', { noremap = true })
-- end

-- Allow clipboard copy paste in neovim
-- vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
-- -- so as to nto interfere with fzf <C-r> mapping in fish
-- vim.api.nvim_set_keymap("t", "<D-v>", '"+P', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- https://github.com/neovide/neovide/issues/1263#issuecomment-1972013043
vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<D-v>", function()
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end, { noremap = true, silent = true })

-- map("i", "<C-S-v>", '<ESC>l"+Pli') -- Paste insert mode
-- KEYS
-- map("n", "æ", "<A-a>", symbol_key_opts)
-- local map = map
-- local symbol_key_opts = { desc = "which_key_ignore" }

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

-- g.neovide_transparency = 0.0
-- g.transparency = 0.95
-- g.neovide_background_color = '#0f1117' .. vim.fn.printf('%x', vim.fn.float2nr(255 * g.transparency))

return {}
