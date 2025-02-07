return {
  "garymjr/nvim-snippets",
  optional = true,
  config = function(_, opts)
    -- HACK: Move friendly-snippets to the front so individual snippets can be overridden
    local old_register_snippets = require("snippets.utils").register_snippets
    require("snippets.utils").register_snippets = function()
      local SnippetsConfig = require("snippets.config")
      local search_paths = SnippetsConfig.get_option("search_paths", {})
      local tmp = search_paths[2]
      search_paths[2] = search_paths[1]
      search_paths[1] = tmp
      SnippetsConfig.set_option("search_paths", search_paths)

      old_register_snippets()
    end

    require("snippets").setup(opts)
  end,
}
