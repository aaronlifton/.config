-- Example usage of ai_keymaps utility
---@diagnostic disable: undefined-global

-- This example shows how to use the ai_keymaps utility to
-- programmatically generate keymaps from an ai_config table

-- First, let's create a sample ai_config with custom textobjects
local ai_config = {
  custom_textobjects = {
    -- Function textobject
    F = {
      desc = "Function",
      -- This would normally be a function or treesitter spec
      -- For demonstration purposes, we're using a placeholder
    },
    -- Class textobject
    C = {
      desc = "Class",
      -- This would normally be a function or treesitter spec
    },
    -- Parameter textobject
    P = {
      desc = "Parameter",
      -- This would normally be a function or treesitter spec
    },
  }
}

-- Now, let's use our utility to generate keymaps from this config
local ai_keymaps = require("util.ai_keymaps")

-- Generate keymaps for operator-pending mode
local op_keymaps = ai_keymaps.generate_keymaps(ai_config, {
  mode = "o",       -- Operator-pending mode
  prefix = "",      -- No prefix
  buffer = false    -- Global keymaps, not buffer-local
})

-- Generate keymaps for visual mode with a custom prefix
local visual_keymaps = ai_keymaps.generate_keymaps(ai_config, {
  mode = "x",       -- Visual mode
  prefix = "g",     -- Add 'g' prefix to all keymaps
  buffer = false    -- Global keymaps, not buffer-local
})

-- Display the generated keymaps
print("Operator-pending mode keymaps:")
for mapping, desc in pairs(op_keymaps) do
  print(mapping .. " - " .. desc)
end

print("\nVisual mode keymaps:")
for mapping, desc in pairs(visual_keymaps) do
  print(mapping .. " - " .. desc)
end

-- Example of using the utility with buffer-local config
-- This would typically be used in a filetype plugin
vim.b.miniai_config = {
  custom_textobjects = {
    -- Ruby block textobject
    B = {
      desc = "Ruby block",
      -- This would normally be a function or treesitter spec
    },
    -- Ruby method textobject
    M = {
      desc = "Ruby method",
      -- This would normally be a function or treesitter spec
    },
  }
}

-- Generate buffer-local keymaps for both operator-pending and visual modes
local buffer_keymaps = ai_keymaps.generate_buffer_keymaps({
  mode = {"o", "x"}, -- Both operator-pending and visual modes
  prefix = "",       -- No prefix
  buffer = true      -- Buffer-local keymaps
})

print("\nBuffer-local keymaps:")
for mapping, desc in pairs(buffer_keymaps) do
  print(mapping .. " - " .. desc)
end

