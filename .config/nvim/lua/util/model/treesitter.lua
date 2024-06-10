local M = {}

function M.parse_functions()
    local cquery = vim.treesitter.query.parse("ruby", "(module) @class.outer")
    for pattern, match, metadata in cquery:iter_matches(tree:root(), bufnr, 0, -1, { all = true }) do
      for id, nodes in pairs(match) do
        local name = query.captures[id]
        for _, node in ipairs(nodes) do
          -- `node` was captured by the `name` capture in the match

          local node_data = metadata[id] -- Node level metadata
          ... use the info here ...
        end
      end
    end
end

return M
