local M = {}

function M.prompt(instruction)
  return "You are an AI programming assistant, utilizing the DeepSeek Coder model,"
    .. "developed by DeepSeek Company, and you only answer questions related to"
    .. "computer science. For politically sensitive questions, security and"
    .. "privacy issues, and other non-computer science questions, "
    .. "you will refuse to answer.\n"
    .. "### Instruction:\n"
    .. instruction
    .. "\n\n### Response:\n"
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
