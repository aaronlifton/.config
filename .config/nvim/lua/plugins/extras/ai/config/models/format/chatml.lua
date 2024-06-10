---Format ChatContents to a string list so they can be individually tokenized.
---reference: https://huggingface.co/HuggingFaceH4/zephyr-7b-beta
---@param messages ChatMessage[]
---@param system string
---@return string[]
local function contents_to_strings(messages, system)
  local result = {
    "<|im_start|>system\n" .. system .. "\n<|im_end|>",
  }

  for _, msg in ipairs(messages) do
    table.insert(result, "<|im_start|>" .. msg.role .. "\n" .. msg.content .. "<|im_end|>")
  end

  table.insert(result, "<|im_start|>assistant\n")

  return result
end

return {
  chat = function(messages, config)
    return {
      prompt = table.concat(contents_to_strings(messages, config.system or "You are a helpful assistant")),
    }
  end,
}
