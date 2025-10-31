function rel(args, get_relative_path)
  -- Resolve relative paths from the current Neovim cwd while offering a few
  -- fun alternate renderings (Markdown links, GitHub URLs).
  local cwd = vim.fn.getcwd()
  local cwd_abs = vim.fn.fnamemodify(cwd, ":p")
  local selected_abs_path = vim.fn.fnamemodify(args.selected_file, ":p")
  print(cwd)
  print(cwd_abs)
  print(selected_abs_path)

  local function is_within_dir(path, dir)
    local normalized_dir = dir:gsub("/+$", "")
    local normalized_path = path:gsub("/+$", "")
    if normalized_path == normalized_dir then return true end
    print(normalized_path)
    print(normalized_dir .. "/")
    return vim.startswith(normalized_path, normalized_dir .. "/")
  end

  local function default_fallback()
    return get_relative_path(args)
  end

  if not is_within_dir(selected_abs_path, cwd_abs) then
    -- Fall back to the configured resolver (grealpath) when the target
    -- file does not live inside the current working directory.
    print(1)
    return default_fallback()
  end
  print(2)

  print(args.selected_file)
  print(cwd)
  local relative_from_cwd = get_relative_path({
    selected_file = args.selected_file,
    source_dir = cwd,
  })
  print(relative_from_cwd)

  local mode = vim.g.yazi_relative_path_mode or "smart"

  local resolvers = require("util.yazi.resolvers")
  if vim.bo.filetype == "markdown" then mode = "markdown" end

  local Resolver = resolvers[mode]
  print(Resolver)
  if Resolver == nil then
    vim.notify(
      string.format("Yazi resolver mode '%s' not found, falling back to default", mode),
      vim.log.levels.WARN,
      { title = "Yazi" }
    )

    return relative_from_cwd
  else
    return Resolver.resolve(selected_abs_path, relative_from_cwd)
  end
end

local selected_file = "/Users/aaron/.local/share/nvim/lazy/yazi.nvim/lua/yazi/config.lua"
local source_dir = "~/.config/nvim"
local config = LazyVim.opts("yazi.nvim")
print(config)
local default_get_relative_path = function(arguments)
  return require("yazi.utils").relative_path(config.integrations.resolve_relative_path_application, arguments)
end
local x = rel({ selected_file = selected_file, source_dir = source_dir }, default_get_relative_path)
print(x)
