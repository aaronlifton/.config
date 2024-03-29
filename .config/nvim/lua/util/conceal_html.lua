local conceal_ns = vim.api.nvim_create_namespace("class_conceal")
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("class_conceal", { clear = true }),
  pattern = { "*.tsx" },
  callback = function(event)
    local bufnr = event.buf or vim.api.nvim_get_current_buf()

    ---Conceal HTML class attributes. Ideal for big TailwindCSS class lists
    ---Ref: https://gist.github.com/mactep/430449fd4f6365474bfa15df5c02d27b
    local language_tree = vim.treesitter.get_parser(bufnr, "tsx")
    local syntax_tree = language_tree:parse()
    local root = syntax_tree[1]:root()

    local ok, query = pcall(
      vim.treesitter.query.parse,
      "tsx",
      [[
    ((jsx_attribute
        (property_identifier) @att_name (#eq? @att_name "class")
        (string (string_fragment) @class_value)))
    ]]
    )
    if not ok then
      dd(query)
    end

    for _, captures, metadata in query:iter_matches(root, bufnr, root:start(), root:end_(), {}) do
      local start_row, start_col, end_row, end_col = captures[2]:range()
      vim.api.nvim_buf_set_extmark(bufnr, conceal_ns, start_row, start_col + 3, {
        end_line = end_row,
        end_col = end_col,
        conceal = "%", -- "…",
        -- conceal = metadata[2].conceal,
      })
    end
  end,
})

-- { "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" },
--       function()
--         vim.opt.conceallevel = 2 -- Concealed text is completely hidden
--
--         local bufnr = vim.api.nvim_get_current_buf()
--
--         ---Conceal HTML class attributes. Ideal for big TailwindCSS class lists
--         ---Ref: https://gist.github.com/mactep/430449fd4f6365474bfa15df5c02d27b
--         local language_tree = vim.treesitter.get_parser(bufnr, "html")
--         local syntax_tree = language_tree:parse()
--         local root = syntax_tree[1]:root()
--
--         local query = [[
--         ((attribute
--           (attribute_name) @att_name (#eq? @att_name "class")
--           (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
--         ]]
--
--         local ok, ts_query = pcall(vim.treesitter.query.parse, "html", query)
--         if not ok then
--           return
--         end
--
--         for _, captures, metadata in ts_query:iter_matches(root, bufnr, root:start(), root:end_(), {}) do
--           local start_row, start_col, end_row, end_col = captures[2]:range()
--           -- This conditional prevents conceal leakage if the class attribute is erroneously formed
--           if (end_row - start_row) == 0 then
--             vim.api.nvim_buf_set_extmark(bufnr, conceal_ns, start_row, start_col, {
--               end_line = end_row,
--               end_col = end_col,
--               conceal = metadata[2].conceal,
--             })
--           end
--         end
--       end,
--       opts = {
--         pattern = { "*.html" },
--       },
--     },
--   },
