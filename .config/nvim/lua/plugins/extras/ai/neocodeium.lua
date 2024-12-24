local disable_cmp_autocomplete = true
local manual_trigger = false
return {
  {
    "monkoose/neocodeium",
    event = "InsertEnter",
    config = function()
      local neocodeium = require("neocodeium")
      local cmp = require("cmp")
      local opts = {
        filetypes = {
          AvanteInput = false,
          mchat = false,
        },
      }
      if disable_cmp_autocomplete then
        opts = vim.tbl_extend("force", opts, {
          manual = false,
          filter = function()
            return not cmp.visible()
          end,
        })
        cmp.setup({
          completion = {
            autocomplete = false,
          },
        })
      end
      if manual_trigger then
        opts = vim.tbl_extend("force", opts, {
          manual = true,
        })
        vim.api.nvim_create_autocmd("User", {
          pattern = "NeoCodeiumCompletionDisplayed",
          callback = function()
            require("cmp").abort()
          end,
        })
      end
      neocodeium.setup(opts)

      local commands = require("neocodeium.commands")
      if vim.g.codeium_cmp_hide == true then
        cmp.event:on("menu_opened", function()
          commands.disable()
          neocodeium.clear()
        end)

        cmp.event:on("menu_closed", function()
          commands.enable()
        end)
      end

      vim.keymap.set("i", "<M-CR>", function()
        require("neocodeium").accept()
      end)
      vim.keymap.set("i", "<M-w>", function()
        require("neocodeium").accept_word()
      end)
      vim.keymap.set("i", "<M-a>", function()
        require("neocodeium").accept_line()
      end)
      vim.keymap.set("i", "<M-]>", function()
        require("neocodeium").cycle_or_complete()
      end)
      vim.keymap.set("i", "<M-[>", function()
        require("neocodeium").cycle_or_complete(-1)
      end)
      vim.keymap.set("i", "<M-c>", function()
        require("neocodeium").clear()
      end)
    end,
  },
}
