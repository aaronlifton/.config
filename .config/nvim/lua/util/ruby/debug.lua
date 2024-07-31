local M = {}
function M.start_ruby_debugger()
  vim.fn.setenv("RUBYOPT", "-rdebug/open")
  require("dap").continue()
end

function M.start_rspec_debugger2()
  local dap = require("dap")
  dap.adapters.ruby = function(callback, config)
    local script

    if config.current_line then
      script = config.script .. ":" .. vim.fn.line(".")
    else
      script = config.script
    end

    -- ❯ rdbg --open --port 38698 -c -- bundle exec rspec spec/controllers/web_api/client/listings_controller_spec.rb:1301
    callback({
      type = "server",
      host = "127.0.0.1",
      -- port = "${port}",
      port = "38698",
      executable = {
        command = "rdbg",
        args = { "--open", "--port", "${port}", "-c", "--", config.command, script },
      },
    })
  end
  vim.fn.setenv("RUBYOPT", "-rdebug/open")
  require("dap").run({
    type = "ruby",
    name = "run rspec current_file:current_line",
    command = "bundle",
    args = { "exec", "rspec" },
    current_line = true,
    request = "attach",
    script = "${file}",
    port = 38698,
    server = "127.0.0.1",
    localfs = true, -- required to be able to set breakpoints locally
    stopOnEntry = false, -- This has no effect
  })
end
function M.start_rspec_debugger()
  -- https://github.com/ruby/debug?tab=readme-ov-file#invoke-as-a-remote-debuggee
  vim.fn.setenv("RUBYOPT", "-rdebug/open_nonstop")
  require("dap").run({
    type = "ruby",
    name = "debug current rspec file",
    request = "attach",
    command = "rspec",
    script = "${file}",
    port = 38698, -- TODO: might be nice to make sure this port is open
    server = "127.0.0.1",
    localfs = true, -- required to be able to set breakpoints locally
    waiting = 100, -- HACK: This is a race condition with the set RUBYOPT, if you get ECONNREFUSED try changing RUBYOPT to -rdebug/open
  })
end

return M
