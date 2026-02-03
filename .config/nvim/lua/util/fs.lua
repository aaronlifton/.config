---@class util.fs
local M = {}

---Write content to a /tmp file asynchronously and open it in a vsplit.
---@param content string
---@return string tmp_path
function M.debug_tmp(content)
  local uv = vim.uv or vim.loop
  local tmp_path = string.format("/tmp/nvim-%d-%d.tmp", vim.fn.getpid(), uv.hrtime())
  local data = content or ""

  uv.fs_open(tmp_path, "w", 384, function(open_err, fd)
    if open_err then
      vim.schedule(function()
        vim.notify("Failed to open tmp file: " .. open_err, vim.log.levels.ERROR)
      end)
      return
    end

    uv.fs_write(fd, data, 0, function(write_err)
      uv.fs_close(fd, function(close_err)
        local err = write_err or close_err
        if err then
          vim.schedule(function()
            vim.notify("Failed to write tmp file: " .. err, vim.log.levels.ERROR)
          end)
          return
        end

        vim.schedule(function()
          vim.cmd("vsplit " .. vim.fn.fnameescape(tmp_path))
        end)
      end)
    end)
  end)

  return tmp_path
end

return M
