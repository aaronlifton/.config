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

  if not gem_name or not version then
    vim.notify("Could not extract gem name and version from path", vim.log.levels.ERROR)
    return nil, "Could not extract gem name and version from path"
  end

  -- Split the line number if present
  local file_path, line_num = rel_path:match("([^:]+):?(%d*)")
  local line_suffix = line_num and "#L" .. line_num or ""

  -- Known mappings of gem names to GitHub repos
  local known_repos = {
    ["devise"] = "heartcombo/devise",
    ["with_advisory_lock"] = "ClosureTree/with_advisory_lock",
  }

  local repo = known_repos[gem_name]

  if not repo then
    local message = "GitHub repository mapping not found for gem '%s'. Please add mapping for 'owner/repo'"
    vim.notify(string.format(message, gem_name), vim.log.levels.ERROR)
    return nil, string.format(message, gem_name)
  end

  return string.format("https://github.com/%s/blob/v%s/%s%s", repo, version, file_path, line_suffix)
end

return M
