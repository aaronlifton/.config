e- Custom MCP Server for Neovim helper functions
local mcphub = require("mcphub")

-- Add tools for buffer management
mcphub.add_tool("nvim_helper", {
  name = "buffer_stats",
  description = "Get statistics about the current buffer",
  handler = function(req, res)
    local bufnr = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(bufnr)
    local ft = vim.bo[bufnr].filetype
    local lines = vim.api.nvim_buf_line_count(bufnr)
    local words = 0

    -- Count words in buffer
    local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
    for _ in content:gmatch("%S+") do
      words = words + 1
    end

    local stats = {
      buffer_number = bufnr,
      file_name = name,
      filetype = ft,
      line_count = lines,
      word_count = words,
    }

    return res:text("Buffer Statistics:\n" .. vim.inspect(stats)):send()
  end,
})

-- Add tool for listing keymaps
mcphub.add_tool("nvim_helper", {
  name = "list_keymaps",
  description = "List keymaps for a specific mode",
  inputSchema = {
    type = "object",
    properties = {
      mode = {
        type = "string",
        description = "Vim mode (n, i, v, etc)",
        default = "n",
      },
    },
  },
  handler = function(req, res)
    local mode = req.params.mode or "n"
    local keymaps = vim.api.nvim_get_keymap(mode)

    -- Format the output
    local result = "Keymaps for mode '" .. mode .. "':\n"
    for _, map in ipairs(keymaps) do
      result = result .. map.lhs .. " → " .. (map.rhs or "[cmd]") .. "\n"
    end

    return res:text(result):send()
  end,
})

-- Add resource for Neovim version info
mcphub.add_resource("nvim_helper", {
  name = "version",
  uri = "nvim_helper://version",
  description = "Get Neovim version information",
  handler = function(req, res)
    local version = vim.version()
    local info = {
      major = version.major,
      minor = version.minor,
      patch = version.patch,
      prerelease = version.prerelease,
      build = vim.api.nvim_get_vvar("progpath"),
    }

    return res:text(vim.inspect(info)):send()
  end,
})

-- Add resource template for plugin info
mcphub.add_resource_template("nvim_helper", {
  name = "plugin_info",
  uriTemplate = "nvim_helper://plugin/{name}",
  description = "Get information about a specific plugin",
  handler = function(req, res)
    local plugin_name = req.params.name

    -- Check if plugin exists in runtimepath
    local rtp = vim.opt.runtimepath:get()
    local found = false
    local path = ""

    for _, dir in ipairs(rtp) do
      if dir:match(plugin_name) then
        found = true
        path = dir
        break
      end
    end

    if not found then return res:error("Plugin '" .. plugin_name .. "' not found in runtimepath") end

    return res:text("Plugin: " .. plugin_name .. "\nPath: " .. path):send()
  end,
})

-- Add a chat prompt
mcphub.add_prompt("nvim_helper", {
  name = "explain_option",
  description = "Explain a Neovim option",
  arguments = {
    {
      name = "option",
      description = "Neovim option name",
      required = true,
    },
  },
  handler = function(req, res)
    local option = req.params.option

    return res
      :user()
      :text("Explain the Neovim option: " .. option)
      :llm()
      :text("I'll explain the Neovim option '" .. option .. "' for you.")
      :send()
  end,
})

return true
