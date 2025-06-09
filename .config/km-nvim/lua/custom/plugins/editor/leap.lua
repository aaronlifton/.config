local paste_on_remote_yank = true
local use_clever_r = true
local trigger_remote_v_immediately = false
local keys = {}

return {
  {
    "ggandor/flit.nvim",
    enabled = true,
    keys = function()
      ---@type LazyKeysSpec[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" } }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", "<Plug>(leap)", mode = { "n", "x", "o" } },
      {
        -- Example: `gs{leap}yap`, `vgs{leap}apy`, or `ygs{leap}ap` yank the
        -- paragraph at the position specified by `{leap}`.
        "gs",
        function()
          if trigger_remote_v_immediately then
            -- Trigger visual selection right away, so that you can `gs{leap}apy`:
            require("leap.remote").action({ input = "v" })
          else
            require("leap.remote").action()
          end
        end,
        mode = { "n", "x", "o" },
        desc = "Leap Remote",
      },
      {
        -- Forced linewise version:
        "gS",
        function()
          require("leap.remote").action({ input = "V" })
        end,
        mode = { "n", "o" },
        desc = "Leap Remote",
      },
      -- Remote K:
      {
        "g<M-k>",
        function()
          require("leap.remote").action({ input = "K" })
        end,
        desc = "Leap Remote K",
      },
      -- Remote gx:
      -- {
      --   "gX",
      --   function()
      --     require("leap.remote").action({ input = "gx" })
      --   end,
      --   desc = "Leap Remote gx",
      -- },
    },
    opts = {
      equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
      substitute_chars = { ["\r"] = "¬" },
      preview_filter = function(ch0, ch1, ch2)
        -- Skip the middle of alphabetic words:
        --   foobar[quux]
        --   ^----^^^--^^
        return not (
          ch1:match("%s") -- skip when the first character of the pair is whitespace
          or ch0:match("%a") and ch1:match("%a") and ch2:match("%a") -- skip middle of alphanumerics
        )
      end,
    },
    config = function(_, opts)
      require("leap.user").set_default_mappings()

      require("leap.user").set_repeat_keys("<enter>", "<backspace>")

      if use_clever_r then
        -- "clever-R"
        -- vim.keymap.set({ "n", "x", "o" }, "R", function()
        vim.keymap.set({ "x", "o" }, "R", function()
          local sk = vim.deepcopy(require("leap").opts.special_keys)
          -- The items in `special_keys` can be both strings or tables - the
          -- shortest workaround might be the below one:
          sk.next_target = vim.fn.flatten(vim.list_extend({ "R" }, { sk.next_target }))
          sk.prev_target = vim.fn.flatten(vim.list_extend({ "r" }, { sk.prev_target }))
          -- Remove the temporary traversal keys from `safe_labels`.
          local sl = {}
          for _, label in ipairs(vim.deepcopy(require("leap").opts.safe_labels)) do
            if label ~= "R" and label ~= "r" then table.insert(sl, label) end
          end
          require("leap.treesitter").select({
            opts = { special_keys = sk, safe_labels = sl },
          })
        end)
      else
        vim.keymap.set({ "x", "o" }, "R", function()
          require("leap.treesitter").select()
        end)
      end

      -- Helix keymaps
      -- (<A-o> <A-up>) Expand selection to parent syntax node
      -- (<A-down> <A-i>) Shrink selection to previously expanded syntax node
      -- vim.keymap.set({ "n", "x", "o" }, "<M-o>", function()
      --   local sk = vim.deepcopy(require("leap").opts.special_keys)
      --   -- The items in `special_keys` can be both strings or tables - the
      --   -- shortest workaround might be the below one:
      --   sk.next_target = vim.fn.flatten(vim.list_extend({ "<M-o>" }, { sk.next_target }))
      --   sk.prev_target = vim.fn.flatten(vim.list_extend({ "<M-i>" }, { sk.prev_target }))
      --
      --   require("leap.treesitter").select({ opts = { special_keys = sk } })
      -- end, { desc = "Treesitter Select (Leap)" })

      -- Single line
      -- vim.keymap.set({ "x", "o" }, "rr", function()
      --   require("leap.remote").action({ input = "aL" })
      -- end)

      -- Lines with v:count
      -- A very handy custom mapping - remote line(s), with optional count (y2aa{leap})
      vim.keymap.set({ "x", "o" }, "rr", function()
        -- Force linewise selection.
        local V = vim.fn.mode(true):match("V") and "" or "V"
        -- In any case, do some movement, to trigger operations in O-p mode.
        local input = vim.v.count > 1 and (vim.v.count - 1 .. "j") or "hl"
        -- With `count=false` you can skip feeding count to the command
        -- automatically (we need -1 here, see above).
        require("leap.remote").action({ input = V .. input, count = false })
      end)

      if paste_on_remote_yank then
        vim.api.nvim_create_augroup("LeapRemote", {})
        vim.api.nvim_create_autocmd("User", {
          pattern = "RemoteOperationDone",
          group = "LeapRemote",
          callback = function(event)
            -- Do not paste if some special register was in use.
            -- vim.cmd("normal! zz")
            -- vim.api.nvim_echo({ { event.data.register, "Normal" } }, false, {})
            local cursor = vim.api.nvim_win_get_cursor(0)
            local char_at_cursor = vim.fn.getline(cursor[1]):sub(cursor[2], cursor[2])
            if vim.v.operator == "y" and event.data.register == "+" then
              if char_at_cursor:match("['\".]") ~= nil then vim.cmd("normal h") end
              vim.cmd("normal! p")
            end
          end,
        })
      end

      -- NOTE: Consider removing this in favor of normal mode operations (ygS{leap}aa)
      --
      -- gs{leap}yap yanks the paragraph at the position specified by {leap}.
      -- Getting used to the Normal-mode command is recommended over
      -- Operator-pending mode (ygs{leap}ap), since the former requires the same
      -- number of keystrokes, but it is much more flexible.

      -- ^ That paragraph was replaced by:

      -- Create remote versions of all a/i text objects by inserting `r`
      -- into the middle (`iw` becomes `irw`, etc.).
      -- A trick to avoid having to create separate hardcoded mappings for
      -- each text object: when entering `ar`/`ir`, consume the next
      -- character, and create the input from that character concatenated to
      -- `a`/`i`.
      --
      -- stylua: ignore
      do
        local remote_text_object = function (prefix)
          local ok, ch = pcall(vim.fn.getcharstr)  -- pcall for handling <C-c>
          if not ok or ch == vim.keycode('<esc>') then return end
          require('leap.remote').action { input = prefix .. ch }
        end
        vim.keymap.set({'x', 'o'}, 'ar', function () remote_text_object('a') end)
        vim.keymap.set({'x', 'o'}, 'ir', function () remote_text_object('i') end)
      end
      -- evil-snipe
      -- vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)")
      -- vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)")
      vim.keymap.set({ "x", "o" }, "z", "<Plug>(leap-forward-till)")
      vim.keymap.set({ "x", "o" }, "Z", "<Plug>(leap-backward-till)")

      require("which-key").add({
        { "ar", group = "remote" },
        { "ir", group = "remote" },
        { "r", group = "remote" },
        { "rr", desc = "line" },
        -- { "arw", desc = "word" },
        mode = { "o", "x" },
      }, { notify = false })

      return opts
    end,
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
}
