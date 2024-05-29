local mini_ai_git_signs = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local gitsigns_cache = require("gitsigns.cache").cache[bufnr]
  if not gitsigns_cache then
    return
  end
  local hunks = gitsigns_cache.hunks
  hunks = vim.tbl_map(function(hunk)
    local from_line = hunk.added.start
    local from_col = 1
    local to_line = hunk.vend
    local to_col = #vim.api.nvim_buf_get_lines(bufnr, to_line - 1, to_line, false)[1] + 1
    return {
      from = { line = from_line, col = from_col },
      to = { line = to_line, col = to_col },
    }
  end, hunks)

  return hunks
end

return {
  {
    "echasnovski/mini.ai",
    optional = true,
    opts = function(_, opts)
      local ai = require("mini.ai")
      local MiniExtra = require("mini.extra")
      return vim.tbl_deep_extend("keep", opts, {
        custom_textobjects = {
          -- LazyVim uses: a,i,f,c,t,d,e,g,u,U,o
          -- Lazyvim already sets this one
          -- o = ai.gen_spec.treesitter({ -- code block
          --   a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          --   i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          -- }),
          O = ai.gen_spec.treesitter({
            a = { "@function.outer", "@class.outer", "@testitem.outer" },
            i = { "@function.inner", "@class.inner", "@testitem.inner" },
          }),
          j = ai.gen_spec.treesitter({
            a = { "@jsx_attribute.outer" },
            i = { "@jsx_attribute.inner" },
          }, {}),
          C = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.outer" }),
          -- P = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
          -- T = ai.gen_spec.treesitter({ a = "@parameter.type", i = "@type.inner" }),
          -- r = ai.gen_spec.treesitter({ a = "@return.outer", i = "@return.inner" }),
          -- X = ai.gen_spec.treesitter({ a = "@statement.outer", i = "@statement.outer" }),
          k = ai.gen_spec.treesitter({
            i = { "@assignment.lhs", "@key.inner" },
            a = { "@assignment.outer", "@key.inner" },
          }),
          v = ai.gen_spec.treesitter({
            i = { "@assignment.rhs", "@value.inner", "@return.inner" },
            a = { "@assignment.outer", "@value.inner", "@return.outer" },
          }),
          -- x = ai.gen_spec.treesitter({
          --   a = { "@structure.outer" },
          --   i = { "@structure.inner" },
          -- }),
          -- chunk (as in from vim-textobj-chunk)
          -- x = {
          --   "\n.-%b{}.-\n",
          --   "\n().-()%{\n.*\n.*%}().-\n()",
          -- },
          -- ["$"] = ai.gen_spec.pair("$", "$", { type = "balanced" }),
          h = mini_ai_git_signs,
          -- I = MiniExtra.gen_ai_spec.indent(),
          N = MiniExtra.gen_ai_spec.number(),
          L = MiniExtra.gen_ai_spec.line(),
          D = MiniExtra.gen_ai_spec.diagnostic(),
          E = MiniExtra.gen_ai_spec.diagnostic({ severity = vim.diagnostic.severity.ERROR }),
          p = {
            {
              "\n%s*\n()().-()\n%s*\n()[%s]*", -- normal paragraphs
              "^()().-()\n%s*\n[%s]*()", -- paragraph at start of file
              "\n%s*\n()().-()()$", -- paragraph at end of file
            },
          },
          -- TODO: only for markdown
          S = {
            {
              "%b{}",
              "\n%s*\n()().-()\n%s*\n[%s]*()", -- normal paragraphs
              "^()().-()\n%s*\n[%s]*()", -- paragraph at start of file
              "\n%s*\n()().-()()$", -- paragraph at end of file
            },
            {
              -- ("[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]"):format(), -- normal sentence
              "[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]", -- normal sentence
              "^[%{%[]?[%s]*()().-[^%s].-()[%.?!]()[%s]", -- sentence at start of paragraph
              "[%.?!][%s]+()().-[^%s].-()()[\n%}%]]?$", -- sentence at end of paragraph
              "^[%s]*()().-[^%s].-()()[%s]+$", -- sentence at that fills paragraph (no final punctuation)
            },
          },
          -- Imitate word ignoring digits and punctuation (supports only Latin alphabet):
          W = { {
            "()()%f[%w%p][%w%p]+()[ \t]*()",
          } },
          -- Word, ignoring punctuation and digits
          -- w = { "()()%f[%w_][%w_]+()[ \t]*()" },
          -- Word, with camel case support (supports only Latin alphabet) TestTest
          w = {
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          -- Lua block '%[%[().-()%]%]'
          -- date '()%d%d%d%d%-%d%d%-%d%d()'
        },
      })

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
