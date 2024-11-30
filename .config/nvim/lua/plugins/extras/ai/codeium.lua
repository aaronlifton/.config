return {
  { import = "lazyvim.plugins.extras.ai.codeium" },
  -- {
  --   "Exafunction/codeium.nvim",
  --   optional = true,
  --   cond = not vim.g.ai_cmp,
  --   opts = {
  --     enable_chat = true,
  --   },
  -- },
  -- For ghost text, use codeium.vim instead of codeium.nvim
  -- NOTE: Has been replaced by codeium.nvim with enable_cmp_source = false
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    enabled = false,
    -- cond = vim.g.ai_cmp,
    config = function()
      local cmp = require("cmp")
      cmp.event:on("menu_opened", function()
        vim.g.codeium_manual = true
        vim.fn["codeium#Clear"]()
      end)
      cmp.event:on("menu_closed", function()
        vim.api.nvim_echo({ { "Menu closed" } }, true, {})
        vim.g.codeium_manual = false
        vim.fn["codeium#Complete"]()
      end)

      vim.g.codeium_filetypes = {
        TelescopePrompt = false,
        DressingInput = false,
        ["neo-tree-popup"] = false,
        ["dap-repl"] = false,
      }

      local opts = { expr = true, silent = true }
      vim.g.codeium_disable_bindings = 1

      -- Clear current suggestion	    codeium#Clear()	             <C-]>
      -- Next suggestion	            codeium#CycleCompletions(1)	 <M-]>
      -- Previous suggestion	        codeium#CycleCompletions(-1)><M-[>
      -- Insert suggestion	          codeium#Accept()	           <Tab>
      -- Manually trigger suggestion	codeium#Complete()	         <M-Bslash>

      vim.keymap.set("i", "<M-CR>", function()
        return vim.fn["codeium#Accept"]()
      end, opts)

      vim.keymap.set("n", "<leader>aC", function()
        return vim.fn["codeium#Chat"]()
      end, { desc = "Open Web Chat (Codeium)" })

      vim.keymap.set("i", "<M-]>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, opts)

      vim.keymap.set("i", "<M-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, opts)

      vim.keymap.set("i", "<M-c>", function()
        return vim.fn["codeium#Clear"]()
      end, opts)

      vim.keymap.set("i", "<M-BSlash>", function()
        return vim.fn["codeium#Complete"]()
      end, opts)
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Complete"]()
      end, opts)

      vim.keymap.set("n", "<leader>cI2", "<cmd>CodeiumToggle<cr>", { desc = "Toggle Codeium" })
    end,
  },
  -- vim.g.ai_cmp and {
  --   "nvim-lualine/lualine.nvim",
  --   optional = true,
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     local icon = require("lazyvim.config").icons.kinds.Codeium
  --     local function show_codeium_status()
  --       return icon .. vim.fn["codeium#GetStatusString"]()
  --     end
  --
  --     table.insert(opts.sections.lualine_x, 2, {
  --       show_codeium_status,
  --       on_click = function(num_clicks, mouse_button, mods)
  --         if num_clicks == 1 and mouse_button == "l" and not mods:match("%w") then
  --           local status = vim.fn["codeium#GetStatusString"]()
  --           local highlight = require("util.lualine").highlight_for_status(status)
  --           vim.api.nvim_echo({
  --             { "Codeium: ", "Normal" },
  --             { status, highlight },
  --           }, false, {})
  --         end
  --       end,
  --     })
  --   end,
  -- } or {},
}
