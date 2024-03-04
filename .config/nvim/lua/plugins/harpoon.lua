local keys = {}

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { "<leader>h" .. i, function() require("harpoon"):list():select(i) end, desc = "File " .. i })
end

-- ThePrimeagen - <leader>a
-- table.insert(keys, {"<leader>a", function() harpoon:list():append() end, desc = "Add Mark"})
table.insert(keys, { "<leader>ha", function() require("harpoon"):list():append() end, desc = "Add Mark" })
-- primeagen - <C-e>
-- table.insert(keys, { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Menu" })
table.insert(keys,
  { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Menu" })
-- idea: <C-S-e>
table.insert(keys, { "<leader>hf", "<cmd>Telescope harpoon marks<CR>", desc = "Files (Telescope)" })
table.insert(keys, { "<leader>hc", function() require("harpoon"):list():clear() end, desc = "Clear all Files" })

table.insert(keys, { "<A-[>", function() require("harpoon"):list():prev() end, desc = "Harpoon->Prev" })
table.insert(keys, { "<A-]>", function() require("harpoon"):list():next() end, desc = "Harpoon->Next" })

-- idea: <C-S-P>
table.insert(keys, { "<C-A-h>", function() require("harpoon"):list():prev() end, desc = "Harpoon->Prev" })
-- idea: <C-S-N>
table.insert(keys, { "<C-A-l>", function() require("harpoon"):list():next() end, desc = "Harpoon->Next" })

-- ThePrimeagen dvorak layout (htns) maps to hjkl
-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
--
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
-- local shortcuts = {
--       {
--         "<C-h>",
--         function()
--           require("harpoon"):list():select(1)
--         end,
--         "Harpoon->1",
--       },
--       {
--         "<C-j>",
--         function()
--           require("harpoon"):list():select(2)
--         end,
--         "Harpoon->2",
--       },
--       {
--         "<C-k>",
--         function()
--           require("harpoon"):list():select(3)
--         end,
--         "Harpoon->3",
--       },
--       {
--         "<C-l>",
--         function()
--           require("harpoon"):list():select(4)
--         end,
--         "Harpoon->4",
--       }
-- }
-- for _, shortcut in ipairs(shortcuts) do
--   table.insert(keys, shortcut)
-- end
--

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    keys = keys,

    config = function(_)
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      })

      -- harpoon:extend(extensions.builtins.navigate_with_number())
      harpoon:extend({
        UI_CREATE = function(cx)
          local choices = { "y", "u", "i", "o", "p", "h", "j", "k", "l" }
          for i = 1, 9 do
            vim.keymap.set("n", "<leader>h" .. choices[i], function()
              harpoon:list():select(i)
            end, { desc = "File " .. i, buffer = cx.bufnr })
          end
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })

      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").load_extension("harpoon")
      end)
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      local harpoon = {
        action = "Telescope harpoon marks",
        desc = " Harpoon",
        icon = "󱌧 ",
        key = "h",
      }

      harpoon.desc = harpoon.desc .. string.rep(" ", 43 - #harpoon.desc)
      harpoon.key_format = "  %s"

      table.insert(opts.config.center, 5, harpoon)
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>h"] = { name = "󱌧 harpoon" },
      },
    },
  },
}

-- REQUIRED
-- vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
-- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-[>", function()
--   harpoon:list():prev()
-- end)
-- vim.keymap.set("n", "<C-]>", function()
--   harpoon:list():next()
-- end)

-- basic telescope configuration
-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--
--   require("telescope.pickers")
--     .new({}, {
--       prompt_title = "Harpoon",
--       finder = require("telescope.finders").new_table({
--         results = file_paths,
--       }),
--       previewer = conf.file_previewer({}),
--       sorter = conf.generic_sorter({}),
--     })
--     :find()
-- end
-- vim.keymap.set("n", "<C-e>", function()
--   toggle_telescope(harpoon:list())
-- end, { desc = "Open harpoon window" })

--   local conf = require("telescope.config").values
--   local function toggle_telescope(harpoon_files)
--     local file_paths = {}
--     for _, item in ipairs(harpoon_files.items) do
--       table.insert(file_paths, item.value)
--     end
--
--     require("telescope.pickers")
--       .new({}, {
--         prompt_title = "Harpoon",
--         finder = require("telescope.finders").new_table({
--           results = file_paths,
--         }),
--         previewer = conf.file_previewer({}),
--         sorter = conf.generic_sorter({}),
--         attach_mappings = function(_, map)
--           actions.select_default:replace(execute_macro)
--           map({ "i", "n" }, "<C-e>", function() harpoon)
--           map({ "i", "n" }, "<C-t>", append_comment)
--           map({ "i", "n" }, "<C-k>", clear_macro)
--           map({ "i", "n" }, "<C-a>", clear_all_macros)
--           map({ "i", "n" }, "<C-d>", delete_macro)
--           map({ "i", "n" }, "<C-r>", delete_all_macros)
--           return true
--         end,
--       })
--       :find()
--   end
