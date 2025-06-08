return {
  name = "rdbg run rspec current file:line",
  tags = { "test_file" },
  builder = function()
    local Path = require("plenary.path")
    local file_path_abs = Path:new(vim.fn.expand("%:p"))
    local file_path_rel = file_path_abs:normalize(vim.fn.getcwd())
    local current_line = vim.fn.line(".")
    local file_line = file_path_rel .. ":" .. tostring(current_line)

    -- rdbg -n --open --port 38698 -c -- bundle exec rspec spec/controllers/web_api/client/listings_controller_spec.rb:1327
    -- local stdout = vim.uv.new_pipe(false)
    -- handle, pid_or_err = vim.uv.spawn("rdbg", {
    --   args = { "-n", "--open", "--port", "38698", "-c", "--", "bundle", "exec", "rspec", file_line },
    --   stdio = { nil, stdout },
    -- }, function(code, signal) -- on exit
    --   if handle then
    --     handle:close()
    --   end
    --   if code ~= 0 then
    --     error("rdbg exited with code " .. code)
    --   end
    --   print("exit code", code)
    --   print("exit signal", signal)
    -- end)
    --
    -- assert(handle, "Error running rdbg: " .. tostring(pid_or_err))

    return {
      cmd = {
        "rdbg",
        "-n",
        "--open",
        "--port",
        "38698",
        "-c",
        "--",
        "bundle",
        "exec",
        "rspec",
        file_line,
      },
      components = { "on_complete_notify", "on_complete_dispose", "default" },
    }
  end,
}
