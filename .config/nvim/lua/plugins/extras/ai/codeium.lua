return {
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    config = function()
      local opts = { expr = true, silent = true }

      vim.g.codeium_filetypes = {
        TelescopePrompt = false,
        DressingInput = false,
        ["neo-tree-popup"] = false,
        ["dap-repl"] = false,
      }

      -- Clear current suggestion	    codeium#Clear()	             <C-]>
      -- Next suggestion	            codeium#CycleCompletions(1)	 <M-]>
      -- Previous suggestion	        codeium#CycleCompletions(-1)><M-[>
      -- Insert suggestion	          codeium#Accept()	           <Tab>
      -- Manually trigger suggestion	codeium#Complete()	         <M-Bslash>
      vim.g.codeium_disable_bindings = 1

      vim.keymap.set("i", "<A-CR>", function()
        return vim.fn["codeium#Accept"]()
      end, opts)

      vim.keymap.set("i", "<A-]>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, opts)

      vim.keymap.set("i", "<A-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, opts)

      vim.keymap.set("i", "<A-c>", function()
        return vim.fn["codeium#Clear"]()
      end, opts)

      -- MattFTW
      -- vim.keymap.set("i", "<M-CR>", function()
      -- vim.keymap.set("i", "<A-CR>", function()
      --   return vim.fn["codeium#Accept"]()
      -- end, opts)
      --
      -- vim.keymap.set("i", "<A-]>", function()
      --   return vim.fn["codeium#CycleCompletions"](1)
      -- end, opts)
      --
      -- vim.keymap.set("i", "<A-[>", function()
      --   return vim.fn["codeium#CycleCompletions"](-1)
      -- end, opts)
      --
      -- vim.keymap.set("i", "<A-c>", function()
      --   return vim.fn["codeium#Clear"]()
      -- end, opts)

      -- Me
      -- vim.keymap.set("i", "<M-CR>", function()
      -- vim.keymap.set("i", "<C-g>", function()
      --   return vim.fn["codeium#Accept"]()
      -- end, opts)
      --
      -- vim.keymap.set("i", "<C-;>", function()
      --   return vim.fn["codeium#CycleCompletions"](1)
      -- end, opts)
      --
      -- vim.keymap.set("i", "<C-[>", function()
      --   return vim.fn["codeium#CycleCompletions"](-1)
      -- end, opts)
      --
      -- vim.keymap.set("i", "<C-]>", function()
      --   return vim.fn["codeium#Clear"]()
      -- end, opts)

      vim.keymap.set("n", "<leader>cI", "<cmd>CodeiumToggle<cr>", { desc = "Toggle IA (Codeium)" })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icon = require("lazyvim.config").icons.kinds.Codeium
      local function show_codeium_status()
        return icon .. vim.fn["codeium#GetStatusString"]()
      end

      -- Insert the icon
      table.insert(opts.sections.lualine_x, 2, {
        show_codeium_status,
        on_click = function(num_clicks, mouse_button, mods)
          if num_clicks == 1 and mouse_button == 1 and #mods == 0 then
            vim.cmd("echo 'Codeium'" .. vim.fn["codeium#GetStatusString"]())
          end
        end,
      })
    end,
  },
}
