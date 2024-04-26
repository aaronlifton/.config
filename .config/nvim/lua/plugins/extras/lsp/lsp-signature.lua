return {
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
    -- init = function()
    --   local mason_lspconfig = require("mason-lspconfig")
    --
    --   for _, server in pairs(mason_lspconfig.get_installed_servers()) do
    --     local lspconfig_server = require("lspconfig")[server]
    --     if not lspconfig_server then
    --       vim.api.nvim_echo({ { "Server " .. server .. " is not installed", "WarningMsg" } }, true, {})
    --     else
    --       require("lspconfig")[server].setup({
    --         on_attach = function(client, bufnr)
    --           require("lsp_signature").on_attach({
    --             hint_prefix = "",
    --           })
    --
    --           local formatters = require("plugins.lsp.utils")
    --           local client_filetypes = client.config.filetypes or {}
    --           for _, filetype in ipairs(client_filetypes) do
    --             if #vim.tbl_keys(formatters.list_registered_formatters(filetype)) > 0 then
    --               client.server_capabilities.documentFormattingProvider = false
    --               client.server_capabilities.documentRangeFormattingProvider = false
    --             end
    --           end
    --
    --           if client.name == "clangd" then
    --             client.offset_encoding = "utf-16"
    --           end
    --         end,
    --
    --         capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    --       })
    --     end
    --   end
    -- end,
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
  },
}
