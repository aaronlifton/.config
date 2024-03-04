local gen_ai_spec = require("mini.extra").gen_ai_spec

return {
  {
    "echasnovski/mini.ai",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        -- <https://www.reddit.com/r/neovim/comments/wa819w/comment/ilfpkbd/?utm_source=share&utm_medium=web2x&context=3>
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          -- -- Tweak function call to not detect dot in function name
          -- F = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          -- t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          -- from the docs
          -- x = {
          -- name = "experimental",
          -- w = { "()()%f[%w]%w+()[ \t]*()" },
          -- W = {
          --   {
          --     "%u[%l%d]+%f[^%l%d]",
          --     "%f[%S][%l%d]+%f[^%l%d]",
          --     "%f[%P][%l%d]+%f[^%l%d]",
          --     "^[%l%d]+%f[^%l%d]",
          --   },
          --   "^().*()$",
          -- },
          -- N = { "%f[%d]%d+" },
          -- D = { "()%d%d%d%d%-%d%d%-%d%d()" },
          -- Make `|` select both edges in non-balanced way
          -- ["|"] = ai.gen_spec.pair("|", "|", { type = "non-balanced" }),
          -- A = function()
          --   local left_edge = vim.pesc(vim.fn.input("Function name: "))
          --   return { string.format("%s+%%b()", left_edge), "^.-%(().*()%)$" }
          -- end,
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

          -- alphabet: abcdefghijklmnopqrstuvwxyz
          -- available letters: deghjkuvxyz
          B = gen_ai_spec.buffer(),
          D = gen_ai_spec.diagnostic(),
          I = gen_ai_spec.indent(),
          L = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
          -- B = MiniExtra.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }, {}),
          -- C = MiniExtra.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
          -- L = MiniExtra.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }, {}),
          -- F = MiniExtra.gen_spec.function_call({ name_pattern = "[%w_]" }),
          -- T = MiniExtra.gen_spec.treesitter({ a = "@type.outer", i = "@type.inner" }, {}),
          -- D = MiniExtra.gen_spec.treesitter({ a = "@define.outer", i = "@define.inner" }, {}),
          -- M = MiniExtra.gen_spec.treesitter({ a = "@macro.outer", i = "@macro.inner" }, {}),
          -- R = MiniExtra.gen_spec.treesitter({ a = "@return.outer", i = "@return.inner" }, {}),
          -- E = MiniExtra.gen_spec.treesitter({ a = "@error.outer", i = "@error.inner" }, {}),
          -- P = MiniExtra.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {}),
          -- I = MiniExtra.gen_spec.treesitter({ a = "@field.outer", i = "@field.inner" }, {}),
          -- S = MiniExtra.gen_spec.treesitter({ a = "@scope", i = "@scope" }, {}),
          -- V = MiniExtra.gen_spec.treesitter({ a = "@variable.outer", i = "@variable.inner" }, {}),
          -- K = MiniExtra.gen_spec.treesitter({ a = "@constant.outer", i = "@constant.inner" }, {}),
        },
      }
    end,
  },
}
