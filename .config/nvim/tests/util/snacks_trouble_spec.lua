describe("util.snacks.trouble", function()
  local config_root = "/Users/aarron/.config/nvim"
  local original_schedule
  local original_trouble_item
  local original_trouble_source
  local original_trouble

  before_each(function()
    original_schedule = vim.schedule
    original_trouble_item = package.loaded["trouble.item"]
    original_trouble_source = package.loaded["trouble.sources.snacks"]
    original_trouble = package.loaded["trouble"]

    package.loaded["trouble.item"] = {
      new = function(opts)
        return opts
      end,
    }

    package.loaded["trouble.sources.snacks"] = {
      items = {},
    }

    package.loaded["trouble"] = {
      open = function() end,
    }
  end)

  after_each(function()
    vim.schedule = original_schedule
    package.loaded["trouble.item"] = original_trouble_item
    package.loaded["trouble.sources.snacks"] = original_trouble_source
    package.loaded["trouble"] = original_trouble
  end)

  it("resolves picker-relative file paths against the picker cwd", function()
    local trouble = dofile(config_root .. "/lua/util/snacks/trouble.lua")
    local item = trouble.item({
      cwd = "/Users/aarron/Code/repconnex/web-mobile-client",
      file = "src/app.ts",
      line = "const app = true",
    })

    assert.are.equal("/Users/aarron/Code/repconnex/web-mobile-client/src/app.ts", item.filename)
  end)

  it("opens trouble with absolute filenames derived from the picker cwd", function()
    local trouble = dofile(config_root .. "/lua/util/snacks/trouble.lua")
    local opened
    local scheduled
    local closed = false

    package.loaded["trouble"].open = function(opts)
      opened = opts
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.schedule = function(fn)
      scheduled = fn
    end

    trouble.open({
      selected = function()
        return {}
      end,
      items = function()
        return {
          {
            cwd = "/Users/aarron/Code/repconnex/web-mobile-client",
            file = "src/app.ts",
            line = "const app = true",
          },
        }
      end,
      close = function()
        closed = true
      end,
    }, { type = "all" })

    assert.is_true(closed)
    assert.are.equal(
      "/Users/aarron/Code/repconnex/web-mobile-client/src/app.ts",
      package.loaded["trouble.sources.snacks"].items[1].filename
    )

    scheduled()
    assert.are.same({ mode = "snacks" }, opened)
  end)
end)
