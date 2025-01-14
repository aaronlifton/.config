---@class util.git.github
local M = {}

--- Resolves a local gem path to its GitHub URL
---@param filepath string The full path to a gem file
---@return string|nil url The GitHub URL if successful
---@return string|nil error Error message if failed
function M.resolve_github_url_from_gem_path(filepath)
  -- Extract gem name and version from path
  local gem_pattern = ".+/gems/([^/]+)%-([%d%.]+)/(.+)"
  local gem_name, version, rel_path = filepath:match(gem_pattern)

  if not gem_name or not version then return nil, "Could not extract gem name and version from path" end

  -- Split the line number if present
  local file_path, line_num = rel_path:match("([^:]+):?(%d*)")
  local line_suffix = line_num and "#L" .. line_num or ""

  -- Known mappings of gem names to GitHub repos
  local known_repos = {
    ["devise"] = "heartcombo/devise",
  }

  local repo = known_repos[gem_name]
  if not repo then
    vim.ui.input({ prompt = "account/repo" }, function(input)
      if input == nil then return end
      repo = input
    end)
  end

  if not repo then
    return nil,
      string.format("GitHub repository mapping not found for gem '%s'. Please add mapping for 'owner/repo'", gem_name)
  end

  return string.format("https://github.com/%s/blob/v%s/%s%s", repo, version, file_path, line_suffix)
end

return M
