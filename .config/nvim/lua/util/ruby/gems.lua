local M = {}

function M.has_rubocop()
  return vim.fn.filereadable(".rubocop.yml") == 1
end

function M.has_ruby_lsp()
  return M.in_bundle("ruby-lsp")
end

function M.gemfile()
  return vim.fn.filereadable("Gemfile") == 1 and "Gemfile" or nil
end

function M.in_bundle(gemname)
  if M.bundle_cache ~= nil then
    return M.bundle_cache[gemname]
  else
    M.bundle_cache = M.bundle_cache or {}
    local gemfile = M.gemfile()
    if not gemfile then
      return
    end

    local found = false
    for line in io.lines(gemfile) do
      local gem = line:match('"([^"]+)"')
      if gem then
        M.bundle_cache[gem] = true

        -- if string.find(line, gemname) then
        if gem == gemname then
          found = true
          break
        end
      end
    end

    M.bundle_cache[gemname] = found
    return found
  end
end

function M.gem_version(gemname)
  -- TODO: support version number for non-bundler gems, default bundler = true param

  local gemfile = M.gemfile()
  if not gemfile then
    return
  end

  -- local version = nil
  --
  -- for line in io.lines(gemfile) do
  --   if string.find(line, "%s+" .. gemname .. " %(") then
  --     version = string.match(line, "%((.-)%)")
  --     break
  --   end
  -- end

  local cmd = string.format(
    [[bundle info %s  | awk -F'[( )]' '{for(i=1;i<=NF;i++) if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+$/) print $i}']],
    gemname
  )
  return vim.fn.system(cmd)
end

function M.rubocop_supports_lsp()
  local version = M.gem_version("rubocop")

  -- rubocop lsp was added in v1.53.0
  return version and vim.version.ge(version, { 1, 53, 0 })
end

return M
