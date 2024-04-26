-- local function get_codelldb()
--   local mason_registry = require("mason-registry")
--   local codelldb = mason_registry.get_package("codelldb")
--   local extension_path = codelldb:get_install_path() .. "/extension/"
--   local codelldb_path = extension_path .. "adapter/codelldb"
--   local liblldb_path = ""
--   if vim.loop.os_uname().sysname:find("Windows") then
--     liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
--   elseif vim.fn.has("mac") == 1 then
--     liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
--   else
--     liblldb_path = extension_path .. "lldb/lib/liblldb.so"
--   end
--   return codelldb_path, liblldb_path
-- end
--
return {
  { import = "lazyvim.plugins.extras.lang.rust" },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.toml = opts.formatters_by_ft.toml or {}
      table.insert(opts.formatters_by_ft.toml, "taplo")

      opts.formatters_by_ft.rust = opts.formatters_by_ft.rust or {}
      table.insert(opts.formatters_by_ft.rust, "rustfmt")
      -- return opts
    end,
  },
  {
    "Saecki/crates.nvim",
    -- stylua: ignore
    keys = {
       { "<leader>prR", function() require("crates").reload() end, desc = "Reload" },

       { "<leader>pru", function() require("crates").update_crate() end, desc = "Update Crate" },
       { "<leader>pru", mode = "v", function() require("crates").update_crates() end, desc = "Update Crates" },
       { "<leader>pra", function() require("crates").update_all_crates() end, desc = "Update All Crates" },

       { "<leader>prU", function() require("crates").upgrade_crate() end, desc = "Upgrade Crate" },
       { "<leader>prU", mode = "v", function() require("crates").upgrade_crates() end, desc = "Upgrade Crates" },
       { "<leader>prA", function() require("crates").upgrade_all_crates() end, desc = "Upgrade All Crates" },

       { "<leader>prt", function() require("crates").expand_plain_crate_to_inline_table() end, desc = "Extract into Inline Table" },
       { "<leader>prT", function() require("crates").extract_crate_into_table() end, desc = "Extract into Table" },

       { "<leader>prh", function() require("crates").open_homepage() end, desc = "Homepage" },
       { "<leader>prr", function() require("crates").open_repository() end, desc = "Repo" },
       { "<leader>prd", function() require("crates").open_documentation() end, desc = "Documentation" },
       { "<leader>prc", function() require("crates").open_crates_io() end, desc = "Crates.io" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>p"] = { name = " packages/dependencies" },
        ["<leader>pr"] = { name = "rust" },
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "rust",
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = { "simrat39/rust-tools.nvim", "rust-lang/rust.vim" },
  --   opts = {
  --     servers = {
  --       rust_analyzer = {
  --         settings = {
  --           ["rust-analyzer"] = {
  --             cargo = {
  --               allFeatures = true,
  --               loadOutDirsFromCheck = true,
  --               runBuildScripts = true,
  --             },
  --             -- Add clippy lints for Rust.
  --             checkOnSave = {
  --               allFeatures = true,
  --               command = "clippy",
  --               extraArgs = { "--no-deps" },
  --             },
  --             procMacro = {
  --               enable = true,
  --               ignored = {
  --                 ["async-trait"] = { "async_trait" },
  --                 ["napi-derive"] = { "napi" },
  --                 ["async-recursion"] = { "async_recursion" },
  --               },
  --             },
  --           },
  --         },
  --       },
  --       taplo = {},
  --     },
  --     setup = {
  --       rust_analyzer = function(_, opts)
  --         local codelldb_path, liblldb_path = get_codelldb()
  --         local lsp_utils = require("util.nls_lsp")
  --         lsp_utils.on_attach(function(client, bufnr)
  --           local map = function(mode, lhs, rhs, desc)
  --             if desc then
  --               desc = desc
  --             end
  --             vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
  --           end
  --           -- stylua: ignore
  --           if client.name == "rust_analyzer" then
  --             map("n", "<leader>le", "<cmd>RustRunnables<cr>", "Runnables")
  --             map("n", "<leader>ll", function() vim.lsp.codelens.run() end, "Code Lens" )
  --             map("n", "<leader>lt", "<cmd>Cargo test<cr>", "Cargo test" )
  --             map("n", "<leader>lR", "<cmd>Cargo run<cr>", "Cargo run" )
  --           end
  --         end)
  --
  --         vim.api.nvim_create_autocmd({ "BufEnter" }, {
  --           pattern = { "Cargo.toml" },
  --           callback = function(event)
  --             local bufnr = event.buf
  --
  --             -- Register keymappings
  --             -- local wk = require "which-key"
  --             -- local keys = { mode = { "n", "v" }, ["<leader>lc"] = { name = "+Crates" } }
  --             -- wk.register(keys)
  --
  --             local map = function(mode, lhs, rhs, desc)
  --               if desc then
  --                 desc = desc
  --               end
  --               vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
  --             end
  --             map("n", "<leader>lc", function() end, "+Crates")
  --             map("n", "<leader>lcy", "<cmd>lua require'crates'.open_repository()<cr>", "Open Repository")
  --             map("n", "<leader>lcp", "<cmd>lua require'crates'.show_popup()<cr>", "Show Popup")
  --             map("n", "<leader>lci", "<cmd>lua require'crates'.show_crate_popup()<cr>", "Show Info")
  --             map("n", "<leader>lcf", "<cmd>lua require'crates'.show_features_popup()<cr>", "Show Features")
  --             map("n", "<leader>lcd", "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "Show Dependencies")
  --           end,
  --         })
  --
  --         require("rust-tools").setup({
  --           tools = {
  --             hover_actions = { border = "solid" },
  --             on_initialized = function()
  --               vim.cmd([[
  --                 augroup RustLSP
  --                   autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
  --                   autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
  --                   autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
  --                 augroup END
  --               ]])
  --             end,
  --           },
  --           server = opts,
  --           dap = {
  --             adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
  --           },
  --         })
  --         return true
  --       end,
  --     },
  --   },
  -- },
}
