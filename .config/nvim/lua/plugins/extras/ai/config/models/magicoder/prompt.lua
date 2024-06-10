local M = {}

local prompt = function(instruction)
  -- return 'You are an exceptionally intelligent coding '..
  --   'assistant that consistently delivers accurate and '..
  --   'reliable responses to user instructions.\n\n' ..
  return "@@ Instruction\n" .. instruction .. "\n\n@@ Response\n"
end

---Format ChatContents to a string list so they can be individually tokenized.
---@param messages ChatMessage[]
---@param system string
---@return string[]
local function contents_to_strings(messages, system)
  local result = {
    system,
  }

  for _, msg in ipairs(messages) do
    table.insert(result, "\n<|" .. msg.role .. "|>\n" .. msg.content)
  end

  table.insert(result, "\n<|assistant|>\n")

  return result
end

return M
