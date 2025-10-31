-- Inspo: https://github.com/hoangcongminh/.dotfiles/blob/340643068f347eeb526043f3cd0349d9d54ff6ba/.config/nvim/lua/plugins/flutter.lua#L10
return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
      "RobertBrunhage/flutter-riverpod-snippets",
    },
    opts = {
      ui = {
        border = "solid",
        -- border = "rounded",
        notification_style = "native",
      },
      debugger = {
        -- enabled = is_nightly,
        -- run_via_dap = is_nightly,
        exception_breakpoints = {},
      },
      outline = { auto_open = false },
      decorations = {
        statusline = { device = true, app_version = true },
      },
      widget_guides = { enabled = true, debug = false },
      dev_log = { enabled = true, open_cmd = "tabedit" },
      closing_tags = {
        highlight = "ErrorMsg", -- Highlight closing tags of widgets
        prefix = ">", -- Add prefix > to closing tags
        enabled = true,
      },
      lsp = {
        color = {
          enabled = true,
          background = true,
          virtual_text = true,
        },
        settings = {
          showTodos = false,
          renameFilesWithClasses = "always",
          updateImportsOnRename = true,
          completeFunctionCalls = true,
          lineLength = 100,
        },
      },
    },
    config = function(_, opts)
      require("flutter-tools").setup(opts)

      local function on_attach(_, bufnr)
        vim.keymap.set("n", "<space>fa", vim.cmd.FlutterRun, opts)
        vim.keymap.set("n", "<space>fq", vim.cmd.FlutterQuit, opts)
        vim.keymap.set("n", "<space>fR", vim.cmd.FlutterRestart, opts)
        vim.keymap.set("n", "<space>dv", vim.cmd.FlutterDevices, opts)
        vim.keymap.set("n", "<space>o", vim.cmd.FlutterOutlineToggle, opts)
        vim.keymap.set("n", "<Space>rl", vim.cmd.FlutterReload, opts)
        vim.keymap.set("n", "<space>fpg", vim.cmd.FlutterPubGet, opts)
        vim.keymap.set("n", "<space>fd", vim.cmd.FlutterLogToggle, opts)
        vim.keymap.set("n", "<space>fl", vim.cmd.FlutterLogClear, opts)
        vim.keymap.set("n", "<space>rn", vim.cmd.FlutterRename, opts)

        vim.api.nvim_create_user_command("FlutterBuildRunner", bufnr, function()
          vim.cmd("Dispatch flutter pub get; flutter pub run build_runner build --delete-conflicting-outputs")
        end, { force = true })

        vim.api.nvim_create_user_command("FlutterCLean", bufnr, function()
          vim.cmd("Dispatch flutter clean")
        end, { force = true })

        vim.api.nvim_create_user_command("FlutterRunRelease", bufnr, function()
          vim.cmd("Dispatch flutter clean; flutter pub get; flutter run --release")
        end, { force = true })
      end
    end,
    -- config = function(_, opts)
    --   -- alternatively you can override the default configs
    --   require("flutter-tools").setup({
    --     ui = {
    --       -- the border type to use for all floating windows, the same options/formats
    --       -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
    --       border = "rounded",
    --       -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
    --       -- please note that this option is eventually going to be deprecated and users will need to
    --       -- depend on plugins like `nvim-notify` instead.
    --       notification_style = "native" | "plugin",
    --     },
    --     decorations = {
    --       statusline = {
    --         -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
    --         -- this will show the current version of the flutter app from the pubspec.yaml file
    --         app_version = false,
    --         -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
    --         -- this will show the currently running device if an application was started with a specific
    --         -- device
    --         device = false,
    --         -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
    --         -- this will show the currently selected project configuration
    --         project_config = false,
    --       },
    --     },
    --     debugger = { -- integrate with nvim dap + install dart code debugger
    --       enabled = false,
    --       -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
    --       -- see |:help dap.set_exception_breakpoints()| for more info
    --       exception_breakpoints = {},
    --       -- Whether to call toString() on objects in debug views like hovers and the
    --       -- variables list.
    --       -- Invoking toString() has a performance cost and may introduce side-effects,
    --       -- although users may expected this functionality. null is treated like false.
    --       evaluate_to_string_in_debug_views = true,
    --       -- You can use the `debugger.register_configurations` to register custom runner configuration (for example for different targets or flavor). Plugin automatically registers the default configuration, but you can override it or add new ones.
    --       -- register_configurations = function(paths)
    --       --   require("dap").configurations.dart = {
    --       --     -- your custom configuration
    --       --   }
    --       -- end,
    --     },
    --     flutter_path = "<full/path/if/needed>", -- <-- this takes priority over the lookup
    --     flutter_lookup_cmd = nil, -- example "dirname $(which flutter)" or "asdf where flutter"
    --     root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project
    --     fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
    --     default_run_args = nil, -- Default options for run command (i.e `{ flutter = "--no-version-check" }`). Configured separately for `dart run` and `flutter run`.
    --     widget_guides = {
    --       enabled = false,
    --     },
    --     closing_tags = {
    --       highlight = "ErrorMsg", -- highlight for the closing tag
    --       prefix = ">", -- character to use for close tag e.g. > Widget
    --       priority = 10, -- priority of virtual text in current line
    --       -- consider to configure this when there is a possibility of multiple virtual text items in one line
    --       -- see `priority` option in |:help nvim_buf_set_extmark| for more info
    --       enabled = true, -- set to false to disable
    --     },
    --     dev_log = {
    --       enabled = true,
    --       filter = nil, -- optional callback to filter the log
    --       -- takes a log_line as string argument; returns a boolean or nil;
    --       -- the log_line is only added to the output if the function returns true
    --       notify_errors = false, -- if there is an error whilst running then notify the user
    --       open_cmd = "15split", -- command to use to open the log buffer
    --       focus_on_open = true, -- focus on the newly opened log window
    --     },
    --     dev_tools = {
    --       autostart = false, -- autostart devtools server if not detected
    --       auto_open_browser = false, -- Automatically opens devtools in the browser
    --     },
    --     outline = {
    --       open_cmd = "30vnew", -- command to use to open the outline buffer
    --       auto_open = false, -- if true this will open the outline automatically when it is first populated
    --     },
    --     lsp = {
    --       color = { -- show the derived colours for dart variables
    --         enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
    --         background = false, -- highlight the background
    --         background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
    --         foreground = false, -- highlight the foreground
    --         virtual_text = true, -- show the highlight using virtual text
    --         virtual_text_str = "■", -- the virtual text character to highlight
    --       },
    --       on_attach = my_custom_on_attach,
    --       capabilities = my_custom_capabilities, -- e.g. lsp_status capabilities
    --       --- OR you can specify a function to deactivate or change or control how the config is created
    --       capabilities = function(config)
    --         config.specificThingIDontWant = false
    --         return config
    --       end,
    --       -- see the link below for details on each option:
    --       -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
    --       settings = {
    --         showTodos = true,
    --         completeFunctionCalls = true,
    --         analysisExcludedFolders = { "<path-to-flutter-sdk-packages>" },
    --         renameFilesWithClasses = "prompt", -- "always"
    --         enableSnippets = true,
    --         updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
    --       },
    --     },
    --   })
    -- end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "sidlatau/neotest-dart" },
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require("neotest-dart")({ command = "flutter" }),
      })
    end,
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   optional = true,
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     table.insert(
  --       opts.sections.lualine_x,
  --       2,
  --       LazyVim.lualine.status(LazyVim.config.icons.kinds.Property, function()
  --         return vim.g.flutter_tools_decorations.app_version
  --       end)
  --     )
  --   end,
  -- },
}
