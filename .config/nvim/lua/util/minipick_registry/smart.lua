local M = {}

local function create_smart_picker()
  local MiniFuzzy = require("mini.fuzzy")
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

  return function()
    MiniPick.builtin.files(nil, {
      source = {
        match = function(stritems, indices, query)
          -- Concatenate prompt to a single string
          local prompt = vim.pesc(table.concat(query))

          -- If ignorecase is on and there are no uppercase letters in prompt,
          -- convert paths to lowercase for matching purposes
          local convert_path = function(str)
            return str
          end
          if vim.o.ignorecase and string.find(prompt, "%u") == nil then
            convert_path = function(str)
              return string.lower(str)
            end
          end

          local current_file_cased = convert_path(current_file)
          local alt_file_rel = alt_file ~= "" and vim.fn.fnamemodify(alt_file, ":.") or nil
          local alt_file_cased = alt_file_rel and convert_path(alt_file_rel) or nil

          -- Create lookup tables for priority files
          local oldfiles_lookup = {}
          for index, file_path in ipairs(oldfiles) do
            oldfiles_lookup[convert_path(file_path)] = index
          end

          local visits_lookup = {}
          for index, path in ipairs(visit_paths) do
            local key = vim.fn.fnamemodify(path, ":.")
            visits_lookup[convert_path(key)] = index
          end

          local result = {}
          for _, index in ipairs(indices) do
            local path = stritems[index]
            local path_cased = convert_path(path)
            local match_score = prompt == "" and 0 or MiniFuzzy.match(prompt, path).score

            if match_score >= 0 then
              local score

              -- Current file gets ranked last
              if path_cased == current_file_cased then
                score = 999999
              -- Alt file gets highest priority
              elseif alt_file_cased and path_cased == alt_file_cased then
                score = match_score - 10000
              -- Oldfiles get second priority
              elseif oldfiles_lookup[path_cased] then
                score = match_score - 1000 + oldfiles_lookup[path_cased]
              -- Visit paths get third priority
              elseif visits_lookup[path_cased] then
                score = match_score + visits_lookup[path_cased]
              -- Everything else
              else
                score = match_score + 100000
              end

              table.insert(result, {
                index = index,
                score = score,
              })
            end
          end

          table.sort(result, function(a, b)
            return a.score < b.score
          end)

          return vim.tbl_map(function(val)
            return val.index
          end, result)
        end,
        name = "Smart (fuzzy, most visited)",
      },
    })
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.smart = create_smart_picker(MiniPick)
end

return M
