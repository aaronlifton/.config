local MiniExtra = require("mini.extra")
local gen_ai_spec = MiniExtra.gen_ai_spec

return {
  {
    "echasnovski/mini.ai",
    optional = true,
    opts = function(_, opts)
      local ai = require("mini.ai")
      return {
        custom_textobjects = {
          X = gen_ai_spec.buffer(),
          D = gen_ai_spec.diagnostic(),
          I = gen_ai_spec.indent(),
          L = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
        },
      }
      -- used: a,i,f,c,t,d,e,g,u,U
      -- B = MiniExtra.gen_ai_spec.treesitter({ a = "@block.outer", i = "@block.inner" }, {}),
      -- C = MiniExtra.gen_ai_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
      -- O = MiniExtra.gen_ai_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }, {}),
      -- F = MiniExtra.gen_ai_spec.function_call({ name_pattern = "[%w_]" }),
      -- T = MiniExtra.gen_ai_spec.treesitter({ a = "@type.outer", i = "@type.inner" }, {}),
      -- D = MiniExtra.gen_ai_spec.treesitter({ a = "@define.outer", i = "@define.inner" }, {}),
      -- M = MiniExtra.gen_ai_spec.treesitter({ a = "@macro.outer", i = "@macro.inner" }, {}),
      -- R = MiniExtra.gen_ai_spec.treesitter({ a = "@return.outer", i = "@return.inner" }, {}),
      -- E = MiniExtra.gen_ai_spec.treesitter({ a = "@error.outer", i = "@error.inner" }, {}),
      -- P = MiniExtra.gen_ai_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {}),
      -- I = MiniExtra.gen_ai_spec.treesitter({ a = "@field.outer", i = "@field.inner" }, {}),
      -- S = MiniExtra.gen_ai_spec.treesitter({ a = "@scope", i = "@scope" }, {}),
      -- V = MiniExtra.gen_ai_spec.treesitter({ a = "@variable.outer", i = "@variable.inner" }, {}),
      -- K = MiniExtra.gen_ai_spec.treesitter({ a = "@constant.outer", i = "@constant.inner" }, {}),
      -- <https://www.reddit.com/r/neovim/comments/wa819w/comment/ilfpkbd/?utm_source=share&utm_medium=web2x&context=3>
      -- C = function(_, _, _)
      --   local res = {}
      --   for i = 1, vim.api.nvim_buf_line_count(0) do
      --     local cur_line = vim.fn.getline(i)
      --     if vim.fn.strdisplaywidth(cur_line) > 80 then
      --       local region = {
      --         from = { line = i, col = 1 },
      --         to = { line = i, col = cur_line:len() },
      --       }
      --       table.insert(res, region)
      --     end
      --   end
      --   return res
      -- end,
    end,
  },
}
