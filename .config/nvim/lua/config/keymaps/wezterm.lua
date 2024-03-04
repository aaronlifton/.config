local M = {}

M.wez_chars = {
  s = {
    -- key = "<b8>",
    code = "0xAA",
    fn = function()
      vim.cmd("write")
    end,
    desc = "Save",
  },
  -- a = {
  --   code = "0xAB",
  --   fn = function()
  --     vim.cmd("norm vaB")
  --   end,
  -- },
  -- c = {
  --   -- <b6>
  --   code = "0xAE",
  --   fn = function() end,
  -- },
  -- d = {
  --   -- <b8>
  --   code = "0xB1",
  --   fn = function() end,
  -- },
  -- j = {
  --   -- selects all?
  --   code = "0xB3",
  --   fn = function() end,
  -- },
  -- ["Enter"] = {
  --   -- <b0>
  --   code = "0xB7",
  --   fn = function() end,
  -- },
}

return M
