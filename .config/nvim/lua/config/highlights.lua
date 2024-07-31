local M = {}
local theme = vim.g.colors_name

M.setup = function()
  if theme == "tokyonight-moon" then
    local c = require("tokyonight.colors").styles["moon"]
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = c.bg })
    -- Lightspeed-style Leap highlighting https://github.com/ggandor/leap.nvim?tab=readme-ov-file#extending-leap
    -- vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) -- or some grey
    -- vim.api.nvim_set_hl(0, "LeapMatch", {
    --   -- For light themes, set to 'black' or similar.
    --   fg = "white",
    --   bold = true,
    --   nocombine = true,
    -- })
  elseif theme == "cyberdream" then
    local U = require("util.colors")
    local C = require("cyberdream.colors")
    local t = C.default
    -- vim.api.nvim_set_hl(0, "LeapLabelPrimary", {
    --   fg = "#ffffff",
    --   bg = U.darken(t.blue, 0.3),
    --   bold = true,
    -- })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = U.darken(t.bgAlt, 0.79) })
  end
end

return M

-- REFERENCE
-- Tokyonight - moon colors
-- {
--   day = <1>{
--     bg = "#1a1b26",
--     bg_dark = "#16161e"
--   },
--   default = {
--     bg = "#24283b",
--     bg_dark = "#1f2335",
--     bg_highlight = "#292e42",
--     blue = "#7aa2f7",
--     blue0 = "#3d59a1",
--     blue1 = "#2ac3de",
--     blue2 = "#0db9d7",
--     blue5 = "#89ddff",
--     blue6 = "#b4f9f8",
--     blue7 = "#394b70",
--     comment = "#565f89",
--     cyan = "#7dcfff",
--     dark3 = "#545c7e",
--     dark5 = "#737aa2",
--     fg = "#c0caf5",
--     fg_dark = "#a9b1d6",
--     fg_gutter = "#3b4261",
--     git = {
--       add = "#449dab",
--       change = "#6183bb",
--       delete = "#914c54"
--     },
--     gitSigns = {
--       add = "#266d6a",
--       change = "#536c9e",
--       delete = "#b2555b"
--     },
--     green = "#9ece6a",
--     green1 = "#73daca",
--     green2 = "#41a6b5",
--     magenta = "#bb9af7",
--     magenta2 = "#ff007c",
--     none = "NONE",
--     orange = "#ff9e64",
--     purple = "#9d7cd8",
--     red = "#f7768e",
--     red1 = "#db4b4b",
--     teal = "#1abc9c",
--     terminal_black = "#414868",
--     yellow = "#e0af68"
--   },
--   moon = <function 1>,
--   night = <table 1>,
--   setup = <function 2>
-- }
