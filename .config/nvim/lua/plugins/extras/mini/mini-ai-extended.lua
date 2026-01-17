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

local line_textobj = function()
  return function(ai_type)
    local line_num = vim.fn.line(".")
    local line = vim.fn.getline(line_num)
    -- Ignore indentation for `i` textobject
    local from_col = ai_type == "a" and 1 or (line:match("^(%s*)"):len() + 1)
    -- Don't select `\n` past the line to operate within a line
    local to_col = line:len()

    return { from = { line = line_num, col = from_col }, to = { line = line_num, col = to_col } }
  end
end

local custom_mappings = {
  { "C", desc = "comment" },
  { "k", desc = "key, assignment" },
  { "v", desc = "value, assignment rhs, return" },
  { "N", desc = "number" },
  { "L", desc = "line" },
  { "D", desc = "diagnostic" },
  { "E", desc = "diagnostic (error)" },
  { "p", desc = "paragraph" },
  { "S", desc = "sentence" },
  { "W", desc = "word" },
  { "h", desc = "hunk" },
}

return {
  {
    "nvim-mini/mini.ai",
    optional = true,
    dependencies = {
      -- {
      --   "nvim-mini/mini.nvim",
      --   lazy = true,
      --   vscode = true,
      --   config = function()
      --     require("mini.extra").setup()
      --   end,
      -- },
      { "nvim-mini/mini.extra", version = "*" },
    },
    opts = function(_, opts)
      local ai = require("mini.ai")
      -- local MiniExtra = require("mini.extra")
      local custom_textobjects = {
        -- LazyVim uses: o,f,c,t,d,e,g,u,U
        C = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.outer" }),
        k = ai.gen_spec.treesitter({
          i = { "@assignment.lhs", "@key.inner" },
          a = { "@assignment.outer", "@key.inner" },
        }),
        v = ai.gen_spec.treesitter({
          i = { "@assignment.rhs", "@value.inner", "@return.inner" },
          a = { "@assignment.outer", "@value.inner", "@return.outer" },
        }),
        -- N = MiniExtra.gen_ai_spec.number(),
        -- D = MiniExtra.gen_ai_spec.diagnostic(),
        -- E = MiniExtra.gen_ai_spec.diagnostic({ severity = vim.diagnostic.severity.ERROR }),
        L = line_textobj(),
        p = {
          {
            "\n%s*\n()().-()\n%s*\n()[%s]*", -- normal paragraphs
            "^()().-()\n%s*\n[%s]*()", -- paragraph at start of file
            "\n%s*\n()().-()()$", -- paragraph at end of file
          },
        },
        S = { -- normal sentence
          "[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]",
          "^[%{%[]?[%s]*()().-[^%s].-()[%.?!]()[%s]",
          "[%.?!][%s]+()().-[^%s].-()()[\n%}%]]?$",
          "^[%s]*()().-[^%s].-()()[%s]+$",
        },
        -- Imitate word ignoring digits and punctuation (supports only Latin alphabet):
        W = { {
          "()()%f[%w%p][%w%p]+()[ \t]*()",
        } },
        -- Word, with camelCase support (supports only Latin alphabet) TestTest
        -- LazyVim maps this as `e`, so not needed. But kept as an example for
        -- mapping complex keybindings.
        -- Could also use the keycode <C-w> = "\23"
        -- [vim.api.nvim_replace_termcodes("<C-w>", true, false, true)] = {
        --   {
        --     "%u[%l%d]+%f[^%l%d]",
        --     "%f[%S][%l%d]+%f[^%l%d]",
        --     "%f[%P][%l%d]+%f[^%l%d]",
        --     "^[%l%d]+%f[^%l%d]",
        --   },
        --   "^().*()$",
        -- },
        -- TODO: see if this is interfering with the `h` textobject from mini.diff
        h = LazyVim.has("gitsigns") and mini_ai_git_signs or nil,
        -- Match the strart and end of a markdown code fence
        -- ["`"] = ai.gen_spec.treesitter({
        --   a = "@fenced_code_block.outer",
        --   i = "@code_fence_content",
        -- }),
        -- Word, ignoring punctuation and digits
        -- w = { "()()%f[%w_][%w_]+()[ \t]*()" },
        -- Lua block '%[%[().-()%]%]'
        -- date '()%d%d%d%d%-%d%d%-%d%d()'
        -- ["$"] = ai.gen_spec.pair("$", "$", { type = "balanced" }),
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
        -- TODO: Convert this example for something useful; this just clones vif
        F = function()
          -- local ts_utils = require("nvim-treesitter.ts_utils")
          local ts_utils = Util.treesitter
          local current_node = ts_utils.get_node_at_cursor()

          -- Traverse up the tree to find the function definition node
          while current_node and current_node:type() ~= "function_definition" do
            current_node = current_node:parent()
          end

          if not current_node then return nil end

          -- Find the block node by iterating through children
          local body_node
          for i = 0, current_node:named_child_count() - 1 do
            local child = current_node:named_child(i)
            if child and child:type() == "block" then
              body_node = child
              break
            end
          end

          if not body_node then return nil end

          local start_row, start_col, end_row, end_col = body_node:range()
          local bufnr = vim.api.nvim_get_current_buf()

          -- Get the first node inside the block
          local first_child = body_node:named_child(0)
          local first_child_row, first_child_col = first_child:range()

          -- Get the first and last lines of the function body
          local first_line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
          local last_line = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1]

          local debugvars = {
            start_row = start_row,
            start_col = start_col,
            end_row = end_row,
            end_col = end_col,
            first_child_col = first_child_col,
            last_line_length = #last_line,
          }
          vim.api.nvim_echo({ { vim.inspect(debugvars), "Normal" } }, true, {})

          -- Adjust start and end positions with correct column positions
          -- 'from' starts at first character, 'to' ends at last character
          local from = { line = start_row + 1, col = first_child_col + 1 }
          local to = { line = end_row + 1, col = #last_line }

          return { from = from, to = to }
        end,
      }

      return vim.tbl_deep_extend("keep", opts, { custom_textobjects = custom_textobjects })
    end,
  },
}
