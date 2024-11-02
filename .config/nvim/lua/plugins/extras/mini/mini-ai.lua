local mini_ai_git_signs = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local gitsigns_cache = require("gitsigns.cache").cache[bufnr]
  if not gitsigns_cache then return end
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
    dependencies = {
      {
        "echasnovski/mini.nvim",
        lazy = true,
        vscode = true,
        config = function()
          require("mini.extra").setup()
        end,
      },
    },
    optional = true,
    opts = function(_, opts)
      local ai = require("mini.ai")
      local MiniExtra = require("mini.extra")
      local custom_textobjects = {
        -- LazyVim uses: a,i,f,c,t,d,e,g,u,U,o
        C = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.outer" }),
        k = ai.gen_spec.treesitter({
          i = { "@assignment.lhs", "@key.inner" },
          a = { "@assignment.outer", "@key.inner" },
        }),
        v = ai.gen_spec.treesitter({
          i = { "@assignment.rhs", "@value.inner", "@return.inner" },
          a = { "@assignment.outer", "@value.inner", "@return.outer" },
        }),
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
        { -- normal sentence}
          "[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]",
          "^[%{%[]?[%s]*()().-[^%s].-()[%.?!]()[%s]",
          "[%.?!][%s]+()().-[^%s].-()()[\n%}%]]?$",
          "^[%s]*()().-[^%s].-()()[%s]+$",
        },
        -- Imitate word ignoring digits and punctuation (supports only Latin alphabet):
        W = { {
          "()()%f[%w%p][%w%p]+()[ \t]*()",
        } },
        h = LazyVim.has("gitsigns") and mini_ai_git_signs or nil,
        -- Match the strart and end of a markdown code fence
        ["`"] = {
          { "^%s*```%s*()[^`].-()```%s*$" },
        },
        -- Word, ignoring punctuation and digits
        -- w = { "()()%f[%w_][%w_]+()[ \t]*()" },
        -- Word, with camelCase support (supports only Latin alphabet) TestTest
        -- enables vinw, vanw, etc.
        -- w = {
        --   {
        --     "%u[%l%d]+%f[^%l%d]",
        --     "%f[%S][%l%d]+%f[^%l%d]",
        --     "%f[%P][%l%d]+%f[^%l%d]",
        --     "^[%l%d]+%f[^%l%d]",
        --   },
        --   "^().*()$",
        -- },
        -- Lua block '%[%[().-()%]%]'
        -- date '()%d%d%d%d%-%d%d%-%d%d()'
        -- ["$"] = ai.gen_spec.pair("$", "$", { type = "balanced" }),
        -- F = MiniExtra.gen_ai_spec.function_call({ name_pattern = "[%w_]" }),
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
      }

      return vim.tbl_deep_extend("keep", opts, { custom_textobjects = custom_textobjects })
    end,
  },
}
