local M = {}

-- Helper function to detect language from file extension
local function detect_language(filepath)
  if not filepath then return "text" end

  local ext = filepath:match("%.([^%.]+)$")
  if not ext then return "text" end

  local language_map = {
    go = "go",
    js = "javascript",
    ts = "typescript",
    py = "python",
    lua = "lua",
    rb = "ruby",
    java = "java",
    cpp = "cpp",
    c = "c",
    rs = "rust",
    php = "php",
    sh = "bash",
    sql = "sql",
    json = "json",
    yaml = "yaml",
    yml = "yaml",
    xml = "xml",
    html = "html",
    css = "css",
  }

  return language_map[ext:lower()] or "text"
end

-- Helper function to format code block
local function format_code_block(code, language, filepath)
  if not code or code == "" then return "No code provided" end

  local lang = language or detect_language(filepath)
  return string.format("```%s\n%s\n```", lang, code)
end

-- Helper function to format file list
local function format_helper_files(helper_files)
  if not helper_files or #helper_files == 0 then return "No helper files specified" end

  local formatted = {}
  for _, file in ipairs(helper_files) do
    table.insert(formatted, string.format("- `%s`", file))
  end

  return table.concat(formatted, "\n")
end

-- Main prompt generator
---@param args table Configuration for prompt generation
---@param args.old_endpoint_code string The source code of the old endpoint
---@param args.old_endpoint_file string Path to the old endpoint file
---@param args.target_file string Path where the new implementation should go
---@param args.helper_files string[] List of helper files with relevant functions
---@param args.language? string Override language detection for code blocks
---@param args.instructions? string Additional specific instructions
---@param args.context? string Additional context about the changes needed
---@return string The formatted prompt
function M.generate_prompt(args)
  local old_endpoint_code = args.old_endpoint_code or ""
  local old_endpoint_file = args.old_endpoint_file or ""
  local target_file = args.target_file or ""
  local helper_files = args.helper_files or {}
  local language = args.language
  local instructions = args.instructions or ""
  local context = args.context or ""

  -- Build the prompt sections
  local sections = {}

  -- Header with context
  table.insert(sections, "This is the old endpoint that we are copying and making better:")
  table.insert(sections, "")

  -- Old endpoint code
  if old_endpoint_code ~= "" then
    table.insert(sections, format_code_block(old_endpoint_code, language, old_endpoint_file))
  else
    table.insert(sections, "No old endpoint code provided")
  end

  table.insert(sections, "")

  -- Implementation request
  if target_file ~= "" then
    table.insert(sections, string.format("Can you please implement it in this file (%s)?", target_file))
  else
    table.insert(sections, "Can you please implement this?")
  end

  table.insert(sections, "")

  -- Helper files section
  if #helper_files > 0 then
    table.insert(sections, "Helper files with relevant functions:")
    table.insert(sections, format_helper_files(helper_files))
    table.insert(sections, "")
  end

  -- Additional context
  if context ~= "" then
    table.insert(sections, "Additional context:")
    table.insert(sections, context)
    table.insert(sections, "")
  end

  -- Specific instructions
  if instructions ~= "" then
    table.insert(sections, "Remember:")
    table.insert(sections, instructions)
  end

  return table.concat(sections, "\n")
end

-- Convenience function for common Go endpoint scenarios
---@param args table
---@param args.old_code string Go code of the old endpoint
---@param args.old_file string Path to old endpoint file
---@param args.new_file string Path to new implementation file
---@param args.auth_helpers? string[] List of auth helper functions available
---@param args.additional_context? string Extra context
---@return string Formatted prompt
function M.generate_go_endpoint_prompt(args)
  local auth_instructions =
    "For auth stuff, we don't need to write code to check scope since that happens in middleware, and try to use the auth helper functions we have"

  if args.auth_helpers and #args.auth_helpers > 0 then
    local helpers = {}
    for _, helper in ipairs(args.auth_helpers) do
      table.insert(helpers, string.format("`%s`", helper))
    end
    auth_instructions = auth_instructions .. " like " .. table.concat(helpers, ", ")
  end

  return M.generate_prompt({
    old_endpoint_code = args.old_code,
    old_endpoint_file = args.old_file,
    target_file = args.new_file,
    helper_files = args.auth_helpers or {},
    language = "go",
    instructions = auth_instructions,
    context = args.additional_context,
  })
end

return M
