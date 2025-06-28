local M = {}

--- Read specific lines from a file
---@param filepath string
---@param start_line number
---@param end_line number
---@return string
local function read_lines(filepath, start_line, end_line)
  local lines = {}
  local current_line = 1
  for line in io.lines(filepath) do
    if current_line >= start_line and current_line <= end_line then
      table.insert(lines, line)
    elseif current_line > end_line then
      break
    end
    current_line = current_line + 1
  end
  return table.concat(lines, "\n")
end

--- Generate a prompt for copying an old endpoint to a new repo.
---@param args { old_file: string, start_line: number, end_line: number, new_file: string, helper_files: string[] }
---@return string
function M.generate_copy_endpoint_prompt(args)
  local old_file = args.old_file
  local start_line = args.start_line
  local end_line = args.end_line
  local new_file = args.new_file
  local helper_files = args.helper_files or {}

  local old_code = read_lines(old_file, start_line, end_line)

  local formatted_helpers = ""
  for _, file in ipairs(helper_files) do
    formatted_helpers = formatted_helpers .. string.format("`%s` ", file)
  end

  local prompt = string.format(
    [[
This is the old endpoint that we are copying and making better:
 
```go
%s
```
 
Can you please implement it in this file (%s)?

Remember:
  - For auth stuff, we don't need to write code to check scopes since that happens in middleware.
  - Try to use the auth helper functions we have like `AuthorizedForAssetRead` located in %s.
  - We are migrating the queries from gorm to go-jet and maingg other improvements like returning proper status codes.
]],
    old_code,
    new_file,
    formatted_helpers
  )

  return prompt
end

local function test_usage()
  local prompt_generator = require("util.prompt_generator")

  local prompt = prompt_generator.generate_copy_endpoint_prompt({
    old_file = "/Users/alifton/synack/asset-v2/internal/pkg/api/service_user_role_credential_user_put.go",
    start_line = 10,
    end_line = 55,
    new_file = "/Users/alifton/synack/client-modulith/modules/asset-service/v2/internal/impl/standard/server/user_role_credential.go",
    helper_files = {
      "/Users/alifton/synack/client-modulith/modules/asset-service/v2/internal/impl/standard/service/service.go",
    },
  })

  print(prompt)
end
return M
