local M = {}

function M.has_rubocop()
  return vim.fn.filereadable(".rubocop.yml") == 1
end

function M.has_ruby_lsp()
  -- .lsp/Gemfile is the custom bundleGemfile path
  return M.in_bundle("ruby-lsp") == true or vim.fn.filereadable(".lsp/Gemfile") == 1
end

function M.gemfile()
  return vim.fn.filereadable("Gemfile") == 1 and "Gemfile" or nil
end

function M.in_bundle(gemname)
  if M.bundle_cache ~= nil then
    return M.bundle_cache[gemname] == true
  else
    M.bundle_cache = M.bundle_cache or {}
    local gemfile = M.gemfile()
    if not gemfile then
      return false
    end

    local found = false
    for line in io.lines(gemfile) do
      --"  gem 'ruby-lsp-rails'":match('"([^"]+)"')

      local gem = line:match('"([^"]+)"') or line:match("'([^\"]+)'")
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
    return found == true
  end
end

function M.gem_version(gemname)
  -- TODO: support version number for non-bundler gems, default bundler = true param

  local gemfile = M.gemfile()
  if not gemfile then
    return
  end

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
