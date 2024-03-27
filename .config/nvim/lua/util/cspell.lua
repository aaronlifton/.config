local path = require("path")
local M = {}

function M.addWordToDictionary()
  local word = vim.fn.expand("<cword>")
  local dictionary_path = path.join(require("lazyvim.util.root").get(), "rules/cspell-dictionary.txt")

  -- Append the word to the dictionary file
  local file = io.open(dictionary_path, "a")
  if file then
    -- Detect new line at the end of the file or not
    local last_char = file:seek("end", -1)
    if last_char ~= nil and last_char ~= "\n" then
      word = "\n" .. word
    end

    file:write(word .. "")
    file:close()
    vim.notify("Added word to dictionary", vim.log.levels.INFO, { title = "cSpell" })

    -- Reload buffer to update the dictionary
    vim.cmd("e!")
  else
    vim.notify("Could not open cSpell dictionary", vim.log.levels.ERROR, { title = "cSpell" })
  end
end

return M
