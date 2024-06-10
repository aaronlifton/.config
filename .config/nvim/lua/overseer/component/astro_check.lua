local M = {
  output = nil,
}

function os.capture(cmd, raw)
  local handle = assert(io.popen(cmd, "r"))
  local output = assert(handle:read("*a"))
  handle:close()
  if raw then
    return output
  end
  output = string.gsub(string.gsub(string.gsub(output, "^%s+", ""), "%s+$", ""), "[\n\r]+", " ")
  return output
end

M.run_astro_check = function()
  -- M.output = os.capture("bun run astro check", true)
  local file = io.open("check.out", "r")
  if not file then
    print("No file")
  else
    local content = file:read("*all")
    M.output = content
    file:close()
  end
end

-- split output by lines with lua builtin functions only, no use of vim
local function split_lines(str)
  local lines = {}
  for s in str:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  return lines
end

local function find_errors(output)
  local lines = split_lines(output)
  local errors = {}
  for _, v in ipairs(lines) do
    if string.find(v, "error") and string.find(v, "src") then
      table.insert(errors, v)
    end
  end
  return errors
end

-- line =
-- "src/util/test.ts:9:24 - error ts(2345): Argument of type '(acc: T[], cur: T[]) => (T extends readonly (infer InnerArr)[] ? InnerArr : T)[][]' is not assignable to parameter of type '(previousValue: T[], currentValue: T[], currentIndex: number, array: T[][]) => T[]'."

M.parse_astro_check_error = function(line_text)
  local parts = {}
  for n in line_text:gmatch("[^%s]+") do
    table.insert(parts, n)
  end
  if #parts == 0 then
    return nil
  end
  local filename = parts[1]
  local severity = parts[3]
  local error_code = parts[4]
  local error_msg = parts[5]

  local data = {}
  local i = 1
  for substr in string.gmatch(filename, "([^:]+)") do
    table.insert(data, substr)
    i = i + 1
  end
  local message = error_code .. " " .. table.concat(table.pack(table.unpack(parts, 5, #parts)), " ")

  return {
    filename = data[1],
    col = data[2],
    lnum = data[3],
    message = message,
    severity = severity,
  }
end

M.parse_errors = function()
  local errors = find_errors(M.output)
  local parsed_errors = {}
  local start_idx = nil

  -- Skip the first 3 lines, which look like this:
  -- Output directory: /...
  -- 21:08:50 Types generated 176ms
  -- 21:08:50 [check] Getting diagnostics for Astro files in /...
  for i, v in ipairs(errors) do
    if string.find(v, "[check]") then
      start_idx = i
      break
    end
  end

  for i = start_idx, #errors do
    table.insert(parsed_errors, M.parse_astro_check_error(errors[i]))
  end
  M.parsed_errors = parsed_errors
  return M.parsed_errors
end

M.send_to_qlist = function()
  -- local errors = find_errors(M.output)
  -- local parsed_errors = {}
  -- for _, v in ipairs(errors) do
  --   table.insert(parsed_errors, M.parse_astro_check_error(v))
  -- end
  local parsed_errors = M.parsed_errors
  vim.fn.setqflist({}, " ", { title = "Astro Check Errors", items = parsed_errors })
end

M.clear = function()
  M.output = nil
  M.parsed_errors = nil
end
return {
  desc = "Runs Astro Check",
  params = {},
  editable = false,
  serializable = true,
  constructor = function(params)
    return {
      on_init = function() end,
      on_start = function()
        M.run_astro_check()
      end,
      on_preprocess_result = function()
        M.parse_errors()
      end,
      on_result = function()
        M.send_to_qlist()
      end,
      on_exit = M.clear,
      on_dispose = M.clear,
    }
  end,
}
