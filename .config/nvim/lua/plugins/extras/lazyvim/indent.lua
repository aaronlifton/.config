return {}
-- return {
-- -- indent guides for Neovim
-- {
--
--   "lukas-reineke/indent-blankline.nvim",
--     optional = true,
--   event = "LazyFile",
--   opts = {
--     -- scope = { enabled = false },
--     exclude = {
--       filetypes = {
--         "help",
--         "alpha",
--         "dashboard",
--         "neo-tree",
--         "Trouble",
--         "trouble",
--         "lazy",
--         "mason",
--         "notify",
--         "toggleterm",
--         "lazyterm",
--       },
--     },
--   },
-- },
-- {
--     "echasnovski/mini.indentscope",
--     optional = true,
--     init = function()
--       vim.api.nvim_create_autocmd("FileType", {
--         pattern = {
--           "help",
--           "alpha",
--           "dashboard",
--           "neo-tree",
--           "Trouble",
--           "trouble",
--           "lazy",
--           "mason",
--           "notify",
--           "toggleterm",
--           "lazyterm",
--         },
--         callback = function()
--           vim.b.miniindentscope_disable = true
--         end,
--       })
--     end,
--   }
-- }
