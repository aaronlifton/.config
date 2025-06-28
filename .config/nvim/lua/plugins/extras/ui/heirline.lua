return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "zeioth/heirline-components.nvim",
    opts = {
      icons = require("util.icons").nerd_font,
    },
  }, --  heirline [ui components]
  --  https://github.com/rebelot/heirline.nvim
  --  Use it to customize the components of your user interface,
  --  Including tabline, winbar, statuscolumn, statusline.
  --  Be aware some components are positional. Read heirline documentation.
  {
    "rebelot/heirline.nvim",
    dependencies = { "zeioth/heirline-components.nvim" },
    event = "User BaseDefered",
    opts = function()
      local lib = require("heirline-components.all")
      local conditions = require("heirline.conditions")
      local components = require("util.heirline")
      -- local colors = require("tokyonight.colors").styles["moon"]
      -- colors.border_highlight = Util.colors.blend_bg(colors.blue1, 0.8)
      -- colors.border = colors.black
      -- colors.bg_popup = colors.bg_dark
      -- colors.bg_statusline = colors.bg_dark
      -- colors.tab = {
      --   tab_actve = { fg = c.fg, bg = c.fg_gutter },
      --   tab_visible = { fg = c.fg, bg = c.bg_statusline },
      --   bg = { bg = c.black },
      --   -- MiniTablineHidden          = { fg = c.dark5, bg = c.bg_statusline },
      --   -- MiniTablineModifiedCurrent = { fg = c.warning, bg = c.fg_gutter },
      --   -- MiniTablineModifiedHidden  = { bg = c.bg_statusline, fg = Util.blend_bg(c.warning, 0.7) },
      --   -- MiniTablineModifiedVisible = { fg = c.warning, bg = c.bg_statusline },
      --   -- MiniTablineTabpagesection  = { bg = c.fg_gutter, fg = c.none },
      --   -- MiniTablineVisible         = { fg = c.fg, bg = c.bg_statusline },
      -- }

      -- local root_dir = LazyVim.lualine.root_dir()
      -- local pretty_path = LazyVim.lualine.pretty_path({ relative = "cwd" })
      -- local c = colors

      vim.o.showtabline = 2
      vim.opt.showcmdloc = "statusline"

      return {
        opts = {
          disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
            local is_disabled = not require("heirline-components.buffer").is_valid(args.buf)
              or lib.condition.buffer_matches({
                buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial", "triptych" },
              }, args.buf)
            return is_disabled
          end,
        },

        -- AstroNvim statusline layout (correct order)
        statusline = {
          hl = {
            fg = "fg",
            bg = "bg",
          },
          lib.component.mode(), -- status.component.mode()
          lib.component.git_branch(), -- status.component.git_branch()
          components.GitBranch2,
          lib.component.separated_path({}), -- status.component.separated_path({})
          lib.component.file_info({ file_icon = {}, filetype = false, filename = {}, file_modified = false }), -- status.component.file_info()
          lib.component.git_diff(), -- status.component.git_diff()
          lib.component.diagnostics(), -- status.component.diagnostics()
          components.Grapple, -- status.component.grapple()
          lib.component.fill(), -- status.component.fill()
          lib.component.lsp(), -- status.component.lsp()
          components.LSPMessages,
          lib.component.virtual_env(), -- status.component.virtual_env()
          lib.component.cmd_info(), -- status.component.cmd_info()
          lib.component.treesitter(), -- status.component.treesitter()
          components.WakaTime,
          components.AiProgress,
          lib.component.nav(), -- status.component.nav()
          components.WorkDir,
          lib.component.mode({ -- status.component.mode({ surround = { separator = "right" } })
            surround = {
              separator = "right",
            },
          }),
        },

        -- AstroNvim winbar layout
        winbar = { -- UI breadcrumbs bar
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          fallthrough = false,
          -- Winbar for terminal, neotree, and aerial.
          {
            condition = function()
              return not lib.condition.is_active()
            end,
            {
              lib.component.neotree(),
              lib.component.compiler_play(),
              lib.component.fill(),
              lib.component.compiler_redo(),
              lib.component.aerial(),
            },
          },
          -- Regular winbar
          {
            lib.component.neotree(),
            lib.component.fill(),
            lib.component.breadcrumbs(),
            lib.component.fill(),
          },
        },
        -- AstroNvim tabline layout
        tabline = {
          lib.component.tabline_conditional_padding({
            -- hl = { bg = c.black },
          }),
          lib.component.tabline_buffers({
            -- hl = function(self)
            --   local tab_type = self.tab_type
            --   if self._show_picker and self.tab_type ~= "buffer_active" then
            --     return c.tab.tab_active
            --   else
            --     return c.tab.tab_inactive
            --   end
            -- end,
          }),
          lib.component.fill({
            -- hl = c.tab.bg,
          }),
          lib.component.tabline_tabpages({
            -- hl = function(self)
            --   if self._show_picker and self.tab_type ~= "tabpage_active" then
            --     return c.tab.tab_actve
            --   else
            --     return c.tab.tab_inactive
            --   end
            -- end,
          }),
        },
        -- AstroNvim statuscolumn layout
        statuscolumn = {
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          lib.component.foldcolumn(),
          lib.component.numbercolumn(),
          lib.component.signcolumn(),
        } or nil,
      }
    end,
    config = function(_, opts)
      local heirline = require("heirline")
      local heirline_components = require("heirline-components.all")

      -- Setup
      heirline_components.init.subscribe_to_events()
      local colors = heirline_components.hl.get_colors()

      colors = vim.tbl_extend("force", colors, {
        buffer_visible_fg = colors.buffer_fg,
        buffer_visible_bg = colors.buffer_bg,
      })

      heirline.load_colors(colors)
      heirline.setup(opts)
    end,
  }, -- {
  --   "rebelot/heirline.nvim",
  --   event = { "BufRead", "BufNewFile" },
  --   config = function()
  --     local cond = require("heirline.conditions")
  --     cond.lsp_attached = function()
  --       return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
  --     end
  --
  --     local Mode = require("extra.statusline.mode")
  --     local File = require("extra.statusline.file")
  --     local Diagnostic = require("extra.statusline.diagnostic")
  --     local Git = require("extra.statusline.git")
  --     local Lsp = require("extra.statusline.lsp")
  --     local misc = require("extra.statusline.misc")
  --     local Winbar = require("extra.statusline.winbar")
  --
  --     local colors = require("extra.statusline.colors")
  --     local hl = colors.highlight
  --
  --     local Align = { provider = "%=" }
  --     local Space = setmetatable({ provider = " " }, {
  --       __call = function(_, n)
  --         return { provider = string.rep(" ", n) }
  --       end,
  --     })
  --     local Statusline = {
  --       hl = hl.StatusLine,
  --       static = {
  --         ReadOnly = {
  --           condition = function()
  --             return not vim.bo.modifiable or vim.bo.readonly
  --           end,
  --           provider = "",
  --           hl = hl.ReadOnly,
  --         },
  --       },
  --       Mode,
  --       Space,
  --       File,
  --       Space,
  --       Git,
  --       Space,
  --       Diagnostic,
  --       Align,
  --       Space,
  --       Lsp,
  --       Space,
  --       misc.TabSize,
  --       Space,
  --       misc.FileProperties,
  --       Space,
  --       misc.Percent,
  --       misc.ModifiableIndicator,
  --     }
  --
  --     local conditions = require("heirline.conditions")
  --     require("heirline").setup({
  --       statusline = Statusline,
  --       winbar = Winbar,
  --       opts = {
  --         disable_winbar_cb = function(args)
  --           return conditions.buffer_matches({
  --             buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
  --             filetype = {
  --               "^git.*",
  --               "fugitive",
  --               "Trouble",
  --               "dashboard",
  --               "neo-tree",
  --               "lazy",
  --               "mason",
  --               "toggleterm",
  --             },
  --           }, args.buf)
  --         end,
  --       },
  --     })
  --   end,
  -- },
}
