return {
  name = "jest run current file --inspect-brk",
  tags = { "test_file" },
  builder = function()
    return {
      cmd = {
        "node",
        "--inspect-brk",
        "node_modules/.bin/jest",
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
