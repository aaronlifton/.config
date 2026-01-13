local M = {}

-- Helpers
local H = {}

-- Predefined fd exclude patterns
H.fd_exclude_patterns = {
  no_tests = { "spec/**/*", "**{__tests__,tests?}**", "{test,tests}/" },
}

-- Predefined fd flags
H.fd_flags = {
  ext_lua = "-e lua",
  ext_rb = "-e rb",
  newer = "--changed-within 7d",
}

local function create_fuzzy_files_picker()
  -- Example override:
  -- MiniPick.registry.fuzzy_files({
  --   matcher = "auto", -- "fzf" | "fzf_dp" | "auto"
  --   fzf = { smartcase = false, filename_bonus = false },
  --   auto = { threshold = 20000 },
  -- }, {})
  return function(local_opts, opts)
    local matcher = ((local_opts and local_opts.matcher) or (opts and opts.matcher) or "fzf")
    local auto_opts = vim.tbl_deep_extend(
      "force",
      { threshold = 20000 },
      (local_opts and local_opts.auto) or {},
      (opts and opts.auto) or {}
    )
    local fzf_opts = vim.tbl_deep_extend("force", {}, (local_opts and local_opts.fzf) or {}, (opts and opts.fzf) or {})

    local fzf = nil
    local dp = nil
    local function get_matcher(use_dp)
      if use_dp then
        if not dp then dp = require("util.minipick_registry.fzf_dp").new(fzf_opts) end
        return dp
      end
      if not fzf then fzf = require("util.minipick_registry.fzf").new(fzf_opts) end
      return fzf
    end

    -- State for toggleable options
    local excludes = vim.deepcopy((local_opts and local_opts.excludes) or {})
    local flags = vim.deepcopy((local_opts and local_opts.fd_flags) or {})

    local function build_name_suffix()
      local parts = {}
      if #excludes > 0 then parts[#parts + 1] = "excl:" .. #excludes end
      local flag_parts = {}
      for key, enabled in pairs(flags) do
        if enabled then flag_parts[#flag_parts + 1] = key end
      end
      if #flag_parts > 0 then parts[#parts + 1] = table.concat(flag_parts, ",") end
      return #parts == 0 and "" or (" | " .. table.concat(parts, " | "))
    end

    local function build_name()
      local suffix = build_name_suffix()
      if opts.source and opts.source.name then
        return ("%s (fuzzy, %s%s)"):format(opts.source.name, matcher, suffix)
      end
      return ("Files (fuzzy, %s%s)"):format(matcher, suffix)
    end

    local function build_fd_command()
      local cmd = { "fd", "--type", "f", "--color", "never", "--hidden", "--follow", "--exclude", ".git" }
      -- Add excludes
      for _, pattern in ipairs(excludes) do
        table.insert(cmd, "--exclude")
        table.insert(cmd, pattern)
      end
      -- Add flags
      for key, enabled in pairs(flags) do
        if enabled and H.fd_flags[key] then
          for _, part in ipairs(vim.split(H.fd_flags[key], "%s+", { trimempty = true })) do
            table.insert(cmd, part)
          end
        end
      end
      return cmd
    end

    local name = build_name()
    local cwd = (opts.source and opts.source.cwd) or vim.fn.getcwd()
    local spawn_opts = { cwd = cwd }
    local set_items_opts = { do_match = false }
    local process

    local function refresh_items()
      ---@diagnostic disable-next-line: undefined-field
      pcall(vim.loop.process_kill, process)
      local command = build_fd_command()
      process = MiniPick.set_picker_items_from_cli(command, {
        set_items_opts = set_items_opts,
        spawn_opts = spawn_opts,
      })
    end

    local function toggle_fd_exclude_patterns(pattern_key)
      return function()
        local patterns = H.fd_exclude_patterns[pattern_key]
        if not patterns then return end
        -- Check if all patterns are present
        local all_present = true
        for _, pattern in ipairs(patterns) do
          local found = false
          for _, e in ipairs(excludes) do
            if e == pattern then
              found = true
              break
            end
          end
          if not found then
            all_present = false
            break
          end
        end
        if all_present then
          -- Remove all patterns
          for _, pattern in ipairs(patterns) do
            for i = #excludes, 1, -1 do
              if excludes[i] == pattern then
                table.remove(excludes, i)
                break
              end
            end
          end
        else
          -- Add missing patterns
          for _, pattern in ipairs(patterns) do
            local found = false
            for _, e in ipairs(excludes) do
              if e == pattern then
                found = true
                break
              end
            end
            if not found then table.insert(excludes, pattern) end
          end
        end
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_items()
      end
    end

    local function toggle_fd_flag(flag_key)
      return function()
        flags[flag_key] = not flags[flag_key]
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_items()
      end
    end

    -- Mnemonics (from fzf-extended.lua):
    --   alt-x: exclude tests/specs
    --   alt-l: lua extension
    --   alt-r: ruby extension
    --   alt-n: newer (within 7 days)

    local mappings = {
      toggle_no_tests = { char = "<M-x>", func = toggle_fd_exclude_patterns("no_tests") },
      toggle_ext_lua = { char = "<M-l>", func = toggle_fd_flag("ext_lua") },
      toggle_ext_rb = { char = "<M-r>", func = toggle_fd_flag("ext_rb") },
      toggle_newer = { char = "<M-n>", func = toggle_fd_flag("newer") },
    }

    MiniPick.builtin.files(
      nil,
      vim.tbl_deep_extend("force", local_opts or {}, opts or {}, {
        source = {
          match = function(stritems, indices, query)
            local prompt = table.concat(query)
            if prompt == "" then return indices end
            local tokens = vim.split(prompt, "%s+", { trimempty = true })
            if #tokens == 0 then return indices end

            local use_dp = matcher == "fzf_dp" or (matcher == "auto" and #indices <= (auto_opts.threshold or 20000))
            local matcher_impl = get_matcher(use_dp)

            local result = {}
            for _, index in ipairs(indices) do
              local path = stritems[index]
              local total_score = 0
              local matched = true

              for _, token in ipairs(tokens) do
                local score = matcher_impl:match_score(path, token, { is_file = true })
                if not score then
                  matched = false
                  break
                end
                total_score = total_score + score
              end

              if matched then table.insert(result, { index = index, score = total_score }) end
            end

            table.sort(result, function(a, b)
              if a.score == b.score then return a.index < b.index end
              return a.score > b.score
            end)

            return vim.tbl_map(function(item)
              return item.index
            end, result)
          end,
          choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked,
          name = name,
        },
        mappings = mappings,
      })
    )
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.fuzzy_files = create_fuzzy_files_picker(MiniPick)
end

return M
