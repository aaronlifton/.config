-- https://www.reddit.com/r/neovim/comments/1fo8wvh/multicursornvim_10_released/
return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  keys = {
    -- stylua: ignore start
    -- Add or skip cursor above/below the main cursor
    { "<up>", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "v" }, desc = "Add cursor above" },
    { "<down>", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "v" }, desc = "Add cursor below" },
    { "<leader><up>", function() require("multicursor-nvim").lineSkipCursor(-1) end, mode = { "n", "v" }, desc = "Skip cursor above" },
    { "<leader><down>", function() require("multicursor-nvim").lineSkipCursor(1) end, mode = { "n", "v" }, desc = "Skip cursor below" },

    -- Add or skip adding a new cursor by matching word/selection
    { "<leader>n", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "v" }, desc = "Add next matching cursor" },
    { "<leader>s", function() require("multicursor-nvim").matchSkipCursor(1) end, mode = { "n", "v" }, desc = "Skip next matching cursor" },
    { "<leader>N", function() require("multicursor-nvim").matchAddCursor(-1) end, mode = { "n", "v" }, desc = "Add previous matching cursor" },
    { "<leader>S", function() require("multicursor-nvim").matchSkipCursor(-1) end, mode = { "n", "v" }, desc = "Skip previous matching cursor" },

    -- Add all matches in the document
    { "<leader>A", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "v" }, desc = "Add all matching cursors" },

    -- Rotate the main cursor
    { "<left>", function() require("multicursor-nvim").nextCursor() end, mode = { "n", "v" }, desc = "Next cursor" },
    { "<right>", function() require("multicursor-nvim").prevCursor() end, mode = { "n", "v" }, desc = "Previous cursor" },

    -- Delete the main cursor
    { "<leader>x", function() require("multicursor-nvim").deleteCursor() end, mode = { "n", "v" }, desc = "Delete cursor" },

    -- Add and remove cursors with control + left click
    { "<c-leftmouse>", function() require("multicursor-nvim").handleMouse() end, mode = "n", desc = "Toggle cursor at mouse" },

    -- Easy way to add and remove cursors using the main cursor
    { "<c-q>", function() require("multicursor-nvim").toggleCursor() end, mode = { "n", "v" }, desc = "Toggle cursor" },

    -- Clone every cursor and disable the originals
    { "<leader><c-q>", function() require("multicursor-nvim").duplicateCursors() end, mode = { "n", "v" }, desc = "Duplicate cursors" },

    -- ESC handling
    { "<esc>", function()
      local mc = require("multicursor-nvim")
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      end
    end, mode = "n", desc = "Multicursor ESC handling" },

    -- Bring back cursors if you accidentally clear them
    { "<leader>gv", function() require("multicursor-nvim").restoreCursors() end, mode = "n", desc = "Restore cursors" },

    -- Align cursor columns
    { "<leader>a", function() require("multicursor-nvim").alignCursors() end, mode = "n", desc = "Align cursors" },

    -- Split visual selections by regex
    { "S", function() require("multicursor-nvim").splitCursors() end, mode = "v", desc = "Split cursors" },

    -- Append/insert for each line of visual selections
    { "I", function() require("multicursor-nvim").insertVisual() end, mode = "v", desc = "Insert at cursors" },
    { "A", function() require("multicursor-nvim").appendVisual() end, mode = "v", desc = "Append at cursors" },

    -- Match new cursors within visual selections by regex
    { "M", function() require("multicursor-nvim").matchCursors() end, mode = "v", desc = "Match cursors" },

    -- Rotate visual selection contents
    { "<leader>t", function() require("multicursor-nvim").transposeCursors(1) end, mode = "v", desc = "Transpose cursors forward" },
    { "<leader>T", function() require("multicursor-nvim").transposeCursors(-1) end, mode = "v", desc = "Transpose cursors backward" },

    -- Jumplist support
    { "<c-i>", function() require("multicursor-nvim").jumpForward() end, mode = { "n", "v" }, desc = "Jump forward" },
    { "<c-o>", function() require("multicursor-nvim").jumpBackward() end, mode = { "n", "v" }, desc = "Jump backward" },
    -- stylua: ignore end
  },
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    -- Customize how cursors look
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
