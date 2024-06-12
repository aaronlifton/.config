local actions = require("telescope.actions")
local util = require("util.telescope_finders")

local function get_telescope_targets(prompt_bufnr)
  vim.cmd("echo 'here'")
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

local function goto_file_selection(prompt_bufnr, command)
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
  local telescope_state = require("telescope.state")
  local preview_win = telescope_state.get_status(prompt_bufnr).preview_win
  local preview_bufnr = vim.api.nvim_win_get_buf(preview_win)
  local lines = vim.api.nvim_buf_get_lines(preview_bufnr, 0, -1, false)
  vim.fn.setreg("0", lines)
  vim.api.nvim_echo({ { "Preview buffer content yanked", "Added" } }, true, {})
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>ssa",
        LazyVim.pick("lsp_document_symbols", { symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait", "Field", "Property", "Enum", "Constant" } }),
        desc = "All",
      },
      { "<leader>ssc", LazyVim.pick("lsp_document_symbols", { symbols = { "Class" } }), desc = "Class" },
      { "<leader>ssf", LazyVim.pick("lsp_document_symbols", { symbols = { "Function" } }), desc = "Function" },
      { "<leader>ssm", LazyVim.pick("lsp_document_symbols", { symbols = { "Method" } }), desc = "Method" },
      { "<leader>ssC", LazyVim.pick("lsp_document_symbols", { symbols = { "Constructor" } }), desc = "Constructor" },
      { "<leader>sse", LazyVim.pick("lsp_document_symbols", { symbols = { "Enum" } }), desc = "Enum" },
      { "<leader>ssi", LazyVim.pick("lsp_document_symbols", { symbols = { "Interface" } }), desc = "Interface" },
      { "<leader>ssM", LazyVim.pick("lsp_document_symbols", { symbols = { "Module" } }), desc = "Module" },
      { "<leader>sss", LazyVim.pick("lsp_document_symbols", { symbols = { "Struct" } }), desc = "Struct" },
      { "<leader>sst", LazyVim.pick("lsp_document_symbols", { symbols = { "Trait" } }), desc = "Trait" },
      { "<leader>ssF", LazyVim.pick("lsp_document_symbols", { symbols = { "Field" } }), desc = "Field" },
      { "<leader>ssp", LazyVim.pick("lsp_document_symbols", { symbols = { "Property" } }), desc = "Property" },
      { "<leader>ssv", LazyVim.pick("lsp_document_symbols", { symbols = { "Variable", "Parameter" } }), desc = "Variable" },
      {
        "<leader>sSa",
        LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait", "Field", "Property", "Enum", "Constant" } }),
        desc = "All",
      },
      { "<leader>sSc", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Class" } }), desc = "Class" },
      { "<leader>sSf", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Function" } }), desc = "Function" },
      { "<leader>sSm", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Method" } }), desc = "Method" },
      { "<leader>sSC", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Constructor" } }), desc = "Constructor" },
      { "<leader>sSe", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Enum" } }), desc = "Enum" },
      { "<leader>sSi", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Interface" } }), desc = "Interface" },
      { "<leader>sSM", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Module" } }), desc = "Module" },
      { "<leader>sSs", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Struct" } }), desc = "Struct" },
      { "<leader>sSt", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Trait" } }), desc = "Trait" },
      { "<leader>sSF", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Field" } }), desc = "Field" },
      { "<leader>sSp", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Property" } }), desc = "Property" },
      { "<leader>sSv", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Variable", "Parameter" } }), desc = "Variable" },
      { "<leader>sA", LazyVim.pick("treesitter"), desc = "Treesitter Symbols" },
      { "<leader>sP", "<cmd>Telescope builtin<cr>", desc = "Pickers (Telescope)" },
      { "<leader>fh", LazyVim.pick("find_files", { hidden = true }), desc = "Find Files (hidden)" },
      { "<leader><c-space>", LazyVim.pick("find_files", { hidden = true }), desc = "Find Files (hidden)" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "File History" },
      { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "stash" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "branches" },
      { "<leader>ff", util.telescope("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fF", util.telescope("files", { cwd = false }), desc = "Find Files (Cwd)" },
      -- { "<leader>sg", LazyVim.pick("live_grep", { layout_strategy = "horizontal", layout_config = { width = 0.5, height = 0.5 } }), desc = "Grep (Root Dir)"},
      -- { "<leader>sG", LazyVim.pick("live_grep", { cwd = false, layout_strategy = "horizontal", layout_config = { width = 0.5, height = 0.5 } }), desc = "Grep (cwd)"}
      -- { cwd = false }
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<S-esc>"] = actions.close,
            ["<C-w>"] = require("telescope.actions.layout").toggle_preview,
            ["<c-l>"] = require("telescope.actions.layout").cycle_layout_next,
            ["<a-l>"] = require("telescope.actions.layout").cycle_layout_prev,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-b>"] = function(prompt_bufnr)
              goto_file_selection(prompt_bufnr, "e")
            end,
            ["<C-y>"] = yank_preview_buffer,
            ["<C-Tab>"] = require("telescope.actions").select_tab_drop,
            ["<M-h>"] = require("telescope.actions").results_scrolling_left,
            ["<M-l>"] = require("telescope.actions").results_scrolling_right,
          },
          n = {
            ["s"] = function(prompt_bufnr)
              require("leap").leap({
                targets = get_telescope_targets(prompt_bufnr),
                action = function(target)
                  target.pick:set_selection(target.row)
                  require("telescope.actions").select_default(prompt_bufnr)
                end,
              })
            end,
            ["S"] = function(prompt_bufnr)
              require("leap").leap({
                targets = get_telescope_targets(prompt_bufnr),
                action = function(target)
                  target.pick:set_selection(target.row)
                end,
              })
            end,
          },
        },
        file_ignore_patterns = {
          ".gitignore",
          "node_modules",
          "build",
          "dist",
          "yarn.lock",
          "*.git/*",
          "*/tmp/*",
        },
      },
      pickers = {
        -- find_files = {
        --   theme = "dropdown",
        --   previewer = false,
        --   -- hidden = false,
        --   hidden = true,
        --   find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
        -- },
        -- git_files = {
        --   theme = "dropdown",
        --   previewer = false,
        -- },
        buffers = {
          -- theme = "dropdown",
          -- previewer = false,
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
        spell_suggest = {
          layout_config = {
            prompt_position = "top",
            height = 0.3,
            width = 0.25,
          },
          sorting_strategy = "ascending",
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
