return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      -- <leader>fe
      { "<leader>e", "<cmd>Yazi<cr>", desc = "Yazi (Root Dir)" },
      -- <leader>fE
      { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Yazi (Cwd)" },
      { "<M-e>", "<cmd>Yazi toggle<cr>", desc = "Resume Yazi" },
      {
        "<M-E>",
        function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.fn.buflisted(buf) == 0 then return end

          local dir = Util.path.bufdir(buf)
          if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then vim.cmd((":cd %s"):format(dir)) end
          require("util.yazi.patches.env").patch_yazi()
          require("yazi").toggle({ no_edgy = true, env = { NVIM_FLOAT_WINDOW = true } })
        end,
        desc = "Resume Yazi Float",
      },
      {
        "<leader>fe",
        function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.fn.buflisted(buf) == 0 then return end

          local dir = Util.path.bufdir(buf)
          if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then vim.cmd((":cd %s"):format(dir)) end
          require("util.yazi.patches.env").patch_yazi()
          require("yazi").yazi({ no_edgy = true, env = { NVIM_FLOAT_WINDOW = true } })
        end,
        desc = "Yazi Float (CWD)",
      },
      {
        "<leader>fE",
        function()
          -- local cwd = LazyVim.root.cwd()
          -- vim.cmd((":cd %s"):format(cwd))
          require("util.yazi.patches.env").patch_yazi()
          require("yazi").yazi({ no_edgy = true, env = { NVIM_FLOAT_WINDOW = true } })
        end,
        desc = "Yazi Float (Root Dir)",
      },
    },
    cmd = {
      "Yazi",
      "Yazi cwd",
      "Yazi toggle",
    },
    opts = {
      open_for_directories = true,
      floating_window_scaling_factor = 0.8,
      -- when yazi is closed with no file chosen, change the Neovim working
      -- directory to the directory that yazi was in before it was closed. Defaults
      -- to being off (`false`)
      yazi_floating_window_border = "none",
      change_neovim_cwd_on_close = true,
      integrations = {
        grep_in_directory = "fzf-lua",
        grep_in_selected_files = "fzf-lua",
        resolve_relative_path_application = "grealpath",
        resolve_relative_path_implementation = function(args, get_relative_path)
          -- Resolve relative paths from the current Neovim cwd while offering a few
          -- fun alternate renderings (Markdown links, GitHub URLs).
          local cwd = vim.fn.getcwd()
          local cwd_abs = vim.fn.fnamemodify(cwd, ":p")
          local selected_abs_path = vim.fn.fnamemodify(args.selected_file, ":p")

          local function is_within_dir(path, dir)
            local normalized_dir = dir:gsub("/+$", "")
            local normalized_path = path:gsub("/+$", "")
            if normalized_path == normalized_dir then return true end
            return vim.startswith(normalized_path, normalized_dir .. "/")
          end

          local function default_fallback()
            return get_relative_path(args)
          end

          if not is_within_dir(selected_abs_path, cwd_abs) then
            -- Fall back to the configured resolver (grealpath) when the target
            -- file does not live inside the current working directory.
            return default_fallback()
          end

          local relative_from_cwd = get_relative_path({
            selected_file = args.selected_file,
            source_dir = cwd,
          })

          local mode = vim.g.yazi_relative_path_mode or "smart"
          if mode == "smart" then
            if vim.bo.filetype == "markdown" then
              mode = "markdown"
            else
              -- use "plain" for non-markdown files
              mode = "plain"
            end
          end

          local resolvers = require("util.yazi.resolvers")

          local Resolver = resolvers[mode]
          if Resolver == nil then
            vim.notify(
              string.format("Yazi resolver mode '%s' not found, falling back to default", mode),
              vim.log.levels.WARN,
              { title = "Yazi" }
            )

            return relative_from_cwd
          else
            return Resolver.resolve(selected_abs_path, relative_from_cwd)
          end
        end,
      },
      keymaps = {
        ["show-help"] = "~",
      },
      hooks = {
        yazi_opened = function(preselected_path, yazi_buffer_id, config)
          -- you can optionally modify the config for this specific yazi
          -- invocation if you want to customize the behaviour

          -- Reset horizontal scroll if insert mode is exited
          vim.keymap.set("n", "<M-r>", "jk0", { noremap = true, buffer = yazi_buffer_id })

          local winid = vim.fn.bufwinid(yazi_buffer_id)

          if vim.api.nvim_win_is_valid(winid) then
            local edgy_editor = require("edgy.editor")
            if type(edgy_editor.get_win) ~= "function" then
              vim.notify("Edgy API must have changed!", vim.log.levels.DEBUG)
              return
            end

            if edgy_editor.get_win(winid) then vim.w[winid].edgy = true end
          end
          vim.api.nvim_buf_set_var(yazi_buffer_id, "yazi_context", config)
        end,
        -- on_yazi_ready = function(buffer, config, process_api)
        --   require("yazi").yazi()
        -- end,
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- mark netrw as loaded sinito it's not loaded at all
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     filesystem = {
  --       hijack_netrw_behavior = "disabled",
  --     },
  --   },
  -- },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   enabled = false,
  -- },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {} ---@type (Edgy.View.Opts|string)[]
      local yazi_view --- @type (Edgy.View.Opts)
      yazi_view = {
        ft = "yazi",
        title = "Yazi",
        keys = {
          ["<C-Right>"] = function(win)
            win:resize("width", 4)
          end,
          -- decrease width
          ["<C-Left>"] = function(win)
            win:resize("width", -4)
          end,
        },
        wo = {
          sidescrolloff = 0,
          winfixbuf = true,
        },
        filter = function(buf, win)
          local yazi_ctx = vim.api.nvim_buf_get_var(buf, "yazi_context")
          local no_edgy
          if yazi_ctx then
            -- vim.api.nvim_echo({ { vim.inspect(yazi_ctx), "Normal" } }, true, {})
            if yazi_ctx.no_edgy then no_edgy = true end
          else
            vim.api.nvim_echo({ { vim.inspect("no yazi_config"), "Normal" } }, true, {})
          end
          return not no_edgy
        end,
      }
      table.insert(opts.left, yazi_view)
      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {} ---@type (Edgy.View.Opts|string)[]
        local snacks_terminal_view = { --- @type (Edgy.View.Opts)
          ft = "snacks_terminal",
          size = { height = 0.4 },
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_buf, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == pos
              and vim.w[win].snacks_win.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        }
        table.insert(opts[pos], snacks_terminal_view)
      end
    end,
  },
}
