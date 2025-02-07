---@class util.model.api
local M = {}

---@param name string
---@return Prompt
local get_prompt = function(name)
  local prompts = require("model").opts.prompts
  return prompts[name]
end

--- Calls the model provider to generate code completion prgrammatically
---@param prompt_name string Prompt name
---@param mode string Mode
---@param input string Input
---@param opts {visual: boolean} Options
M.prompt = function(prompt_name, mode, input, opts)
  opts = opts or {}

  if not input or input == "" then error("Input is required and cannot be empty") end

  local prompt_def = get_prompt(prompt_name)
  if not prompt_def then
    vim.notify(string.format("Prompt definition not found for '%s', using default", prompt_name), vim.log.levels.WARN)
    prompt_def = get_prompt("anthropic:claude-code") -- Use a default prompt
  end

  mode = mode or require("model").mode.INSERT_OR_REPLACE

  local provider_core = require("model.core.provider")
  local want_visual_selection = opts.visual or true

  local prompt_arg = {
    builder = prompt_def.builder,
    mode = mode,
    options = prompt_def.options,
    params = prompt_def.params,
    provider = prompt_def.provider,
  }
  return provider_core.request_completion(prompt_arg, input, want_visual_selection)
end

---@param prompt Prompt
---@param args string
---@param want_visual_selection boolean
function M.prompt_with_source(prompt_name, mode, input, source, opts)
  local old_get_source = require("model.core.input").get_source
  require("model.core.input").get_source = function(want_visual_selection)
    return source
  end

  local result = M.prompt(prompt_name, mode, input, { visual = true })
  require("model.core.input").get_source = old_get_source
  return result
end

-- model debugger
-- /nvim/lazy/model.nvim/lua/model/init.lua:104
-- vim.api.nvim_echo({
--   { 'prompt: ' .. vim.inspect(prompt), 'Normal' },
--   { '\nargs: ' .. vim.inspect(args), 'Normal' },
--   {
--     '\nwant_visual_selection: ' .. vim.inspect(want_visual_selection),
--     'Normal',
--   },
-- }, true, {})

return M
