-- local win = require("telescope.actions.state").get_current_picker(prompt_bufnr).preview_win
-- local win = require("telescope.actions.state").get_current_picker(prompt_bufnr).preview_win
-- local win = require("telescope.actions.state").get_current_picker(prompt_bufnr).preview_win
-- local win = require("telescope.actions.state").get_current_picker(prompt_bufnr).preview_win
local Util = require("lazyvim.util")
local actions = require("telescope.actions")
local custom_finders = require("config.user.telescope_custom_finders")

-- Function to open preview file in main editor
local function open_preview_file(prompt_bufnr)
  local actions_state = require("telescope.actions.state")
  local entry = actions_state.get_selected_entry()
  actions.close(prompt_bufnr)
  vim.cmd("edit " .. entry.value)
end

local function get_telescope_targets(prompt_bufnr)
  local pick = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local scroller = require("telescope.pickers.scroller")

  local wininfo = vim.fn.getwininfo(pick.results_win)

  local first =
    math.max(scroller.top(pick.sorting_strategy, pick.max_results, pick.manager:num_results()), wininfo[1].topline - 1)
  local last = wininfo[1].botline - 1

  local targets = {}
  for row = last, first, -1 do
    local target = {
      wininfo = wininfo[1],
      pos = { row + 1, 1 },
      row = row,
      pick = pick,
    }
    table.insert(targets, target)
  end
  return targets
end

-- local function goto_file_selection(prompt_bufnr, command)
--   local pick = require("telescope.actions.state").get_current_picker(prompt_bufnr)
--   local results = require("telescope.actions.state").get_selected_entry()

--   if not entry then
--     print("[telescope] Nothing currently selected")
--     return
--   else
--   end
--   -- prompt_win = vim.api.nvim_get_current_win()
--   local wininfo = vim.fn.getwininfo(pick.results_win)
--   local preview_win = state.get_status(prompt_bufnr).preview_win
--   if preview_win then
--     vim.api.nvim_win_set_config(preview_win, { style = "" })
--   end
--
--   local original_win_id = picker.original_win_id or 0
--   local entry_bufnr = entry.bufnr
--
--   local bufnr = vim.api.nvim_get_current_buf()
--   if filename ~= vim.api.nvim_buf_get_name(bufnr) then
--     vim.cmd(string.format(":%s %s", command, filename))
--     vim.api.nvim_buf_set_option(bufnr, "buflisted", true)
--   end
--   -- TODO: why is ThePrimeagen using a pcall?
--   vim.api.nvim_win_set_cursor(wininfo[1].winid, { results.lnum, results.col })
-- end

-- local entry: {
--     bufnr: unknown,
--     col: unknown,
--     display: unknown,
--     filename: unknown,
--     lnum: unknown,
--     path: unknown,
--     row: unknown,
--     value: unknown,
-- }
-- https://github.com/ThePrimeagen/telescope.nvim/blob/dd0520eb194d323e47b8cb525b703f54bcd56e80/lua/telescope/actions.lua#L48
local function goto_file_selection(prompt_bufnr, command)
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local telescope_state = require("telescope.state")
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local entry = actions_state.get_selected_entry(prompt_bufnr)

  if not entry then
    print("[telescope] Nothing currently selected")
    return
  else
    local filename, row, col
    if entry.filename then
      filename = entry.path or entry.filename

      -- TODO: Check for off-by-one
      row = entry.row or entry.lnum
      col = entry.col
    else
      -- TODO: Might want to remove this and force people
      -- to put stuff into `filename`
      local value = entry.value
      if not value then
        print("Could not do anything with blank line...")
        return
      end

      if type(value) == "table" then
        value = entry.display
      end

      local sections = vim.split(value, ":")

      filename = sections[1]
      row = tonumber(sections[2])
      col = tonumber(sections[3])
    end

    local preview_win = telescope_state.get_status(prompt_bufnr).preview_win
    if preview_win then
      vim.api.nvim_win_set_config(preview_win, { style = "" })
    end

    local original_win_id = picker.original_win_id or 0
    local entry_bufnr = entry.bufnr

    actions.close(prompt_bufnr)

    -- TODO: Sometimes we open something with missing line numbers and stuff...
    if entry_bufnr then
      if command == "e" then
        vim.api.nvim_win_set_buf(original_win_id, entry_bufnr)
        vim.api.nvim_command("doautocmd filetypedetect BufRead " .. vim.fn.fnameescape(filename))
      else
        vim.cmd(string.format(":%s #%d", command, entry_bufnr))
      end
    else
      local bufnr = vim.api.nvim_get_current_buf()
      if filename ~= vim.api.nvim_buf_get_name(bufnr) then
        vim.cmd(string.format(":%s %s", command, filename))
        vim.api.nvim_buf_set_option(bufnr, "buflisted", true)
      end

      if row and col then
        local ok, err_msg = pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
        if not ok then
          -- log.debug("Failed to move to cursor:", err_msg)
          vim.cmd(string.format("echo 'Failed to move to cursor: :%s'", err_msg))
        end
      end
    end
  end
end

local function yank_preview_buffer(prompt_bufnr)
  -- local prompt_bufnr = vim.api.nvim_get_current_buf()
  local actions_state = require("telescope.actions.state")
  local action_utils = require("telescope.actions.utils")
  local preview_win = telescope_state.get_status(prompt_bufnr).preview_win
  local preview_buf = action_utils.get_current_buffer_data(preview_win)
  -- local current_picker = actions_state.get_current_picker(prompt_bufnr)
  -- local preview_bufnr = actions_state.get_current_preview_buffer(current_picker.previewer)
  local lines = vim.api.nvim_buf_get_lines(preview_bufnr, 0, -1, false)
  vim.fn.setreg("0", lines)
end

local function send_to_qflist(prompt_bufnr)
  -- local actions_state = require("telescope.actions.state")
  -- local action_utils = require("telescope.actions.utils")
  -- local picker = actions_state.get_current_picker(prompt_bufnr)
  -- local preview_buf = action_utils.get_current_buffer_data(picker.previewer)
  -- local lines = vim.api.nvim_buf_get_lines(preview_buf, 0, -1, false)
  local action_state = require("telescope.actions.state")
  local action_utils = require("telescope.actions.utils")
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local results = {}
  action_utils.map_entries(prompt_bufnr, function(entry, index, row)
    results[row] = entry.value
  end)
  vim.fn.setqflist({}, "a", { title = "Preview", lines = results })
end

return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = not vim.g.vscode,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- build = "make",
      config = function()
        Util.on_load("telescope.nvim", function()
          local telescope = require("telescope")

          telescope.load_extension("fzf")
          if vim.g.outline_plugin == "aerieal" then
            telescope.load_extension("aerial")
          end
          telescope.load_extension("bookmarks")
          telescope.load_extension("possession")
          telescope.load_extension("yank_history")
          -- telescope.load_extension("harpoon")
        end)
      end,
    },
    keys = {
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>sA",
        Util.telescope("treesitter"),
        desc = "Treesitter Symbols",
      },
      {
        "<leader>ssa",
        Util.telescope("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
            "Enum",
            "Constant",
          },
        }),
        desc = "All",
      },
      { "<leader>ssc", Util.telescope("lsp_document_symbols", { symbols = { "Class" } }), desc = "Class" },
      { "<leader>ssf", Util.telescope("lsp_document_symbols", { symbols = { "Function" } }), desc = "Function" },
      { "<leader>ssm", Util.telescope("lsp_document_symbols", { symbols = { "Method" } }), desc = "Method" },
      { "<leader>ssC", Util.telescope("lsp_document_symbols", { symbols = { "Constructor" } }), desc = "Constructor" },
      { "<leader>sse", Util.telescope("lsp_document_symbols", { symbols = { "Enum" } }), desc = "Enum" },
      { "<leader>ssi", Util.telescope("lsp_document_symbols", { symbols = { "Interface" } }), desc = "Interface" },
      { "<leader>ssM", Util.telescope("lsp_document_symbols", { symbols = { "Module" } }), desc = "Module" },
      { "<leader>sss", Util.telescope("lsp_document_symbols", { symbols = { "Struct" } }), desc = "Struct" },
      { "<leader>sst", Util.telescope("lsp_document_symbols", { symbols = { "Trait" } }), desc = "Trait" },
      { "<leader>ssF", Util.telescope("lsp_document_symbols", { symbols = { "Field" } }), desc = "Field" },
      { "<leader>ssp", Util.telescope("lsp_document_symbols", { symbols = { "Property" } }), desc = "Property" },
      {
        "<leader>ssv",
        Util.telescope("lsp_document_symbols", { symbols = { "Variable", "Parameter" } }),
        desc = "Variable",
      },

      -- { "<leader>sSc", Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Class" } }), desc = "Class" },
      -- {
      --   "<leader>sSf",
      --   Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Function" } }),
      --   desc = "Function",
      -- },
      -- { "<leader>sSm", Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Method" } }), desc = "Method" },
      -- {
      --   "<leader>sSC",
      --   Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Constructor" } }),
      --   desc = "Constructor",
      -- },
      -- { "<leader>sSe", Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Enum" } }), desc = "Enum" },
      -- {
      --   "<leader>sSi",
      --   Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Interface" } }),
      --   desc = "Interface",
      -- },
      -- { "<leader>sSM", Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Module" } }), desc = "Module" },
      -- { "<leader>sSs", Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Struct" } }), desc = "Struct" },
      -- { "<leader>sSt", Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Trait" } }), desc = "Trait" },
      -- { "<leader>sSF", Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Field" } }), desc = "Field" },
      -- {
      --   "<leader>sSp",
      --   Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Property" } }),
      --   desc = "Property",
      -- },
      -- {
      --   "<leader>sSv",
      --   Util.telescope("lsp_dynamic_workspace_symbols", { symbols = { "Variable", "Parameter" } }),
      --   desc = "Variable",
      -- },
    },
    opts = function(opts)
      -- optional fuzzy finder
      -- if not Util.has("leap.nvim") then
      --   return
      -- end
      -- local leap = function(prompt_bufnr)
      --   -- local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      --   -- local chunks = { { "event fired" }, { vim.inspect(picker.preview_win) } }
      --   -- vim.api.nvim_echo(chunks, false, {})
      --
      --   local win = require("telescope.actions.state").get_current_picker(prompt_bufnr).preview_win
      --   return require("leap").leap({
      --     target_windows = { win },
      --     -- on_complete = function()
      --     --   vim.cmd("stopinsert")
      --     -- end,
      --   })
      -- end
      -- flash telescope config
      -- if not Util.has("flash.nvim") then
      --   return
      -- end
      -- local function flash(prompt_bufnr)
      --   require("flash").jump({
      --     pattern = "^",
      --     label = { after = { 0, 0 } },
      --     search = {
      --       mode = "search",
      --       exclude = {
      --         function(win)
      --           return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
      --         end,
      --       },
      --     },
      --     action = function(match)
      --       local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      --       picker:set_selection(match.pos[1] - 1)
      --     end,
      --   })
      -- end
      -- opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      --   mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      -- })
      --
      return {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0,
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.telescop
          get_selection_window = function()
            -- local wins = vim.api.nvim_list_wins()
            -- table.insert(wins, 1, vim.api.nvim_get_current_win())
            -- for _, win in ipairs(wins) do
            --   local buf = vim.api.nvim_win_get_buf(win)
            --   if vim.bo[buf].buftype == "" then
            --     return win
            --   end

            -- return 0
            --
            require("edgy").goto_main()
            return 0
          end,
          -- from lunarvim
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
          -- https://github.com/rish987/nvim/blob/3c101f9089568348d6eb5fd09decba124817a275/lua/plugins/telescope.lua#L50
          file_ignore_patterns = {
            ".gitignore",
            "node_modules",
            "build",
            "dist",
            "yarn.lock",
            "*.git/*",
            "*/tmp/*",
            "*/*.bk",
          },
          pickers = {
            find_files = {
              hidden = false,
            },
            buffers = {
              layout_config = {
                prompt_position = "top",
                height = 0.5,
                width = 0.6,
              },
              sorting_strategy = "ascending",
              mappings = {
                i = {
                  ["<c-r>"] = require("telescope.actions").delete_buffer,
                },
              },
            },
            extensions = {
              fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
              },
              ["ui-select"] = {
                require("telescope.themes").get_dropdown({}),
              },
            },
          },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({}),
            },
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-q>"] = function(...)
                actions.smart_send_to_qflist(...)
                actions.open_qflist(...)
              end,
              ["<CR>"] = actions.select_default,
              ["<C-b>"] = function(prompt_bufnr)
                goto_file_selection(prompt_bufnr, "e")
              end,
              ["<C-x>"] = open_preview_file,
              ["<C-y>"] = yank_preview_buffer,
            },
            n = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-q>"] = function(...)
                actions.smart_send_to_qflist(...)
                actions.open_qflist(...)
              end,
              ["<C-x>"] = open_preview_file,
              ["<C-y>"] = yank_preview_buffer,
              ["<C-c>"] = function(prompt_bufnr)
                actions.copy_register(prompt_bufnr)
              end,
              ["<C-o>"] = function(prompt_bufnr)
                actions.paste_register(prompt_bufnr)
              end,
              ["K"] = function()
                actions.select_default()
              end,
              -- ["<a-s>"]
              ["S"] = function(prompt_bufnr)
                require("leap").leap({
                  targets = get_telescope_targets(prompt_bufnr),
                  action = function(target)
                    target.pick:set_selection(target.row)
                  end,
                })
              end,
              ["s"] = function(prompt_bufnr)
                require("leap").leap({
                  targets = get_telescope_targets(prompt_bufnr),
                  action = function(target)
                    target.pick:set_selection(target.row)
                    local chunks = { { "event fired" }, { vim.inspect(vim.api.nvim_win_get_buf(prompt_bufnr)) } }
                    vim.api.nvim_echo(chunks, false, {})
                    require("telescope.actions").select_default(prompt_bufnr)
                  end,
                })
              end,
              ["q"] = actions.close,
            },
            -- i = {
            -- ["<c-t>"]    = open_with_trouble,
            -- ["<a-t>"]    = open_selected_with_trouble,
            -- ["<a-i>"]    = find_files_no_ignore,
            -- ["<a-h>"]    = find_files_with_hidden,
            -- ["<C-Down>"] = actions.cycle_history_next,
            -- ["<C-Up>"]   = actions.cycle_history_prev,
            -- ["<C-f>"]    = actions.preview_scrolling_down,
            -- ["<C-b>"]    = actions.preview_scrolling_up,
            -- ["<C-l>"]    = actions.preview_scrolling_right,
            -- ["<C-h>"]    = actions.preview_scrolling_left,
            -- ["<C-k>"] = actions.move_selection_previous,
            -- ["<C-r>"] = actions.delete_buffer,
            -- ["<C-j>"] = actions.move_selection_next,
            -- ["<S-esc>"] = actions.close,
            -- ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
            -- },
          },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>sS"] = { name = "Goto Symbols (Workspace)" },
        ["<leader>ss"] = { name = "Goto Symbols" },
      },
    },
  },
}
