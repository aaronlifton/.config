return {
  "subnut/nvim-ghost.nvim",
  cond = not vim.env.SSH_TTY,
  cmd = "GhostTextStart",
  init = function()
    -- Set port number
    --vim.g.nvim_ghost_server_port = 4001
    -- Start manually
    vim.g.nvim_ghost_autostart = 0
    -- Suppressing all messages
    --vim.g.nvim_ghost_super_quiet = 1
    -- Disable the plugin
    --vim.g.nvim_ghost_disabled = 1
  end,
}
