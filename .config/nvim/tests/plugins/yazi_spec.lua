local function get_yazi_key(spec, lhs)
  for _, key in ipairs(spec[2].keys) do
    if key[1] == lhs then return key[2] end
  end
end

describe("yazi launcher", function()
  local config_root = "/Users/aarron/.config/nvim"
  local original_Util
  local original_cmd
  local original_getcwd
  local original_buflisted
  local original_isdirectory
  local original_get_current_buf
  local original_patch_module
  local original_yazi_module

  before_each(function()
    original_Util = rawget(_G, "Util")
    original_cmd = vim.cmd
    original_getcwd = vim.fn.getcwd
    original_buflisted = vim.fn.buflisted
    original_isdirectory = vim.fn.isdirectory
    original_get_current_buf = vim.api.nvim_get_current_buf
    original_patch_module = package.loaded["util.yazi.patches.env"]
    original_yazi_module = package.loaded["yazi"]

    ---@diagnostic disable-next-line: missing-fields
    _G.Util = {
      ---@diagnostic disable-next-line: missing-fields
      path = {
        bufdir = function()
          return "/tmp/project/subdir"
        end,
      },
    }
  end)

  after_each(function()
    _G.Util = original_Util
    vim.cmd = original_cmd
    vim.fn.getcwd = original_getcwd
    vim.fn.buflisted = original_buflisted
    vim.fn.isdirectory = original_isdirectory
    vim.api.nvim_get_current_buf = original_get_current_buf
    package.loaded["util.yazi.patches.env"] = original_patch_module
    package.loaded["yazi"] = original_yazi_module
  end)

  it("opens from the buffer directory without mutating cwd and restores cwd on close", function()
    local patch_calls = 0
    local launch
    local cwd = "/tmp/original"
    local cd_calls = {}

    package.loaded["util.yazi.patches.env"] = {
      patch_yazi = function()
        patch_calls = patch_calls + 1
      end,
    }
    package.loaded["yazi"] = {
      yazi = function(config, input_path)
        launch = { config = config, input_path = input_path }
      end,
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.fn.getcwd = function()
      return cwd
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.fn.buflisted = function()
      return 1
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.fn.isdirectory = function(path)
      return path == "/tmp/project/subdir" and 1 or 0
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_get_current_buf = function()
      return 42
    end

    vim.cmd = function(cmd)
      cd_calls[#cd_calls + 1] = cmd
    end

    local spec = dofile(config_root .. "/lua/plugins/extras/editor/yazi.lua")
    get_yazi_key(spec, "<leader>fe")()

    assert.are.equal(1, patch_calls)
    assert.is_not_nil(launch)
    assert.are.equal("/tmp/project/subdir", launch.input_path)
    assert.is_false(launch.config.change_neovim_cwd_on_close)

    cwd = "/tmp/project/subdir/nested"
    launch.config.hooks.yazi_closed_successfully(nil, launch.config, {
      last_directory = { filename = cwd },
    })

    assert.are.same(1, #cd_calls)
    assert.are.same({ cmd = "cd", args = { "/tmp/original" } }, cd_calls[1])
  end)

  it("does not restore cwd when a file was chosen", function()
    local launch
    local cwd = "/tmp/original"
    local cd_calls = {}

    package.loaded["util.yazi.patches.env"] = {
      patch_yazi = function() end,
    }
    package.loaded["yazi"] = {
      yazi = function(config, input_path)
        launch = { config = config, input_path = input_path }
      end,
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.fn.getcwd = function()
      return cwd
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.fn.buflisted = function()
      return 1
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.fn.isdirectory = function()
      return 1
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_get_current_buf = function()
      return 42
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.cmd = function(cmd)
      cd_calls[#cd_calls + 1] = cmd
    end

    local spec = dofile(config_root .. "/lua/plugins/extras/editor/yazi.lua")
    get_yazi_key(spec, "<leader>fe")()

    cwd = "/tmp/project/subdir/nested"
    launch.config.hooks.yazi_closed_successfully("/tmp/project/subdir/file.txt", launch.config, {
      last_directory = { filename = cwd },
    })

    assert.are.same({}, cd_calls)
  end)
end)
