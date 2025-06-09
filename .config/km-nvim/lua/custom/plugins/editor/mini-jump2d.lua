return {
  {
    "echasnovski/mini.jump2d",
    version = false,
    opts = {
      view = {
        dim = true,
        n_steps_ahead = 1,
      },
      -- spotter = MiniJump2d.start(MiniJump2d.builtin_opts.word_start),
      spotter = require("mini.jump2d").builtin_opts.word_start.spotter,
      labels = "abcdefghijklmnopqrstuvwxyz;",
      allowed_windows = { not_current = false },
      allowed_lines = {
        -- blank = false,
        cursor_at = false,
      },
    },
  },
}
