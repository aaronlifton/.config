return {
  {
    "ggandor/leap-spooky.nvim",
    dependencies = { "leap.nvim" },
    config = function()
      require("leap-spooky").setup({
        -- Additional text objects, to be merged with the default ones.
        -- E.g.: {'iq', 'aq'}
        extra_text_objects = { "iq", "aq" },
        -- Mappings will be generated corresponding to all native text objects,
        -- like: (ir|ar|iR|aR|im|am|iM|aM){obj}.
        -- Special line objects will also be added, by repeating the affixes.
        -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
        -- window.
        affixes = {
          -- The cursor moves to the targeted object, and stays there.
          magnetic = { window = "m", cross_window = "M" },
          -- The operation is executed seemingly remotely (the cursor boomerangs
          -- back afterwards).
          remote = { window = "r", cross_window = "R" },
        },
        -- Defines text objects like `riw`, `raw`, etc., instead of
        -- targets.vim-style `irw`, `arw`.
        -- prefix = false,
        prefix = true,
        -- The yanked text will automatically be pasted at the cursor position
        -- if the unnamed register is in use.
        -- paste_on_remote_yank = false,
        paste_on_remote_yank = true,
      })
    end,
  },
  {
    "ggandor/leap-ast.nvim",
    dependencies = { "leap.nvim" },
    config = function() end,
    keys = {
      {
        "qs",
        function()
          require("leap-ast").leap()
          -- Defines text objects like `riw`, `raw`, etc., instead of
          -- targets.vim-style `irw`, `arw`.
        end,
        { mode = { "n", "x", "o" }, desc = "Leap AST" },
      },
    },
  },
  {
    "Grazfather/leaplines.nvim",
    enabled = true,
    dependencies = "ggandor/leap.nvim",
    keys = {
      -- Sample mappings only
      {
        desc = "Leap line upwards",
        mode = { "n", "v" },
        "<leader>k",
        function()
          require("leaplines").leap("up")
        end,
      },
      {
        desc = "Leap line downwards",
        mode = { "n", "v" },
        "<leader>j",
        function()
          require("leaplines").leap("down")
        end,
      },
    },
  },
}
