return {
  name = "jest run current file --inspect-brk",
  tags = { "test_file" },
  builder = function()
    local Path = require("plenary.path")
    local file_path_abs = Path:new(vim.fn.expand("%:p"))
    local file_path_rel = file_path_abs:normalize(vim.fn.getcwd())
    -- local current_line = vim.fn.line(".")
    -- local file_line = file_path_rel .. ":" .. tostring(current_line)

    -- APP_ENV=development TZ=utc node --inspect-brk node_modules/.bin/jest --projects src/jest.config.rtl.js --colors  src/components/Settings/Global/ScanSettings/__tests__/index-test.rtl.js

    return {
      cmd = {
        "node",
        "--inspect-brk",
        "node_modules/.bin/jest",
        "--projects",
        "src/jest.config.rtl.js",
        "--no-coverage",
        "--colors",
        vim.fn.expand("%:p"),
      },
      env = {
        TZ = "utc",
        APP_ENV = "development",
      },
      components = { "on_complete_notify", "on_complete_dispose", "default" },
    }
  end,
}
