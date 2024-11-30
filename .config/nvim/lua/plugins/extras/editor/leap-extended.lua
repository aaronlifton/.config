local paste_on_remote_yank = true

return {
  { import = "lazyvim.plugins.extras.editor.leap" },
  {
    "ggandor/leap.nvim",
    optional = true,
    keys = {
      {
        "<C-s>",
        function()
          require("leap.treesitter").select()
        end,
        mode = { "n", "x", "o" },
        desc = "Treesitter Select (Leap)",
      },
      {
        "<M-s>",
        'V<cmd>lua require("leap.treesitter").select()<cr>',
        mode = { "n", "x", "o" },
        desc = "Treesitter Select (Leap - Line)",
      },
      {
        "g<C-r>",
        -- "gR", -- interferes with File References for vtsls
        -- "gS", -- interferes with treesj
        function()
          require("leap.remote").action()
        end,
        mode = { "n", "o" },
        desc = "Leap Remote",
      },
      -- format is different: <op>r<leap><motion/textobject>
      -- e.g. crle<cr>i"<esc>
      -- e.g. cr[first 2 letters]af to change a remote function
      -- repeat the operator for line: crle<cr>c<esc>
      -- not for visual mode, since r is useful there
      -- {
      --   "r",
      --   function()
      --     require("leap.remote").action()
      --   end,
      --   mode = { "o" },
      --   desc = "Leap Remote",
      -- },
      -- {
      --   "gV",
      --   function()
      --     require("leap.remote").action({ input = "V" })
      --   end,
      --   mode = { "n", "o" },
      --   desc = "Leap Remote",
      -- },
    },
    opts = {
      equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
    },
    -- config = function(_, opts)
    --   LazyVim default config
    --   local leap = require("leap")
    --   for k, v in pairs(opts) do
    --     leap.opts[k] = v
    --   end
    --   leap.add_default_mappings(true)
    --   Uncomment these lines to keep the evil-snipe mappings
    --   vim.keymap.del({ "x", "o" }, "x")
    --   vim.keymap.del({ "x", "o" }, "X")
    -- end,
    -- init = function()
    config = function(_, opts)
      -- LazyVim default config
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")

      require("leap.user").set_repeat_keys("<enter>", "<backspace>")
      vim.keymap.set({ "n", "x", "o" }, "ga", function()
        local sk = vim.deepcopy(require("leap").opts.special_keys)
        -- The items in `special_keys` can be both strings or tables - the
        -- shortest workaround might be the below one:
        sk.next_target = vim.fn.flatten(vim.list_extend({ "a" }, { sk.next_target }))
        sk.prev_target = vim.fn.flatten(vim.list_extend({ "A" }, { sk.prev_target }))

        require("leap.treesitter").select({ opts = { special_keys = sk } })
      end)
      -- vim.keymap.set({ "n", "x", "o" }, "gA", "V<CMD>lua require('leap.treesitter').select()<CR>")

      if paste_on_remote_yank then
        vim.api.nvim_create_augroup("LeapRemote", {})
        vim.api.nvim_create_autocmd("User", {
          pattern = "RemoteOperationDone",
          group = "LeapRemote",
          callback = function(event)
            -- Do not paste if some special register was in use.
            -- vim.cmd("normal! zz")
            vim.api.nvim_echo({ { event.data.register, "Normal" } }, false, {})
            if vim.v.operator == "y" and event.data.register == "+" then -- '"'
              vim.cmd("normal! p")
            end
          end,
        })
      end

      -- stylua: ignore
      local default_text_objects = {
        'iw', 'iW', 'is', 'ip', 'i[', 'i]', 'i(', 'i)', 'ib',
        'i>', 'i<', 'it', 'i{', 'i}', 'iB', 'i"', 'i\'', 'i`',
        'aw', 'aW', 'as', 'ap', 'a[', 'a]', 'a(', 'a)', 'ab',
        'a>', 'a<', 'at', 'a{', 'a}', 'aB', 'a"', 'a\'', 'a`',
        'af', 'if', 'aa', 'ia', 'ii', 'ai', 'iL', 'aL', 'iq',
        'aq'
      }
      -- Create remote versions of all native text objects by inserting `r`
      -- into the middle (`iw` becomes `irw`, etc.):
      for _, tobj in ipairs(default_text_objects) do
        vim.keymap.set({ "x", "o" }, tobj:sub(1, 1) .. "r" .. tobj:sub(2), function()
          require("leap.remote").action({ input = tobj })
        end)
      end
      vim.keymap.set({ "x", "o" }, "irr", function()
        require("leap.remote").action({ input = "iL" })
      end)
      vim.keymap.set({ "x", "o" }, "arr", function()
        require("leap.remote").action({ input = "aL" })
      end)
      -- This conflicts with inc-rename (<cr>)
      vim.keymap.set({ "x", "o" }, "rr", function()
        require("leap.remote").action({ input = "aL" })
      end)

      -- evil-snipe
      -- vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)")
      -- vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)")
      vim.keymap.set({ "x", "o" }, "z", "<Plug>(leap-forward-till)")
      vim.keymap.set({ "x", "o" }, "Z", "<Plug>(leap-backward-till)")
    end,
  },
  -- {
  --   "ggandor/flit.nvim",
  --   optional = true,
  --   opts = {
  --     clever_repeat = true,
  --   },
  -- },
  -- {
  --   "ggandor/leap-spooky.nvim",
  --   dependencies = { "leap.nvim" },
  --   config = function()
  --     require("leap-spooky").setup({
  --       -- Additional text objects, to be merged with the default ones.
  --       -- E.g.: {'iq', 'aq'} extra_text_objects = { "iq", "aq", "if", "af" },
  --       -- Mappings will be generated corresponding to all native text objects,
  --       -- like: (ir|ar|iR|aR|im|am|iM|aM){obj}.
  --       -- Special line objects will also be added, by repeating the affixes.
  --       -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
  --       -- window.
  --       affixes = {
  --         -- The cursor moves to the targeted object, and stays there.
  --         magnetic = { window = "m", cross_window = "M" },
  --         -- The operation is executed seemingly remotely (the cursor boomerangs
  --         -- back afterwards.
  --         remote = { window = "r", cross_window = "R" },
  --       },
  --       -- Defines text objects like `riw`, `raw`, etc., instead of
  --       -- targets.vim-style `irw`, `arw`.
  --       -- prefix = false,
  --       prefix = true,
  --       -- The yanked text will automatically be pasted at the cursor position
  --       -- if the unnamed register is in use.
  --       -- paste_on_remote_yank = false,
  --       paste_on_remote_yank = true,
  --       extra_text_objects = { "iq", "aq", "if", "af", "ii", "aa" },
  --     })
  --
  --     -- Configure leap here since leap opts don't work
  --     local leap = require("leap")
  --     leap.opts.equivalence_classes = {
  --       " \t\r\n",
  --       "([{",
  --       ")]}",
  --       "'\"`",
  --       "1p Backward to!",
  --       "2@",
  --       "3#",
  --       "4$",
  --       "5%",
  --       "6^",
  --       "7&",
  --       "8*",
  --       "9(",
  --       "0)",
  --       -- "=-",
  --       -- "_+",
  --       -- ":;",
  --       -- "<,>",
  --       -- "?/",
  --       -- "|\\",
  --     }
  --     leap.opts.substitute_chars = { ["\r"] = "¬" }
  --     -- leap.opts.special_keys = {
  --     --   prev_target = "<backspace>",
  --     --   prev_group = "<backspace>",
  --     -- }
  --   end,
  -- },
  -- {
  --   "ggandor/leap-ast.nvim",
  --   dependencies = { "leap.nvim" },
  --   config = function() end,
  --   keys = {
  --     {
  --       "qs",
  --       function()
  --         require("leap-ast").leap()
  --         -- Defines text objects like `riw`, `raw`, etc., instead of
  --         -- targets.vim-style `irw`, `arw`.
  --       end,
  --       { mode = { "n", "x", "o", "v" }, desc = "Leap AST" },
  --     },
  --   },
  -- },
  -- {
  --   "Grazfather/leaplines.nvim",
  --   dependencies = "ggandor/leap.nvim",
  --   keys = {
  --     -- Sample mappings only
  --     {
  --       desc = "Leap line upwards",
  --       mode = { "n", "v" },
  --       "<leader>k",
  --       function()
  --         require("leaplines").leap("up")
  --       end,
  --     },
  --     {
  --       desc = "Leap line downwards",
  --       mode = { "n", "v" },
  --       "<leader>j",
  --       function()
  --         require("leaplines").leap("down")
  --       end,
  --     },
  --   },
  -- },
}
