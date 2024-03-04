local nvim_0_10 = vim.fn.has("nvim-0.10")
local tailwind_filetypes = {
  "astro",
  "svelte",
  "vue",
  "html",
  "css",
  "scss",
  "less",
  "styl",
  "javascript",
  "typescript",
  "javascriptreact",
  "javascript.jsx",
  "typescriptreact",
  "typescript.tsx",
  "jsx",
  "tsx",
  "slim",
  "ex",
  "exs",
  "heex",
  "gotmpl",
  "templ",
  "rust",
  "rs",
}

return {
  { "folke/neodev.nvim", before = "neovim/nvim-lspconfig" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {},
        solargraph = {},
        zls = {},
        astro = {},
        tailwindcss = {
          filetypes_include = tailwind_filetypes,
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              hint = {
                enable = nvim_0_10,
                setType = nvim_0_10,
              },
              diagnostics = {
                globals = { "vim" },
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        emmet_ls = {
          filetypes = tailwind_filetypes,
        },
        -- tsserver = {
        --   -- root_dir = function(...)
        --   --   return require("lspconfig.util").root_pattern(".git")(...)
        --   -- end,
        --   single_file_support = false,
        --   settings = {
        --     typescript = {
        --       inlayHints = {
        --         includeInlayParameterNameHints = "literal",
        --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --         includeInlayFunctionParameterTypeHints = true,
        --         includeInlayVariableTypeHints = false,
        --         includeInlayPropertyDeclarationTypeHints = true,
        --         includeInlayFunctionLikeReturnTypeHints = true,
        --         includeInlayEnumMemberValueHints = true,
        --       },
        --     },
        --     javascript = {
        --       inlayHints = {
        --         includeInlayParameterNameHints = "all",
        --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --         includeInlayFunctionParameterTypeHints = true,
        --         includeInlayVariableTypeHints = true,
        --         includeInlayPropertyDeclarationTypeHints = true,
        --         includeInlayFunctionLikeReturnTypeHints = true,
        --         includeInlayEnumMemberValueHints = true,
        --       },
        --     },
        --   },
        -- },
      },
      diagnostics = {
        virtual_text = {
          float = {
            border = {
              { "┌", "FloatBorder" },
              { "─", "FloatBorder" },
              { "┐", "FloatBorder" },
              { "│", "FloatBorder" },
              { "┘", "FloatBorder" },
              { "─", "FloatBorder" },
              { "└", "FloatBorder" },
              { "│", "FloatBorder" },
            },
          },
        },
      },
      inlay_hints = {
        enabled = nvim_0_10,
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
        emmet_ls = function(_, opts)
          opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
        end,
      },
      filetypes = { "zig", "gitignore", "gitconfig" },
    },
  },
}

-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       --@type lspconfig.options
--       -- make sure mason installs the server
--       servers = {
--         ---@type lspconfig.options.tsserver
--         tsserver = {
--           keys = {
--             {
--               "<leader>co",
--               function()
--                 vim.lsp.buf.code_action({
--                   apply = true,
--                   context = {
--                     only = { "source.organizeImports.ts" },
--                     diagnostics = {},
--                   },
--                 })
--               end,
--               desc = "Organize Imports",
--             },
--           },
--           settings = {
--             typescript = {
--               format = {
--                 indentSize = vim.o.shiftwidth,
--                 convertTabsToSpaces = vim.o.expandtab,
--                 tabSize = vim.o.tabstop,
--               },
--             },
--             javascript = {
--               format = {
--                 indentSize = vim.o.shiftwidth,
--                 convertTabsToSpaces = vim.o.expandtab,
--                 tabSize = vim.o.tabstop,
--               },
--             },
--             completions = {
--               completeFunctionCalls = true,
--             },
--           },
--         },
--         eslint = {
--           settings = {
--             -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
--             workingDirectory = { mode = "auto" },
--           },
--         },
--       },
--       setup = {
--         eslint = function()
--           vim.api.nvim_create_autocmd("BufWritePre", {
--             callback = function(event)
--               if not require("lazyvim.util").format.enabled() then
--                 -- exit early if autoformat is not enabled
--                 return
--               end
--
--               local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
--               local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
--               if client then
--                 if #diag > 0 then
--                   vim.cmd("EslintFixAll")
--                 end
--               end
--             end,
--           })
--         end,
--         tailwindcss = function(_, opts)
--           local tw = require("lspconfig.server_configurations.tailwindcss")
--           opts.filetypes = opts.filetypes or {}
--
--           -- Add default filetypes
--           vim.list_extend(opts.filetypes, tw.default_config.filetypes)
--
--           -- Remove excluded filetypes
--           --- @param ft string
--           opts.filetypes = vim.tbl_filter(function(ft)
--             return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
--           end, opts.filetypes)
--
--           -- Add additional filetypes
--           vim.list_extend(opts.filetypes, opts.filetypes_include or {})
--         end,
--       },
--     },
--   }
-- }
-- -- add tsserver and setup with typescript.nvim instead of lspconfig
-- -- {
-- --   "neovim/nvim-lspconfig",
-- --   enabled = not vim.g.vscode,
-- --   dependencies = {
-- --     "jose-elias-alvarez/typescript.nvim",
-- --     init = function()
-- --       require("lazyvim.util").lsp.on_attach(function(_, buffer)
-- --         -- stylua: ignore
-- --         vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
-- --         vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
-- --       end)
-- --     end,
-- --   },
-- --   ---@class PluginLspOpts
-- --   opts = {
-- --     ---@type lspconfig.options
-- --     servers = {
-- --       -- tsserver will be automatically installed with mason and loaded with lspconfig
-- --       tsserver = {},
-- --       pyright = {},
-- --       rust_analyzer = {
-- --         -- Server-specific settings. See `:help lspconfig-setup`
-- --         settings = {
-- --           ["rust-analyzer"] = {},
-- --         },
-- --       }
-- --
-- --
-- --     },
-- --     -- you can do any additional lsp server setup here
-- --     -- return true if you don't want this server to be setup with lspconfig
-- --     ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
-- --     setup = {
-- --       -- example to setup with typescript.nvim
-- --       tsserver = function(_, opts)
-- --         local on_attach = function(client, bufnr)
-- --           -- format on save
-- --           if client.server_capabilities.documentFormattingProvider then
-- --             vim.api.nvim_create_autocmd("BufWritePre", {
-- --               group = vim.api.nvim_create_augroup("Format", { clear = true }),
-- --               buffer = bufnr,
-- --               callback = function() vim.lsp.buf.formatting_seq_sync() end
-- --             })
-- --           end
-- --         end
-- --
-- --         require("typescript").setup({
-- --           on_attach = on_attach,
-- --           filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
-- --           cmd = { "typescript-language-server", "--stdio" }
-- --           server = opts
-- --         })
-- --
-- --         return true
-- --       end,
-- --       -- Specify * to use this function as a fallback for any server
-- --       -- ["*"] = function(server, opts) end,
-- --     },
-- --   },
-- -- },
--
-- -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
-- -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
-- -- { import = "lazyvim.plugins.extras.lang.typescript" },
--
-- -- add more treesitter parsers
-- -- {
-- --   "nvim-treesitter/nvim-treesitter",
-- --   dependencies = {
-- --     "JoosepAlviste/nvim-ts-context-commentstring",
-- --   },
-- --   opts = {
-- --     ensure_installed = {
-- --       "bash",
-- --       "html",
-- --       "javascript",
-- --       "json",
-- --       "lua",
-- --       "markdown",
-- --       "markdown_inline",
-- --       "python",
-- --       "query",
-- --       "regex",
-- --       "tsx",
-- --       "typescript",
-- --       "vim",
-- --       "yaml",
-- --     },
-- --   },
-- -- },
--
-- -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
-- -- would overwrite `ensure_installed` with the new value.
-- -- If you'd rather extend the default config, use the code below instead:
-- -- {
-- --   "nvim-treesitter/nvim-treesitter",
-- --   opts = function(_, opts)
-- --     -- add tsx and treesitter
-- --     vim.list_extend(opts.ensure_installed, {
-- --       "tsx",
-- --       "typescript",
-- --     })
-- --   end,
-- -- },
-- --
-- -- -- the opts function can also be used to change the default opts:
-- -- {
-- --   "nvim-lualine/lualine.nvim",
-- --   event = "VeryLazy",
-- --   opts = function(_, opts)
-- --     table.insert(opts.sections.lualine_x, "😄")
-- --   end,
-- -- },
-- --
-- -- -- or you can return new options to override all the defaults
-- -- {
-- --   "nvim-lualine/lualine.nvim",
-- --   event = "VeryLazy",
-- --   opts = function()
-- --     return {
-- --       --[[add your custom lualine config here]]
-- --     }
-- --   end,
-- -- },
-- --
--
-- -- { import = "neovim/nvim-lspconfig" },
-- -- {
-- --   "neovim/nvim-lspconfig",
-- --   enabled = not vim.g.vscode,
-- --   opts = {
-- --     servers = { eslint = {} },
-- --     setup = {
-- --       eslint = function()
-- --         require("lazyvim.util").lsp.ON_ATTACH(FUNCTION(CLIENT)
-- --           if client.name == "eslint" then
-- --             client.server_capabilities.documentFormattingProvider = true
-- --           elseif client.name == "tsserver" then
-- --             client.server_capabilities.documentFormattingProvider = false
-- --           end
-- --         end)
-- --       end,
-- --     },
-- --   },
-- -- },
