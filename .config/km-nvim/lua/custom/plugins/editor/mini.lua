-- Simplified implementations extracted from mini.deps source
local exec_errors = {}
local later_callback_queue = {}
local finish_is_scheduled = false

local function schedule_finish()
  if finish_is_scheduled then return end
  vim.schedule(function()
    local timer, step_delay = vim.loop.new_timer(), 1
    local f = nil
    f = vim.schedule_wrap(function()
      local callback = later_callback_queue[1]
      if callback == nil then
        finish_is_scheduled = false
        later_callback_queue = {}
        -- Report any errors
        if #exec_errors > 0 then
          local error_lines = table.concat(exec_errors, "\n\n")
          exec_errors = {}
          vim.notify("There were errors during execution:\n\n" .. error_lines, vim.log.levels.ERROR)
        end
        return
      end

      table.remove(later_callback_queue, 1)
      local ok, err = pcall(callback)
      if not ok then table.insert(exec_errors, err) end
      timer:start(step_delay, 0, f)
    end)
    timer:start(step_delay, 0, f)
  end)
  finish_is_scheduled = true
end

local function now(f)
  local ok, err = pcall(f)
  if not ok then table.insert(exec_errors, err) end
  schedule_finish()
end

local function later(f)
  table.insert(later_callback_queue, f)
  schedule_finish()
end

return {
  setup = function()
    local map_multistep = require("mini.keymap").map_multistep
    local map_combo = require("mini.keymap").map_combo
    local copilot_accept = {
      condition = function()
        return package.loaded["copilot"] and require("copilot.suggestion").is_visible()
      end,
      action = function()
        require("copilot.suggestion").accept()
      end,
    }

    -- Support most common modes. This can also contain 't', but would
    -- only mean to press `<Esc>` inside terminal.
    local mode = { "i", "c", "x", "s" }
    map_combo(mode, "jk", "<BS><BS><Esc>")

    -- To not have to worry about the order of keys, also map "kj"
    map_combo(mode, "kj", "<BS><BS><Esc>")

    -- Escape into Normal mode from Terminal mode
    map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
    map_combo("t", "kj", "<BS><BS><C-\\><C-n>")

    local function super_tab()
      local km = require("mini.keymap")

      km.map_multistep("i", "<tab>", {
        "jump_after_tsnode",
        "jump_after_close",
      })

      km.map_multistep("i", "<s-tab>", {
        "jump_before_tsnode",
        "jump_before_open",
      })
    end

    -- Setup mini.statusline immediately
    now(function()
      require("mini.statusline").setup({
        use_icons = true,
        content = {
          inactive = function()
            local pathname = Config.section_pathname({ trunc_width = 120 })
            return MiniStatusline.combine_groups({
              { hl = "MiniStatuslineInactive", strings = { pathname } },
            })
          end,
          active = function()
            -- stylua: ignore start
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git           = MiniStatusline.section_git({ trunc_width = 40 })
            local diff          = MiniStatusline.section_diff({ trunc_width = 80 })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 60 })
            local lsp           = MiniStatusline.section_lsp({ trunc_width = 40 })
            local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 100 })
            local filetype      = Config.section_filetype({ trunc_width = 70 })
            local location      = Config.section_location({ trunc_width = 120 })
            local search        = Config.section_searchcount({ trunc_width = 80 })
            local pathname      = Config.section_pathname({
              trunc_width = 100,
              filename_hl = "MiniStatuslineFilename",
              modified_hl = "MiniStatuslineFilenameModified" })

              -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
              -- correct padding with spaces between groups (accounts for 'missing'
              -- sections, etc.)
              return MiniStatusline.combine_groups({
                { hl = mode_hl,                   strings = { mode:upper() } },
                { hl = 'MiniStatuslineDevinfo',   strings = { git, diff } },
                '%<', -- Mark general truncate point
                { hl = 'MiniStatuslineDirectory', strings = { pathname } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineFileinfo',  strings = { diagnostics, filetype, lsp } },
                { hl = mode_hl,                   strings = { search .. location } },
                { hl = 'MiniStatuslineDirectory', strings = {} },
              })
            -- stylua: ignore end
          end,
        },
      })
    end)

    -- Setup mini.bracketed later
    later(function()
      require("mini.bracketed").setup()

      local clues = {}
      for target, opts in pairs(MiniBracketed.config) do
        local lower_suffix = opts.suffix
        local upper_suffix = opts.suffix:upper()
        local replacements = {
          ["["] = { old = "first", new = "forward" },
          ["]"] = { old = "last", new = "backward" },
        }

        for bracket, pattern in pairs(replacements) do
          -- Use hydra mode for all bracketed targets
          table.insert(clues, { mode = "n", keys = bracket .. lower_suffix, postkeys = bracket })
          table.insert(clues, { mode = "n", keys = bracket .. upper_suffix, postkeys = bracket })

          -- Make uppercase navigate in other direction instead of first/last
          local map = vim.fn.maparg(bracket .. upper_suffix, "n", false, true)
          local new_rhs = map.rhs:gsub(pattern.old, pattern.new)
          local new_desc = map.desc:gsub(pattern.old, pattern.new)
          vim.keymap.set("n", bracket .. upper_suffix, new_rhs, { desc = new_desc })
        end
      end

      -- These will be used later when mini.clues is setup
      _G.Config.bracketed_clues = clues
    end)

    -- Setup mini.keymap later
    later(function()
      local map_multistep = require("mini.keymap").map_multistep
      local copilot_accept = {
        condition = function()
          return vim.g.kaz_copilot and require("copilot.suggestion").is_visible()
        end,
        action = function()
          require("copilot.suggestion").accept()
        end,
      }

      map_multistep("i", "<Tab>", { copilot_accept, "minisnippets_next", "increase_indent", "jump_after_close" })
      map_multistep("i", "<S-Tab>", { "minisnippets_prev", "decrease_indent", "jump_before_open" })
      map_multistep("i", "<CR>", { "blink_accept", "pmenu_accept", "nvimautopairs_cr" })
      map_multistep("i", "<BS>", { "nvimautopairs_bs" })

      local notify_many_keys = function(key)
        local lhs = string.rep(key, 5)
        local action = function()
          vim.notify("Too many " .. key)
        end
        require("mini.keymap").map_combo({ "n", "x" }, lhs, action)
      end
      notify_many_keys("h")
      notify_many_keys("j")
      notify_many_keys("k")
      notify_many_keys("l")
    end)

    -- Setup mini.snippets later
    later(function()
      local snippets = require("mini.snippets")
      snippets.setup({
        snippets = {
          snippets.gen_loader.from_file("~/.config/minivim/snippets/global.json"),
          snippets.gen_loader.from_file("~/.config/minivim/snippets/mini-test.json"),
          snippets.gen_loader.from_lang(),
        },
      })
    end)
  end,
}
