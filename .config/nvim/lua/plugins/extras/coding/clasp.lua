return {
  "xzbdmw/clasp.nvim",
  config = function()
    require("clasp").setup({
      pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["<"] = ">" },
      -- If called from insert mode, do not return to normal mode.
      keep_insert_mode = true,
      -- consider the following go code:
      --
      -- `var s make()[]int`
      --
      -- if we want to turn it into:
      --
      -- `var s make([]int)`
      --
      -- Directly parse would produce wrong nodes, so clasp always removes the
      -- entire pair (`()` in this case) before parsing, in this case what the
      -- parser would see is `var s make[]int`, but this is still not valid
      -- grammar. For a better parse tree, we can aggressively remove all
      -- alphabetic chars before cursor, so it becomes:
      --
      -- `var s []int`
      --
      -- Now we can correctly wrap the entire `[]int`, because it is identified
      -- as a node. By default we only remove current pair(s) before parsing, in
      -- most cases this is fine, but you can set `remove_pattern = "[a-zA-Z_%-]+$"`
      -- to use a more aggressive approach if you run into problems.
      remove_pattern = nil,
    })

    -- jumping from smallest region to largest region.
    -- Press 'u' in normal mode or bind '<cmd>undo<cr>'
    -- in insert mode to undo. You can interleave undo and wrap.

    -- Initial state:
    -- func(|)vim.keymap.foo('bar')

    -- Keep pressing <c-l>:
    -- func(vim)|.keymap.foo('bar')
    -- func(vim.keymap)|.foo('bar')
    -- func(vim.keymap.foo('bar'))|

    -- Press 'u'
    -- func(vim.keymap)|.foo('bar')
    vim.keymap.set({ "n", "i" }, "<c-l>", function()
      require("clasp").wrap("next")
    end)

    -- jumping from largest region to smallest region

    -- Initial state:
    -- func(|)vim.keymap.foo('bar')

    -- Keep pressing <c-;>
    -- func(vim.keymap.foo('bar'))|
    -- func(vim.keymap)|.foo('bar')
    -- func(vim)|.keymap.foo('bar')

    -- Press 'u'
    -- func(vim.keymap)|.foo('bar')
    vim.keymap.set({ "n", "i" }, "<c-;>", function()
      require("clasp").wrap("prev")
    end)

    -- If you want to exclude nodes whose end row is not current row
    vim.keymap.set({ "n", "i" }, "<c-l>", function()
      require("clasp").wrap("next", function(nodes)
        local n = {}
        for _, node in ipairs(nodes) do
          if node.end_row == vim.api.nvim_win_get_cursor(0)[1] - 1 then table.insert(n, node) end
        end
        return n
      end)
    end)
  end,
}
