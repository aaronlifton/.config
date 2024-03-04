local hi_words = require("mini.extra").gen_highlighter.words
return {
  {
    "echasnovski/mini.hipatterns",
    opts = {
      highlighters = {
        todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
        { pattern = "%f[%s]%s*$", group = "Error" },
      },
    },
  },
}

-- default lazy tailwind highlights
--
-- opts.highlighters.tailwind = {
--   pattern = function()
--     if not vim.tbl_contains(opts.tailwind.ft, vim.bo.filetype) then
--       return
--     end
--     if opts.tailwind.style == "full" then
--       return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
--     elseif opts.tailwind.style == "compact" then
--       return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
--     end
--   end,
--   group = function(_, _, m)
--     ---@type string
--     local match = m.full_match
--     ---@type string, number
--     local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
--     shade = tonumber(shade)
--     local bg = vim.tbl_get(M.colors, color, shade)
--     if bg then
--       local hl = "MiniHipatternsTailwind" .. color .. shade
--       if not M.hl[hl] then
--         M.hl[hl] = true
--         local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
--         local fg = vim.tbl_get(M.colors, color, bg_shade)
--         vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
--       end
--       return hl
--     end
--   end,
--   extmark_opts = { priority = 2000 },
-- }
--
