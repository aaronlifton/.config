local function get_key(spec, lhs)
  for _, key in ipairs(spec[2].keys) do
    if key[1] == lhs then return key[2] end
  end
end

describe("snacks explorer extended", function()
  local config_root = "/Users/aarron/.config/nvim"
  local original_Snacks
  local original_LazyVim
  local original_api
  local original_bo
  local original_uv
  local original_fs

  before_each(function()
    original_Snacks = rawget(_G, "Snacks")
    original_LazyVim = rawget(_G, "LazyVim")
    original_api = vim.api
    original_bo = vim.bo
    original_uv = vim.uv
    original_fs = vim.fs

    vim.api = vim.tbl_extend("force", {}, original_api, {
      nvim_get_current_buf = function()
        return 1
      end,
      nvim_list_wins = function()
        return {}
      end,
    })

    vim.bo = setmetatable({}, {
      __index = function()
        return { filetype = "fish" }
      end,
    })

    vim.uv = vim.tbl_extend("force", {}, original_uv, {
      os_homedir = function()
        return "/Users/aarron"
      end,
    })

    vim.fs = vim.tbl_extend("force", {}, original_fs, {
      dirname = function(path)
        return path:match("(.+)/[^/]+$")
      end,
    })
  end)

  after_each(function()
    _G.Snacks = original_Snacks
    _G.LazyVim = original_LazyVim
    vim.api = original_api
    vim.bo = original_bo
    vim.uv = original_uv
    vim.fs = original_fs
  end)

  it("opens fish files from the ~/.config app root when LazyVim falls back to cwd", function()
    local explorer_calls = {}
    local reveal_calls = {}

    ---@diagnostic disable-next-line: missing-fields
    _G.LazyVim = {
      root = {
        bufpath = function(buf)
          assert.are.equal(1, buf)
          return "/Users/aarron/.config/fish/functions/find-file-in-branches.fish"
        end,
        get = function()
          return "/Users/aarron/Code/repconnex"
        end,
        cwd = function()
          return "/Users/aarron/Code/repconnex"
        end,
        realpath = function(path)
          return path
        end,
      },
    }

    ---@diagnostic disable-next-line: missing-fields
    _G.Snacks = {
      picker = {
        get = function()
          return {}
        end,
      },
      explorer = setmetatable({
        reveal = function(opts)
          reveal_calls[#reveal_calls + 1] = opts
        end,
      }, {
        __call = function(_, opts)
          explorer_calls[#explorer_calls + 1] = opts
        end,
      }),
    }

    local spec = dofile(config_root .. "/lua/plugins/extras/editor/snacks-explorer-extended.lua")
    get_key(spec, "<M-e>")()

    assert.are.same(1, #explorer_calls)
    assert.are.equal("/Users/aarron/.config/fish", explorer_calls[1].cwd)
    assert.are.same(1, #reveal_calls)
    assert.are.equal(1, reveal_calls[1].buf)
  end)
end)
