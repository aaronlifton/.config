--[[
  To select items and put them in quickfix with :MiniPick:
  - Search for whatever you want to select
  - When you have the list of items press <C-a> (Ctrl + a) to select all
  - Then press <M-CR> (Alt + Enter) to put them in quickfix
  To select items from multiple subsequent searches:
  - Search for whatever you want to select
  - When you have the list of items press <C-a> (Ctrl + a) to select all
  - Perform your next search
  - When you have the list of items press <C-a> (Ctrl + a) to select all
  - When you're done selecting all the items across searches press <M-CR>
  (Alt + Enter) to put them in quickfix

  For more info check this: https://github.com/nvim-mini/mini.nvim/discussions/1853
]]

-- Custom MiniPick Buffers sorted by recency and with the ability to wipe out
-- the selected buffer by pressing <C-d> (Ctrl + d)
-- It will also not show the current buffer in the list.
local function custom_mini_pick_buffers(MiniPick)
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end

  -- Custom picker for buffers to sort them by last used
  local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }
  MiniPick.registry.my_buffers = function()
    local items, cwd = {}, vim.fn.getcwd()
    for _, buf_info in ipairs(vim.fn.getbufinfo()) do
      if buf_info.listed == 1 and buf_info.bufnr ~= vim.api.nvim_get_current_buf() then
        local name = vim.fs.relpath(cwd, buf_info.name) or buf_info.name
        table.insert(items, {
          text = name,
          bufnr = buf_info.bufnr,
          _lastused = buf_info.lastused,
        })
      end
    end

    table.sort(items, function(a, b)
      return a._lastused > b._lastused
    end)

    local show = function(buf_id, items_to_show, query)
      MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
    end

    local opts = {
      source = { name = "Buffers", items = items, show = show },
      mappings = buffer_mappings,
    }
    return MiniPick.start(opts)
  end
end

return {
  {
    "nvim-mini/mini.pick",
    optional = true,
    config = function()
      local MiniPick = require("mini.pick")
      local choose_all = function()
        local mappings = MiniPick.get_picker_opts().mappings
        vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
      end
      MiniPick.setup({
        mappings = {
          choose_all = { char = "<c-q>", func = choose_all },
          sys_paste = {
            char = "<d-v>",
            func = function()
              MiniPick.set_picker_query({ vim.fn.getreg("+") })
            end,
          },
          caret_left = "<Left>",
          caret_right = "<Right>",

          choose = "<CR>",
          choose_in_split = "<C-s>",
          choose_in_tabpage = "<C-t>",
          choose_in_vsplit = "<C-v>",
          choose_marked = "<M-CR>",

          delete_char = "<BS>",
          delete_char_right = "<Del>",
          -- delete_left = "<C-u>",
          delete_left = "<M-u>",
          delete_word = "<C-w>",

          mark = "<C-x>",
          mark_all = "<C-a>",

          move_down = "<C-n>",
          move_start = "<C-g>",
          move_up = "<C-p>",

          paste = "<C-r>",

          refine = "<C-Space>",
          refine_marked = "<M-Space>",

          -- scroll_down = "<C-f>",
          scroll_down = "<C-d>",
          scroll_left = "<C-h>",
          scroll_right = "<C-l>",
          -- scroll_up = "<C-b>",
          scroll_up = "<C-u>",

          stop = "<Esc>",

          toggle_info = "<S-Tab>",
          toggle_preview = "<Tab>",
        },
      })

      -- vim.ui.select = MiniPick.select
      custom_mini_pick_buffers(MiniPick)
      --
      vim.api.nvim_create_augroup("MiniPick", { clear = true })
    end,
    keys = {
      --stylua: ignore start
      { "<d-p>", function() require("mini.pick").builtin.files() end, desc = "files" },
      { "<D-P>", function() require("mini.pick").builtin.files({ source = { cwd  = Snacks.git.get_root() } }) end, desc = "files" },
      { "<leader>,", ":Pick my_buffers", desc = "Buffers (recent)" },
      -- { "<leader>Pb", function() MiniExtra.pickers.buf_lines() end, desc = "Buffer lines" },
      -- { "<leader>Pf", function() MiniExtra.pickers.explorer() end, desc = "Explorer" },
      -- { "<leader>PF", function() MiniExtra.pickers.git_files({ scope = "modified" }) end, desc = "Git files" },
      -- { "<leader>Pg", function() MiniExtra.pickers.git_branches() end, desc = "Git branches" },
      -- { "<leader>PG", function() MiniExtra.pickers.git_commits() end, desc = "Git commits" },
      -- { "<leader>Ph", function() MiniExtra.pickers.git_hunks() end, desc = "Git hunks" },
      -- { "<leader>PH", function() MiniExtra.pickers.hipatterns() end, desc = "Hitpatterns" },
      -- { "<leader>Pr", function() MiniExtra.pickers.registers() end, desc = "Registers" },
      -- { "<leader>Pu", function() MiniExtra.pickers.history() end, desc = "History" },
      -- { "<leader>Pg", function() MiniExtra.pickers.hl_groups() end, desc = "Hl groups" },
      -- { "<leader>Pk", function() MiniExtra.pickers.keymaps() end, desc = "Keymaps" },
      -- { "<leader>Pl", function() MiniExtra.pickers.list() end, desc = "List" },
      -- -- Needs an explicit scope from a list of supported ones:
      -- -- "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol"
      -- { "<leader>PL", function() MiniExtra.pickers.lsp("declaration") end, desc = "LSP" },
      -- { "<leader>Pm", function() MiniExtra.pickers.marks() end, desc = "Marks" },
      -- { "<leader>Pb", function() MiniExtra.pickers.oldfiles() end, desc = "Buffers" },
      -- { "<leader>Pc", function() MiniExtra.pickers.commands() end, desc = "Commands" },
      -- { "<leader>Ph", function() MiniExtra.pickers.help_tags() end, desc = "Help" },
      -- { "<leader>Pv", function() MiniExtra.pickers.options() end, desc = "Vim options" },
      -- { "<leader>Pt", function() MiniExtra.pickers.treesitter() end, desc = "Treesitter nodes" },
      -- { "<leader>Pv", function() MiniExtra.pickers.visit_paths() end, desc = "Visit paths" },
      -- { "<leader>PV", function() MiniExtra.pickers.visit_labels() end, desc = "Visit labels" },
      -- { "<leader>Pd", function() MiniExtra.pickers.diagnostic() end, desc = "Diagnostics" },
      --stylua: ignore end
    },
  },
}
