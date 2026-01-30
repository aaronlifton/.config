local M = {}

local function create_smart_picker()
  local fzf = nil
  local fzf_dp = nil
  local MiniVisits = require("mini.visits")

  local visit_paths = MiniVisits.list_paths()
  local current_file = vim.fn.expand("%")
  local cwd = vim.fn.getcwd()

  -- Get alternative file for priority boost
  local alt_file = vim.fn.expand("#")

  -- Get oldfiles scoped to current working directory
  local oldfiles = {}
  for _, file in ipairs(vim.v.oldfiles) do
    local abs_path = vim.fn.fnamemodify(file, ":p")
    if vim.startswith(abs_path, cwd) then table.insert(oldfiles, vim.fn.fnamemodify(file, ":.")) end
  end

  return function(local_opts, opts)
    local_opts = local_opts or {}
    opts = opts or {}

    local matcher = ((local_opts and local_opts.matcher) or (opts and opts.matcher) or "fzf")
    local auto_opts = vim.tbl_deep_extend("force", { threshold = 20000 }, (local_opts and local_opts.auto) or {})
    local fzf_opts = local_opts and local_opts.fzf or {}
    local function get_matcher(use_dp_matcher)
      if use_dp_matcher then
        if not fzf_dp then fzf_dp = require("util.minipick_registry.fzf_dp").new(fzf_opts) end
        return fzf_dp
      end
      if not fzf then fzf = require("util.minipick_registry.fzf").new(fzf_opts) end
      return fzf
    end

    local_opts = vim.tbl_extend("force", {
      custom_desc = "most visited",
      path_max_width = 80,
      -- path_truncate_mode = "head",
    }, local_opts)

    MiniPick.registry.fuzzy_files(
      local_opts,
      vim.tbl_extend("force", opts, {
        source = {
          match = function(stritems, indices, query)
            local prompt = table.concat(query)
            local tokens = vim.split(prompt, "%s+", { trimempty = true })
            local use_dp = matcher == "fzf_dp" or (matcher == "auto" and #indices <= (auto_opts.threshold or 20000))
            local matcher_impl = get_matcher(use_dp)

            local current_file_rel = vim.fn.fnamemodify(current_file, ":.")
            local alt_file_rel = alt_file ~= "" and vim.fn.fnamemodify(alt_file, ":.") or nil

            local oldfiles_lookup = {}
            for index, file_path in ipairs(oldfiles) do
              oldfiles_lookup[file_path] = index
            end

            local visits_lookup = {}
            for index, path in ipairs(visit_paths) do
              local key = vim.fn.fnamemodify(path, ":.")
              visits_lookup[key] = index
            end

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

              if matched then
                local score
                if path == current_file_rel then
                  score = -math.huge
                elseif alt_file_rel and path == alt_file_rel then
                  score = total_score + 10000
                elseif oldfiles_lookup[path] then
                  score = total_score + 1000 - oldfiles_lookup[path]
                elseif visits_lookup[path] then
                  score = total_score - visits_lookup[path]
                else
                  score = total_score - 100000
                end

                table.insert(result, { index = index, score = score })
              end
            end

            table.sort(result, function(a, b)
              if a.score == b.score then return a.index < b.index end
              return a.score > b.score
            end)

            return vim.tbl_map(function(item)
              return item.index
            end, result)
          end,
          name = "Smart",
        },
      })
    )
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.smart = create_smart_picker(MiniPick)
end

return M
