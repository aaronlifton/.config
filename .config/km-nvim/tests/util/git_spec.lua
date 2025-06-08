-- nvim -l ./tests/busted.lua tests
local git = require("util.git")
describe("Should not have", function()
  it("dd()", function()
    local res = git.commited_files_with_dates()
    print(vim.inspect(res))
    -- assert(vim.v.shell_error == 1, "Should not have dd()\n" .. out)
  end)
end)
