return setmetatable({}, {
  __index = function(t, key)
    local prompts = require("_prompt_library")
    -- Cache all prompts in the main table
    for k, v in pairs(prompts) do
      rawset(t, k, v)
    end
    -- Return the requested key
    return prompts[key]
  end,
})
