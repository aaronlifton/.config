local trigger_remote_v_immediately = false
local paste_on_remote_yank = true

local config = {
  auto_jump_first_match = {
    disable = function()
      require("leap").opts.safe_labels = ""
    end,
    force = function()
      require("leap").opts.labels = ""
    end,
  },
  preview_filter = {
    disable = function()
      require("leap").opts.preview_filter = function()
        return false
      end
    end,
    exclude_whitespace_and_middle_alphanumeric_words = function(ch0, ch1, ch2)
      -- Skip the pair if it begins with whitespace or mid-word alphanumeric
      -- character: foobar[quux]
      --            ^    ^^^  ^^
      -- return not (
      --   (ch1:match("%s") or ch2:match("%s")) -- skip when the first or second character of the pair is whitespace
      --   or (ch0:match("%w") and ch1:match("%w") and ch2:match("%w")) -- skip middle of alphanumerics
      -- )

      -- Exclude whitespace and the middle of alphabetic words from preview:
      --   foobar[baaz] = quux
      --   ^----^^^--^^-^-^--^
      require("leap").opts.preview_filter = function(ch0, ch1, ch2)
          -- stylua: ignore start
            return not (
              ch1:match('%s') or
              ch0:match('%a') and ch1:match('%a') and ch2:match('%a')
            )
        -- stylua: ignore end
      end
    end,
  },
  always_show_labels_at_beginning_of_match = function()
    -- `on_beacons` hooks into `beacons.light_up_beacons`, the function
    -- responsible for displaying stuff.
    require("leap").opts.on_beacons = function(targets, _, _)
      for _, t in ipairs(targets) do
        -- Overwrite the `offset` value in all beacons.
        -- target.beacon looks like: { <offset>, <extmark_opts> }
        if t.label and t.beacon then t.beacon[1] = 0 end
      end
    end
  end,
  grey_out_search_area = function()
    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
  end,
  restore_default_hl = function(color_scheme_name)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("LeapColorTweaks", {}),
      callback = function()
        if vim.g.colors_name == color_scheme_name then
          -- Forces using the defaults: sets `IncSearch` for labels,
          -- `Search` for matches, removes `LeapBackdrop`, and updates the
          -- look of concealed labels.
          require("leap").init_hl(true)
        end
      end,
    })
  end,
}

local experimental_features = {
  search_integration = function()
    vim.api.nvim_create_autocmd("CmdlineLeave", {
      group = vim.api.nvim_create_augroup("LeapOnSearch", {}),
      callback = function()
        local ev = vim.v.event
        local is_search_cmd = (ev.cmdtype == "/") or (ev.cmdtype == "?")
        local cnt = vim.fn.searchcount().total
        if is_search_cmd and not ev.abort and (cnt > 1) then
          -- Allow CmdLineLeave-related chores to be completed before
          -- invoking Leap.
          vim.schedule(function()
            -- We want "safe" labels, but no auto-jump (as the search
            -- command already does that), so just use `safe_labels`
            -- as `labels`, with n/N removed.
            local labels = require("leap").opts.safe_labels:gsub("[nN]", "")
            -- For `pattern` search, we never need to adjust conceallevel
            -- (no user input). We cannot merge `nil` from a table, but
            -- using the option's current value has the same effect.
            local vim_opts = { ["wo.conceallevel"] = vim.wo.conceallevel }
            require("leap").leap({
              pattern = vim.fn.getreg("/"), -- last search pattern
              windows = { vim.fn.win_getid() },
              opts = { safe_labels = "", labels = labels, vim_opts = vim_opts },
            })
          end)
        end
      end,
    })
  end,
  global_search = function()
    do
      local function leap_search(key, is_reverse)
        local cmdline_mode = vim.fn.mode(true):match("^c")
        if cmdline_mode then
          -- Finish the search command.
          vim.api.nvim_feedkeys(vim.keycode("<enter>"), "t", false)
        end
        if vim.fn.searchcount().total < 1 then return end
        -- Activate again if `:nohlsearch` has been used (Normal/Visual mode).
        vim.go.hlsearch = vim.go.hlsearch

        -- Allow the search command to complete its chores before
        -- invoking Leap (Command-line mode).
        vim.schedule(function()
          local leap = require("leap")
          -- Allow traversing with the trigger key.
          local next_target = vim.deepcopy(leap.opts.keys.next_target)
          if type(next_target) == "string" then next_target = { next_target } end
          table.insert(next_target, key)

          leap.leap({
            pattern = vim.fn.getreg("/"),
            -- If you always want to go forward/backward with the given key,
            -- regardless of the previous search direction, just set this to
            -- `is_reverse`.
            backward = (is_reverse and vim.v.searchforward == 1) or (not is_reverse and vim.v.searchforward == 0),
            opts = {
              keys = { next_target = next_target },
              -- Auto-jumping to the second match would be confusing without
              -- 'incsearch'.
              safe_labels = (cmdline_mode and not vim.o.incsearch) and ""
                -- Keep n/N usable in any case.
                or leap.opts.safe_labels:gsub("[nN]", ""),
            },
          })
          -- You might want to switch off the highlights after leaping.
          -- vim.cmd('nohlsearch')
        end)
      end

      vim.keymap.set({ "n", "x", "o", "c" }, "<c-s>", function()
        leap_search("<c-s>", false)
      end, { desc = "Leap to search matches" })

      vim.keymap.set({ "n", "x", "o", "c" }, "<c-q>", function()
        leap_search("<c-q>", true)
      end, { desc = "Leap to search matches (reverse)" })
    end
  end,
  one_char_search = function()
    do
      -- Return an argument table for `leap()`, tailored for f/t-motions.
      local function as_ft(key_specific_args)
        local common_args = {
          inputlen = 1,
          inclusive = true,
          -- To limit search scope to the current line:
          -- pattern = function (pat) return '\\%.l'..pat end,
          opts = {
            labels = "", -- force autojump
            safe_labels = vim.fn.mode(1):match("[no]") and "" or nil, -- [1]
            -- NOTE: Skipping the safe_labels key is the same as this:
            -- safe_labels = require("leap.opts").safe_labels, -- "sfnut/SFNLHMUGTZ?"
          },
        }
        return vim.tbl_deep_extend("keep", common_args, key_specific_args)
      end

      local clever = require("leap.user").with_traversal_keys -- [2]
      local clever_f = clever("f", "F")
      local clever_t = clever("t", "T")

      for key, key_specific_args in pairs({
        f = { opts = clever_f },
        F = { backward = true, opts = clever_f },
        t = { offset = -1, opts = clever_t },
        T = { backward = true, offset = 1, opts = clever_t },
      }) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          require("leap").leap(as_ft(key_specific_args))
        end)
      end
    end

    -- [1] Match the modes here for which you don't want to use labels
    --     (`:h mode()`, `:h lua-pattern`).
    -- [2] This helper function makes it easier to set "clever-f"-like
    --     functionality (https://github.com/rhysd/clever-f.vim), returning
    --     an `opts` table derived from the defaults, where the given keys
    --     are added to `keys.next_target` and `keys.prev_target`
  end,
  -- flit (enhanced f/t motions)
  one_char_search_bak = function()
    do
      -- Returns an argument table for `leap()`, tailored for f/t-motions.
      local function as_ft(key_specific_args)
        local common_args = {
          inputlen = 1,
          inclusive = true,
          -- To limit search scope to the current line:
          -- pattern = function (pat) return '\\%.l'..pat end,
          opts = {
            labels = "", -- force autojump
            safe_labels = vim.fn.mode(1):match("o") and "" or nil, -- [1]
            case_sensitive = true, -- [2]
          },
        }
        return vim.tbl_deep_extend("keep", common_args, key_specific_args)
      end

      local clever = require("leap.user").with_traversal_keys -- [3]
      local clever_f = clever("f", "F")
      local clever_t = clever("t", "T")

      for key, args in pairs({
        f = { opts = clever_f },
        F = { backward = true, opts = clever_f },
        t = { offset = -1, opts = clever_t },
        T = { backward = true, offset = 1, opts = clever_t },
      }) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          require("leap").leap(as_ft(args))
        end)
      end
    end

    ------------------------------------------------------------------------
    -- [1] Match the modes here for which you don't want to use labels
    --     (`:h mode()`, `:h lua-pattern`).
    -- [2] For 1-char search, you might want to aim for precision instead of
    --     typing comfort, to get as many direct jumps as possible.
    -- [3] This helper function makes it easier to set "clever-f"-like
    --     functionality (https://github.com/rhysd/clever-f.vim), returning
    --     an `opts` table derived from the defaults, where:
    --     * the given keys are added to `keys.next_target` and
    --       `keys.prev_target`
    --     * the forward key is used as the first label in `safe_labels`
    --     * the backward (reverse) key is removed from `safe_labels`
  end,
  jump_to_lines = function()
    vim.keymap.set({ "n", "x", "o" }, "|", function()
      local line = vim.fn.line(".")
      -- Skip 3-3 lines around the cursor.
      local top, bot = unpack({ math.max(1, line - 3), line + 3 })
      require("leap").leap({
        pattern = "\\v(%<" .. top .. "l|%>" .. bot .. "l)$",
        windows = { vim.fn.win_getid() },
        opts = { safe_labels = "" },
      })
    end)
  end,
  clever_s = function()
    do
      local clever_s = require("leap.user").with_traversal_keys("s", "S")
      vim.keymap.set({ "n", "x", "o" }, "s", function()
        require("leap").leap({ opts = clever_s })
      end)
      vim.keymap.set({ "n", "x", "o" }, "S", function()
        require("leap").leap({ backward = true, opts = clever_s })
      end)
    end
  end,
}

--- NOTES
-- **Swapping regions**
--
-- It deserves mention that this feature also makes exchanging two regions of text
-- moderately simple, without needing a custom plugin: `d{region1} gs{leap}
-- v{region2}p <jumping-back-here> P`.
--
-- Example (swapping two words): `diw gs{leap} viwp P`.
--
-- With remote text objects, the swap is even simpler, almost on par with
-- [vim-exchange](https://github.com/tommcdo/vim-exchange): `diw virw{leap}p P`.
--
-- using remote text objects _and_ combining them with an exchange operator is
-- pretty much text editing at the speed of thought: `cxiw cxirw{leap}`.

return {
  -- disable flash
  { "folke/flash.nvim", enabled = false, optional = true },
  {
    "ggandor/leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim.git",
    keys = {
      -- stylua: ignore start
      -- 2025 reccomended keybindings (instead of s/S for different directions on same page)
      { "s", "<Plug>(leap)", { "n", "x", "o" } },
      { "S", "<Plug>(leap-from-window)", "n" },
      -- evil-snipe
      { "z", "<Plug>(leap-forward-till)", mode = { "x", "o" } },
      { "Z", "<Plug>(leap-backward-till)", mode = { "x", "o" } },
      {
        "R",
        function()
          require("leap.treesitter").select({
            -- To increase/decrease the selection in a clever-f-like manner,
            -- with the trigger key itself (vRRRRrr...). The default keys
            -- (<enter>/<backspace>) also work, so feel free to skip this.
            opts = require("leap.user").with_traversal_keys("R", "r"),
          })
        end,
        mode = { "o", "x" },
        desc = "Treesitter Select (Leap)",
      },
      {
        -- Example: `gs{leap}yap`, `vgs{leap}apy`, or `ygs{leap}ap` yank the
        -- paragraph at the position specified by `{leap}`.
        "gs",
        function()
          if trigger_remote_v_immediately then
            -- Trigger visual selection right away, so that you can `gs{leap}apy`:
            -- NOTE: has a bug with scrolling when leaping to a different window.
            require("leap.remote").action({ input = "v" })
          else
            require("leap.remote").action()
          end
        end,
        mode = { "n", "x", "o" },
        desc = "Leap Remote",
      },
      {
        -- Forced linewise version
        "gS",
        function()
          require("leap.remote").action({ input = "V" })
        end,
        mode = { "n", "o" },
        desc = "Leap Remote",
      },
      -- NOTE: use `c_CTRL-G` and `c_CTRL-T` to move between matches without
      -- finishing the search.
      { "g/", function() require("leap.remote").action({ jumper = "/" }) end, { "n", "o" } },
      { "g?", function() require("leap.remote").action({ jumper = "?" }) end, { "n", "o" } },
      -- Remote K:
      -- {
      --   "g<M-k>",
      --   function()
      --     require("leap.remote").action({ input = "K" })
      --   end,
      --   desc = "Leap Remote K",
      -- },
      -- Remote gx:
      { "gX", function() require("leap.remote").action({ input = "gx" }) end, desc = "Leap Remote gx" },
      {
        "<leader>ol",
        function()
          require("leap.user").add_default_mappings()
          vim.notify("Leap mappings set to new defaults", vim.log.levels.INFO)
        end,
        desc = "Set leap mappings",
      },
      -- stylua: ignore end
    },
    opts = {
      equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
      -- equivalence_classes = { " \t\r\n", "([", ")]", "'\"`" },
      substitute_chars = { ["\r"] = "¬" },
      -- Three characters as arguments:
      --  - the character preceding the match (might be an empty string)
      --  - the matched pair itself
      preview_filter = config.preview_filter.exclude_whitespace_and_middle_alphanumeric_words,
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      -- require("leap.user").set_default_mappings()
      require("leap.user").set_repeat_keys("<enter>", "<backspace>")
      -- require("leap.user").set_repeat_keys(";", ".")

      config.always_show_labels_at_beginning_of_match()
      config.restore_default_hl("astrodark")

      experimental_features.one_char_search()

      if paste_on_remote_yank then
        vim.api.nvim_create_autocmd("User", {
          pattern = "RemoteOperationDone",
          group = vim.api.nvim_create_augroup("LeapRemote", {}),
          callback = function(event)
            -- Do not paste if some special register was in use.
            -- local cursor = vim.api.nvim_win_get_cursor(0)
            -- local char_at_cursor = vim.fn.getline(cursor[1]):sub(cursor[2], cursor[2])
            if vim.v.operator == "y" or vim.v.operator == "d" and event.data.register == "+" then
              -- if char_at_cursor:match("['\".]") ~= nil then vim.cmd("normal h") end
              if vim.fn.getreg("+") ~= nil then vim.cmd("normal! p") end
            end
          end,
        })
      end

      do
        -- Create remote versions of all a/i text objects by inserting `r` into
        -- the middle (`iw` becomes `irw`, etc.).
        for _, ai in ipairs({ "a", "i" }) do
          vim.keymap.set({ "x", "o" }, ai .. "r", function()
            -- A trick to avoid having to create separate mappings for each text
            -- object: when entering `ar`/`ir`, consume the next character, and
            -- create the input from that character concatenated to `a`/`i`.
            local ok, ch = pcall(vim.fn.getcharstr) -- pcall for handling <C-c>
            if not ok or (ch == vim.keycode("<esc>")) then return end
            require("leap.remote").action({ input = ai .. ch })
          end)
        end

        -- Add to whichkey
        require("which-key").add({
          { "ar", group = "remote" },
          { "ir", group = "remote" },
          { "r", group = "remote" },
          { "rr", desc = "line" },
          mode = { "o", "x" },
        }, { notify = false })
      end

      -- Remote lines
      -- A very handy custom mapping - remote line(s), with optional count (`yaa{leap}`, `y3aa{leap}`)
      vim.keymap.set({ "x", "o" }, "rr", function()
        -- Force linewise selection.
        local V = vim.fn.mode(true):match("V") and "" or "V"
        -- In any case, move horizontally, to trigger operations.
        local input = vim.v.count > 1 and (vim.v.count - 1 .. "j") or "hl"
        -- With `count=false` you can skip feeding count to the command
        -- automatically (we need -1 here, see above).
        require("leap.remote").action({ input = V .. input, count = false })
      end)
    end,
  },
  -- rename surround mappings from gs to gz to prevent conflict with leap
  {
    "nvim-mini/mini.surround",
    optional = true,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    keys = {
      { "gz", "", desc = "+surround" },
    },
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}
