local DiagnosticsPatch = function()
  local instance = {}
  setmetatable(instance, { __index = Diagnostics })

  ---@type { [string]: integer }
  instance.diagnostics = {}

  ---@param entry { severity: integer }
  ---@param path string
  local function set_diagnostic(entry, path)
    if instance.diagnostics[path] then
      -- Highest severity is 1, which is why we're using the < operator
      if entry.severity < instance.diagnostics[path] then instance.diagnostics[path] = entry.severity end
    else
      instance.diagnostics[path] = entry.severity
    end
  end

  for _, entry in ipairs(vim.diagnostic.get()) do
    local is_valid_buf = entry.bufnr and vim.api.nvim_buf_is_valid(entry.bufnr)
    if not is_valid_buf then return instance end

    local path = vim.api.nvim_buf_get_name(entry.bufnr)

    set_diagnostic(entry, path)

    -- Propagate the status up through the parent directories
    for dir in vim.fs.parents(path) do
      if dir == vim.fn.getcwd() then break end
      set_diagnostic(entry, dir)
    end
  end

  return instance
end

return {
  -- { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "simonmclean/triptych.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-tree/nvim-web-devicons", -- optional for icons
      "antosha417/nvim-lsp-file-operations", -- optional LSP integration
    },
    opts = {
      mappings = {
        -- Default mappings
        show_help = "g?",
        jump_to_cwd = ".", -- Pressing again will toggle back
        nav_left = "h",
        nav_right = { "l", "<CR>" }, -- If target is a file, opens the file in-place
        open_hsplit = { "-" },
        open_vsplit = { "|" },
        open_tab = { "<C-t>" },
        cd = "<leader>cd",
        delete = "d",
        add = "a",
        copy = "c",
        rename = "r",
        rename_from_scratch = "R",
        cut = "x",
        paste = "p",
        quit = "q",
        toggle_hidden = "<leader>.",
        toggle_collapse_dirs = "z",
      },
      git_signs = {
        enabled = false,
        icons = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      },
      extension_mappings = {
        ["<c-f>"] = {
          mode = "n",
          fn = function(target, _)
            require("fzf-lua").live_grep({
              cwd = vim.fn.fnamemodify(target.path, ":h"),
              git_icons = false,
              rg_opts = "-u",
            })
          end,
        },
        ["<leader>sf"] = {
          mode = "n",
          fn = function(target, _)
            require("fzf-lua").live_grep({
              cwd = target.dirname,
            })
          end,
        },
      },
    }, -- config options here
    keys = {
      -- { '<leader>-', ':Triptych<CR>' },
      -- Lua function is faster
      { "<leader>e", ":Triptych<CR>" },
      {
        "<leader>e",
        -- "<leader><D-e>",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local cwd = LazyVim.root:get({ buf = buf })
          -- local cwd_of_current_file = vim.fn.expand("%:p:h")
          require("triptych").toggle_triptych()
        end,
      },
      {
        "<leader>E",
        -- "<leader><D-E>",
        function()
          -- local project_root = vim.fn.getcwd()
          local cwd = LazyVim.root.cwd()
          -- local root = LazyVim.root.get({ normalize = true })
          require("triptych").toggle_triptych(cwd)
        end,
        desc = "Open Triptych (CWD)",
      },
      {
        "<leader><C-e>",
        function()
          local nvim_config_dir = vim.fn.expand("~/.config/nvim")
          require("triptych").toggle_triptych(nvim_config_dir)
        end,
        desc = "Open Triptych (CWD)",
      },
    },
    init = function()
      -- local diag = require("triptych.diagnostics")
      -- diag.new = DiagnosticsPatch

      vim.api.nvim_create_user_command("TriptychOpen", function(opts)
        require("triptych").toggle_triptych(opts.args)
      end, {
        nargs = "?",
        complete = "dir",
        desc = "Open Triptych at specified directory",
      })
    end,
  },
}
