return {
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      cmp.event:on("menu_opened", function()
        vim.g.codeium_manual = true
        vim.fn["codeium#Clear"]()
      end)
      cmp.event:on("menu_closed", function()
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

      vim.keymap.set("i", "<M-CR>", function()
        -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, true, true), "n", true)

        -- vim.schedule_wrap(function()
        --   if cmp.visible() then
        --     require("cmp").mapping.abort()
        --   end
        -- end)
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

      vim.keymap.set("n", "<leader>cI2", "<cmd>CodeiumToggle<cr>", { desc = "Toggle Codeium" })
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
          local data = { num_clicks = num_clicks, mouse_button = mouse_button, mods = mods }
          vim.api.nvim_echo({ { vim.inspect(data) } }, false, {})
          if num_clicks == 1 and mouse_button == "l" and not mods:match("%w") then
            local status = vim.fn["codeium#GetStatusString"]()
            local highlight = require("util.lualine").highlight_for_status(status)
            vim.api.nvim_echo({
              { "Codeium: ", "Normal" },
              { status, highlight },
            }, false, {})
          end
        end,
      })
    end,
  },
}
