if not vim.g.neovide then return {} end

local FontScaler = require("util.neovide.FontScaler")

---@class FontConfig
---@field family string Font name
---@field size number Font size
---@field scale? number Font scale factor
---@field linespace? number Line spacing
---@field options? string|table Font options

local M = {
  defaults = {
    linespace = 0,
  },
  state = {
    current_font = nil,
  },
  scaler = FontScaler,
}
-- local default_linespace = 8 -- default 0

vim.api.nvim_echo({ { vim.inspect("Welcome to Neovide version %s", vim.g.neovide_version), "Normal" } }, true, {})

local map = vim.keymap.set
local g = vim.g
local o = vim.opt

-- Font
-- See https://github.com/neovide/neovide/blob/main/website/docs/configuration.md#display
local font_library = {
  monolisa = {
    family = "MonoLisa Nerd Font Mono",
    size = 15,
    scale = 0.9,
    linespace = 12,
    options = {
      "#e-subpixelantialias",
    },
  },
  commitmono = {
    family = "CommitMonoCustom4 Nerd Font",
    size = 15,
    options = "#e-subpixelantialias",
    -- linespace = M.defaults.linespace + 1,
    linespace = 0,
  },
  inputmono = {
    -- family = "InputMono Nerd Font",
    family = "InputMonoCondensedEx Nerd Font",
    size = 18,
  },
  lilex = {
    -- family = "Input Mono Narrow",
    family = "Lilex Nerd Font Mono",
    size = 15,
  },
  firacode = {
    family = "FiraCode Nerd Font",
    size = 16,
  },
  meslo = {
    family = "MesloLGLDZ Nerd Font Mono",
    size = 16,
  },
  berkeley = {
    family = "BerkeleyMono Nerd Font",
    size = 15,
    options = "#e-subpixelantialias",
  },
  geist = {
    family = "GeistMono Nerd Font Mono",
    size = 16,
  },
  hack = {
    family = "Hack Nerd Font Mono",
    size = 15,
  },
  firacode_symbols = {
    family = "Fira Code,Symbols Nerd Font Mono",
    size = 34,
    scale = 0.3,
  },
  cascadia = {
    family = "Cascadia Code Light,MesloLGS NF,Hack Nerd Font",
    size = 15,
  },
  iosevka = {
    family = "Iosevka SS08 Light",
    size = 18,
    options = "#e-subpixelantialias",
  },
  jetbrains = {
    family = "JetBrainsMono Nerd Font",
    size = 14,
    linespace = 0,
  },
  recursive = {
    family = "RecursiveMnCslSt Nerd Font",
    size = 16,
  },
}

-- https://neovide.dev/configuration.html
-- 'vim.o.guifont = "Source Code Pro:h14"' -- text below applies for VimScript
-- Controls the font used by Neovide. Also check the config file to see how to configure features. This is the only setting which is actually controlled through an option, and as such it's also documented in :h guifont. But to sum it up and also add Neovide's extension:
--
-- The basic format is:
-- 'Primary\ Font,Fallback\ Font\ 1,Fallback\ Font\ 2:option1:option2:option3'
--   You can have as many fallback fonts as you want (even 0) and as many options as you want (also even 0).
-- Fonts
--   are separated with , (commas).
--   can contain spaces by either escaping them or using _ (underscores).
-- Options
--   apply to all fonts at once.
--   are separated from the fonts and themselves through : (colons).
--   can be one of the following:
--     hX — Sets the font size to X points, while X can be any (even floating-point) number.
--     wX (available since 0.11.2) — Sets the width relative offset to be X points, while X can be again any number. Negative values shift characters closer together, positive values shift them further apart.
--     b — Sets the font bold.
--     i — Sets the font italic.
--     #e-X (available since 0.10.2) — Sets edge pixels to be drawn opaquely or with partial transparency, while X is a type of edging:
--       antialias (default)
--       subpixelantialias
--       alias
--     #h-X (available since 0.10.2) - Sets level of glyph outline adjustment, while X is a type of hinting:
--       full (default)
--       normal
--       slight
--       none
-- Some examples:
--   Hack,Noto_Color_Emoji:h12:b — Hack at size 12 in bold, with Noto Color Emoji as fallback should Hack fail to contain any glyph.
--   Roboto_Mono_Light:h10 — Roboto Mono Light at size 10.
--   Hack:h14:i:#e-subpixelantialias:#h-none
local function generate_font_options_string(opts)
  if not opts or type(opts) ~= "table" then return "" end

  local options = {}

  -- Handle size option (hX)
  if opts.size then table.insert(options, "h" .. opts.size) end

  -- Handle width offset (wX) - available since 0.11.2
  if opts.width then table.insert(options, "w" .. opts.width) end

  -- Handle bold (b)
  if opts.bold then table.insert(options, "b") end

  -- Handle italic (i)
  if opts.italic then table.insert(options, "i") end

  -- Handle edge pixels (#e-X) - available since 0.10.2
  if opts.edging then table.insert(options, "#e-" .. opts.edging) end

  -- Handle hinting (#h-X) - available since 0.10.2
  if opts.hinting then table.insert(options, "#h-" .. opts.hinting) end

  -- Handle any custom options passed as strings
  if opts.custom then
    if type(opts.custom) == "table" then
      for _, option in ipairs(opts.custom) do
        table.insert(options, option)
      end
    elseif type(opts.custom) == "string" then
      table.insert(options, opts.custom)
    end
  end

  return table.concat(options, ":")
end

local function generate_font_string(font_config)
  return font_config.family .. ":h" .. font_config.size .. generate_font_options_string(font_config.options)
end

--- Set a single font
---@param font_config FontConfig
function M.set_font(font_config)
  vim.o.guifont = generate_font_string(font_config)

  if font_config.scale then g.neovide_scale_factor = font_config.scale end

  if font_config.linespace then
    vim.opt.linespace = font_config.linespace
  else
    vim.opt.linespace = M.defaults.linespace
  end

  -- vim.api.nvim_echo({ { "vim.o.guifont:\n", "Title" }, { vim.inspect(vim.o.guifont), "Normal" } }, true, {})
  vim.notify("Font set to " .. vim.o.guifont, vim.log.levels.INFO)

  M.state.current_font = vim.o.guifont
end

--- Set multiple fonts with fallbacks
---@param font_config FontConfig
---@vararg FontConfig[]
function M.set_fonts(font_config, ...)
  local font_configs = { font_config, unpack(...) }
  local font_string = ""
  for i, config in ipairs(font_configs) do
    font_string = font_string .. (i > 1 and "," or "") .. generate_font_string(config)
  end
end

-- Set default font
-- M.set_font(fonts.jetbrains)
-- M.set_font(font_library.monolisa)
-- M.set_font(font_library.commitmono)
-- M.set_font(fonts.inputmono)
-- M.set_font(fonts.berkeley)
-- M.set_font(fonts.lilex)
-- M.set_font(fonts.recursive)
-- M.set_font2(fonts.BerkeleyMono Nerd Font, 18, "#e-subpixelantialias")

--------------------------------------------------------------------------------

local function set_scale_factor(scale_factor, clamp)
  M.scaler.set(scale_factor, clamp)
end

local function reset_scale_factor()
  M.scaler.reset()
end

local function change_scale_factor(increment, clamp)
  M.scaler.change(increment, clamp)
end
--
-- local opts = { noremap = true, silent = true }
map({ "n" }, "<D-=>", function()
  change_scale_factor(vim.g.neovide_increment_scale_factor * vim.v.count1, true)
end)
map({ "n" }, "<D-->", function()
  change_scale_factor(-vim.g.neovide_increment_scale_factor * vim.v.count1, true)
end)
map({ "n" }, "<D-0>", reset_scale_factor)

-- local function update_scale_factor(delta)
--   M.scaler.multiply(delta)
--   vim.opt.guifont = string.format("%s:h%s", g.gui_font_face, g.gui_font_size)
-- end
-- local scale_increment = 0.05 -- 0.25
-- map("n", "<D-=>", function()
--   update_scale_factor(1 + scale_increment)
-- end)
-- map("n", "<D-->", function()
--   update_scale_factor(1 / (1 + scale_increment))
-- end)
-- map("n", "<D-0>", function()
--   M.scaler.set(1)
-- end)

-- Command definitions
local commands = {
  NeovideSetScaleFactor = {
    function(event)
      local scale_factor, option = tonumber(event.fargs[1]), event.fargs[2]

      if not scale_factor then
        vim.notify(
          "Error: scale factor argument is nil or not a valid number.",
          vim.log.levels.ERROR,
          { title = "Recipe: neovide" }
        )
        return
      end

      set_scale_factor(scale_factor, option ~= "force")
    end,
    nargs = "+",
    desc = "Set Neovide scale factor",
  },
  NeovideResetScaleFactor = {
    reset_scale_factor,
    desc = "Reset Neovide scale factor",
  },
}

-- Register commands
for name, def in pairs(commands) do
  vim.api.nvim_create_user_command(name, def[1], {
    nargs = def.nargs or 0,
    desc = def.desc,
  })
end

o.winblend = 20
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

-- Osx
g.neovide_window_blurred = true
g.neovide_opacity = 0.95
g.neovide_normal_opacity = 0.95
g.neovide_floating_blur_amount_x = 5.0
g.neovide_floating_blur_amount_y = 5.0
-- g.neovide_floating_blur_amount_x = 2.0
-- g.neovide_floating_blur_amount_y = 2.0
g.neovide_floating_shadow = true
g.neovide_floating_z_height = 10

g.experimental_layer_grouping = true

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

g.neovide_cursor_vfx_mode = "pixiedust" -- railgun, torpedo, pixiedust, sonicboom, ripple, wireframe

-- Railgun
-- g.neovide_cursor_vfx_mode = "railgun" -- railgun, torpedo, pixiedust, sonicboom, ripple, wireframe
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
-- g.neovide_background_color = "#0f1117" .. vim.fn.printf("%x", vim.fn.float2nr(255 * g.neovide_opacity))

return M
