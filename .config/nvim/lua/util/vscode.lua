if not vim.g.vscode then return {} end
vim.notify("VSCode settings loaded", vim.log.levels.INFO)

local enabled = {
  "LazyVim",
  "dial.nvim",
  "flit.nvim",
  "lazy.nvim",
  "leap.nvim",
  "mini.ai",
  "mini.comment",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "snacks.nvim",
  "ts-comments.nvim",
  "vim-repeat",
  "yanky.nvim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end
vim.g.snacks_animate = false

local map = vim.keymap.set

-- Options
vim.o.spell = false
vim.opt.timeoutlen = 150 -- To show whichkey without delay

local vscode = require("vscode")

vim.notify = vscode.notify
vim.g.clipboard = vim.g.vscode_clipboard

local function vscode_action(cmd, opts)
  -- return function()
  --   vscode.action(cmd, opts)
  -- end
  return [[<cmd>call VSCodeNotify(']] .. cmd .. [[')<cr>]]
end

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymapsDefaults",
  callback = function()
    function action(method, opts)
      return function()
        vscode.action(method, opts)
      end
    end

    function actions(methods, opts)
      return function()
        for _, method in ipairs(methods) do
          vscode.action(method, opts)
        end
      end
    end

    vim.keymap.set(
      "n",
      "<leader>,",
      actions({
        "workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup",
        "workbench.action.acceptSelectedQuickOpenItem",
      })
    )
    vim.keymap.set("n", "<leader>fd", action("workbench.actions.view.problems"))
    vim.keymap.set("n", "<leader>fR", action("editor.action.goToReferences"))
    vim.keymap.set("n", "<leader>m", action("workbench.action.showAllEditorsByMostRecentlyUsed"))

    -- Basic
    vim.keymap.set("n", "<enter>", action("workbench.action.files.save"))
    vim.keymap.set("n", "gF", action("editor.action.formatDocument"))
    vim.keymap.set("n", "<leader>gd", action("git.openChange"))
    -- Keep undo/redo in sync with VSCode (for persistent undo and fixes auto
    -- write happening with undo)
    -- https://github.com/vscode-neovim/vscode-neovim/issues/1139
    vim.keymap.set("n", "u", action("undo"))
    vim.keymap.set("n", "U", action("redo"))
    -- VSCode undo can create visual selections, so we have to remap it in visual
    -- mode as well to avoid accidentally changing case.
    vim.keymap.set("v", "u", action("undo"))
    vim.keymap.set("v", "U", action("redo"))
    vim.keymap.set("n", "<leader>ss", action("workbench.scm.focus"))

    -- LSP
    vim.keymap.set("n", "<leader>rn", action("editor.action.rename"))
    vim.keymap.set("n", "gD", action("editor.action.showHover"))
    vim.keymap.set("n", "<leader>bb", actions({ "editor.action.marker.next", "editor.action.quickFix" }))

    -- Splits
    vim.keymap.set(
      "n",
      "<leader>hs",
      actions({ "workbench.action.splitEditorDown", "workbench.action.evenEditorWidths" })
    )
    vim.keymap.set(
      "n",
      "<leader>vs",
      actions({ "workbench.action.splitEditorRight", "workbench.action.evenEditorWidths" })
    )

    -- Navigation
    vim.keymap.set("n", "<f3>", action("workbench.action.focusActiveEditorGroup"))
    vim.keymap.set("n", "<f4>", action("workbench.action.terminal.toggleTerminal"))
    vim.keymap.set("n", "<leader>nn", action("workbench.action.toggleSidebarVisibility"))
    vim.keymap.set("n", "<leader>nf", action("workbench.files.action.showActiveFileInExplorer"))
    vim.keymap.set("n", "<up>", "17k", { noremap = true, silent = true })
    vim.keymap.set("n", "<down>", "17j", { noremap = true, silent = true })
    vim.keymap.set("v", "<up>", "17k", { noremap = true, silent = true })
    vim.keymap.set("v", "<down>", "17j", { noremap = true, silent = true })
    vim.keymap.set("n", "gn", actions({ "editor.action.marker.next", "closeMarkersNavigation" }))
    vim.keymap.set("n", "gN", actions({ "editor.action.marker.prev", "closeMarkersNavigation" }))
    vim.keymap.set("n", "<leader>gn", action("workbench.action.editor.nextChange"))
    vim.keymap.set("n", "<leader>gN", action("workbench.action.editor.previousChange"))

    -- Unmap q because I keep getting stuck in macro recording accidentally
    vim.keymap.set("n", "q", "<nop>", { noremap = true })

    -- Testing
    vim.keymap.set("n", "<leader>tt", action("testing.runAtCursor"))
    vim.keymap.set("n", "<leader>td", action("testing.debugAtCursor"))
    vim.keymap.set("n", "<leader>tT", action("testing.runCurrentFile"))
    vim.keymap.set("n", "<leader>tn", action("testing.goToNextMessage"))
    vim.keymap.set("n", "<leader>tN", action("testing.goToPreviousMessage"))
    vim.keymap.set("n", "<leader>tc", action("testing.toggleContinuousRunForTest"))
    vim.keymap.set("n", "<leader>tf", action("workbench.view.testing.focus"))

    -- ----------
    -- Extensions
    -- ----------

    -- Neovim Extension Itself
    vim.keymap.set("n", "<leader>nr", action("vscode-neovim.restart"))

    -- Periscope
    vim.keymap.set("n", "<leader>fr", action("periscope.search"))

    -- LazyGit
    vim.keymap.set("n", "<leader>gg", action("lazygit-vscode.toggle"))
    -- Find It Faster
    vim.keymap.set("n", "<leader>fr", action("find-it-faster.findWithinFiles"))
  end,
})

-- Search
-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymapsDefaults",
  callback = function()
    -- view problems
    map("n", "<leader>xx", vscode_action("workbench.actions.view.problems"))
    -- open file explorer
    map("n", "<leader>e", vscode_action("workbench.view.explorer"))
    -- terminal
    map("n", [[<c-\>]], vscode_action("workbench.action.terminal.toggleTerminal"))
    map("n", "<leader>fts", vscode_action("workbench.action.terminal.newWithCwd"))
    -- working with editors (buffers)
    map("n", "<leader>bo", vscode_action("workbench.action.closeOtherEditors"))
    map("n", "<leader>bb", function()
      vscode_action("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup")
      vscode_action("list.select")
    end)
    map("n", "<leader>bn", vscode_action("workbench.action.nextEditor"))
    map("n", "<leader>bu", vscode_action("workbench.action.reopenClosedEditor"))
    map("n", "<leader>bh", vscode_action("workbench.action.moveEditorToLeftGroup"))
    map("n", "<leader>bj", vscode_action("workbench.action.moveEditorToBelowGroup"))
    map("n", "<leader>bk", vscode_action("workbench.action.moveEditorToAboveGroup"))
    map("n", "<leader>bl", vscode_action("workbench.action.moveEditorToRightGroup"))
    map("n", "<leader>,", vscode_action("workbench.action.showAllEditors"))
    map("n", "<leader>bA", vscode_action("workbench.action.closeAllEditors"))
    map("n", "<leader>ba", vscode_action("workbench.action.lastEditorInGroup"))
    map("n", "<leader>bf", vscode_action("workbench.action.firstEditorInGroup"))
    map("n", "<Leader>bL", vscode_action("workbench.action.closeEditorsToTheLeft"))
    map("n", "<Leader>bR", vscode_action("workbench.action.closeEditorsToTheRight"))
    map("n", "H", vscode_action("workbench.action.previousEditorInGroup"))
    map("n", "L", vscode_action("workbench.action.nextEditorInGroup"))
    map("n", "<leader>bd", vscode_action("workbench.action.closeActiveEditor"))
    map("n", "<leader><tab>", vscode_action("workbench.action.showMultipleEditorTabs"))
    map("n", "<leader><s-tab>", vscode_action("workbench.action.showEditorTab"))
    -- breakpoints
    map("n", "<F2>", vscode_action("editor.debug.action.toggleBreakpoint"))
    -- windows
    map("n", "<leader>|", vscode_action("workbench.action.splitEditorRight"))
    map("n", "<leader>-", vscode_action("workbench.action.splitEditorDown"))
    -- LSP actions
    map("n", "<leader>ca", vscode_action("editor.action.codeAction"))
    map("n", "gy", vscode_action("editor.action.goToTypeDefinition"))
    map("n", "gr", vscode_action("editor.action.goToReferences"))
    map("n", "gi", vscode_action("editor.action.goToImplementation"))
    map("n", "K", vscode_action("editor.action.showHover"))
    map("n", "<leader>cr", vscode_action("editor.action.rename"))
    map("n", "<leader>co", vscode_action("editor.action.organizeImports"))
    map("n", "<leader>cf", vscode_action("editor.action.formatDocument"))
    map("n", "<leader>sS", vscode_action("workbench.action.showAllSymbols"))
    -- refactor
    map("n", "<leader>cR", vscode_action("editor.action.refactor"))
    -- markdown preview
    map("n", "<leader>cp", vscode_action("markdown.showPreviewToSide"))
    -- project manager
    map("n", "<leader>fp", vscode_action("projectManager.listProjects"))
    -- zen mode
    map("n", "<leader>z", vscode_action("workbench.action.toggleZenMode"))
    -- cspell
    map("n", "<leader>!", vscode_action("cSpell.addWordToDictionary"))
    map("n", "<leader>us", vscode_action("cSpell.toggleEnableSpellChecker"))
    -- comments
    map("n", "<leader>xt", vscode_action("workspaceAnchors.focus"))
    -- git
    map("n", "<leader>gg", vscode_action("gitlens.views.home.focus"))
    map("n", "<leader>ub", vscode_action("gitlens.toggleFileBlame"))
    map("n", "]h", function()
      vscode_action("workbench.action.editor.nextChange")
      vscode_action("workbench.action.compareEditor.nextChange")
    end)
    map("n", "[h", function()
      vscode_action("workbench.action.editor.previousChange")
      vscode_action("workbench.action.compareEditor.previousChange")
    end)
    -- statusline
    map("n", "<leader>uS", vscode_action("workbench.action.toggleStatusbarVisibility"))
    -- codeium
    -- diagnostics
    map("n", "]d", vscode_action("editor.action.marker.next"))
    map("n", "[d", vscode_action("editor.action.marker.prev"))
    -- zoxide
    map("n", "<leader>fz", vscode_action("autojump.openFolder"))
    -- whichkey
    map("n", "<leader>", vscode_action("whichkey.show"))
    -- search
    map("n", "<leader><space>", "<cmd>Find<cr>")
    map("n", "<leader>ff", "<cmd>Find<cr>")
    -- LazyVim defaults
    -- map("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
    -- map("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])
    map("n", "<leader>sg", vscode_action("workbench.action.findInFiles"))
    map("n", "<leader>sc", vscode_action("workbench.action.showCommands"))
    -- ui
    map("n", "<leader>uC", vscode_action("workbench.action.selectTheme"))
  end,
})

return {
  { import = "lazyvim.plugins.extras.vscode" },
  {
    "LazyVim/LazyVim",
    config = function(_, opts)
      opts = opts or {}
      -- disable the colorscheme
      opts.colorscheme = function() end
      require("lazyvim").setup(opts)
    end,
  },
  {
    "nvim-mini/mini.nvim",
    optional = true,
    config = function()
      require("mini.extra").setup()
      -- require("mini.move").setup()
      -- require("mini.colors").setup()
    end,
  },
  -- {
  --   "folke/flash.nvim",
  --   enabled = false,
  --   init = function()
  --     local palette = require("catppuccin.palettes").get_palette("macchiato")
  --     local bg = palette.none
  --     vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = bg })
  --     vim.api.nvim_set_hl(0, "FlashLabel", { fg = palette.green, bg = bg, bold = true })
  --     vim.api.nvim_set_hl(0, "FlashMatch", { fg = palette.lavender, bg = bg })
  --     vim.api.nvim_set_hl(0, "FlashCurrent", { fg = palette.peach, bg = bg })
  --   end,
  -- },
}
