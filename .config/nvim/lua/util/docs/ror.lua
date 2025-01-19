local job = require("plenary.job")
local curl = require("plenary.curl")

-- Ensure HTML parser is available
-- local parser = vim.treesitter.language.add("html")
-- if not parser then error("TreeSitter HTML parser not found. Please install it with :TSInstall html") end

---Parse HTML content and extract links from the "tree" class element
---@param html string The HTML content to parse
---@return table List of {text, href, level} entries from links in the tree
local function parse(html)
  local links = {}

  -- Create a TreeSitter parser and parse the HTML
  ---@type vim.treesitter.LanguageTree
  local parser = vim.treesitter.get_string_parser(html, "html")
  parser:parse(html)
  parser:for_each_tree(function(tree)
    print(tree)
    local root = tree:root()
    print(root)
  end)
end

local fetch = function(callback)
  curl.get("https://api.rubyonrails.org/", {
    callback = vim.schedule_wrap(function(response)
      if response.status ~= 200 then return callback(nil) end
      callback(response)
    end),
    on_error = function(error)
      log.error("(" .. alias .. ") Error during download, exit code: " .. error.exit)
    end,
  })
end

fetch(function(res)
  print(res)
  print(parse(res.body))
end)
