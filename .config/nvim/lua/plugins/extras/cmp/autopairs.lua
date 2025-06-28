return {
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "saghen/blink.pairs",
    enabled = false,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "windwp/nvim-autopairs",
      -- lazy = false,
      -- event = {"BufReadPre", "BufNewFile"},
      opts = {
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0, -- Offset from pattern match
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
        disable_filetype = { "vim" },
      },
      config = function(_, opts)
        local npairs = require("nvim-autopairs")
        npairs.setup(opts)

        -- setup cmp for autopairs
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

        -- Endwise rules
        npairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))
        npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
        npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))

        -- Custom rules
        local cond = require("nvim-autopairs.conds")
        local Rule = require("nvim-autopairs.rule")
        local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

        -- stylua: ignore start
        npairs.add_rules({
          Rule("<", ">", { "rust", "typescript" }):with_pair(
            cond.not_before_text(" ")
          ):with_move(cond.move_right()),
          -- Javascript arrow key
          Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
            :use_regex(true)
            :set_end_pair_length(2),
          -- Auto addspace on =
          Rule("=", "")
            :with_pair(cond.not_inside_quote())
            :with_pair(function(opts)
              local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
              if last_char:match("[%w%=%s]") then
                return true
              end
              return false
            end)
            :replace_endpair(function(opts)
              local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
              local next_char = opts.line:sub(opts.col, opts.col)
              next_char = next_char == " " and "" or " "
              if prev_2char:match("%w$") then
                return "<bs> =" .. next_char
              end
              if prev_2char:match("%=$") then
                return next_char
              end
              if prev_2char:match("=") then
                return "<bs><bs>=" .. next_char
              end
              return ""
            end)
            :set_end_pair_length(0)
            :with_move(cond.none())
            :with_del(cond.none()),
        })
        -- stylua: ignore end

        -- For each pair of brackets we will add another rule
        -- for _, bracket in pairs(brackets) do
        --   npairs.add_rules({
        --     -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
        --     Rule(bracket[1] .. " ", " " .. bracket[2])
        --       :with_pair(cond.none())
        --       :with_move(function(opts)
        --         return opts.char == bracket[2]
        --       end)
        --       :with_del(cond.none())
        --       :use_key(bracket[2])
        --       -- Removes the trailing whitespace that can occur without this
        --       :replace_map_cr(function(_)
        --         return "<C-c>2xi<CR><C-c>O"
        --       end),
        --   })
        -- end

        -- Custom handler to disable function parentheses auto-completion for specific node types
        -- This prevents autopairs from adding parentheses after function names in contexts where
        -- they shouldn't be added (e.g., named imports, use declarations)
        local ts_utils = require("nvim-treesitter.ts_utils")
        local ts_node_func_parens_disabled = {
          -- ecma
          named_imports = true,
          -- rust
          use_declaration = true,
        }
        local default_handler = cmp_autopairs.filetypes["*"]["("].handler
        cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
          local node_type = ts_utils.get_node_at_cursor():type()
          if ts_node_func_parens_disabled[node_type] then
            if item.data then
              item.data.funcParensDisabled = true
            else
              char = ""
            end
          end
          default_handler(char, item, bufnr, rules, commit_character)
        end
      end,
    },
  },
}
