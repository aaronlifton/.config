vim.notify("Cursor settings loaded", vim.log.levels.INFO)
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- Common keymaps for both VSCode and standalone Neovim
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

if vim.g.vscode then
  -- VSCode-specific keymaps
  local vscode = require("vscode")

  -- File operations
  keymap.set("n", "<C-s>", function()
    vscode.action("workbench.action.files.save")
  end, { desc = "Save File" })
  keymap.set("n", "<leader>w", function()
    vscode.action("workbench.action.files.save")
  end, { desc = "Save File" })
  keymap.set("n", "<C-q>", function()
    vscode.action("workbench.action.closeActiveEditor")
  end, { desc = "Close Current Buffer" })
  keymap.set("n", "<leader>q", function()
    vscode.action("workbench.action.closeActiveEditor")
  end, { desc = "Close Current Buffer" })

  -- Window management
  keymap.set("n", "<leader>sv", function()
    vscode.action("workbench.action.splitEditorRight")
  end, { desc = "Split window vertically" })
  keymap.set("n", "<leader>sh", function()
    vscode.action("workbench.action.splitEditorDown")
  end, { desc = "Split window horizontally" })
  keymap.set("n", "<leader>se", function()
    vscode.action("workbench.action.evenEditorWidths")
  end, { desc = "Make splits equal size" })
  keymap.set("n", "<leader>sx", function()
    vscode.action("workbench.action.closeActiveEditor")
  end, { desc = "Close current split" })

  -- Tab management
  keymap.set("n", "<leader>to", function()
    vscode.action("workbench.action.newWindow")
  end, { desc = "Open new tab" })
  keymap.set("n", "<leader>tx", function()
    vscode.action("workbench.action.closeWindow")
  end, { desc = "Close current tab" })
  keymap.set("n", "<leader>tn", function()
    vscode.action("workbench.action.nextEditor")
  end, { desc = "Go to next tab" })
  keymap.set("n", "<leader>tp", function()
    vscode.action("workbench.action.previousEditor")
  end, { desc = "Go to previous tab" })
  keymap.set("n", "<leader>tf", function()
    vscode.action("workbench.action.files.newUntitledFile")
  end, { desc = "Open current buffer in new tab" })

  -- Navigation
  keymap.set("n", "<c-k>", function()
    vscode.action("workbench.action.navigateUp")
  end)
  keymap.set("n", "<c-j>", function()
    vscode.action("workbench.action.navigateDown")
  end)
  keymap.set("n", "<c-h>", function()
    vscode.action("workbench.action.navigateLeft")
  end)
  keymap.set("n", "<c-l>", function()
    vscode.action("workbench.action.navigateRight")
  end)

  -- Code navigation
  keymap.set("n", "gd", function()
    vscode.action("editor.action.revealDefinition")
  end, { desc = "Go to definition" })
  keymap.set("n", "gf", function()
    vscode.action("editor.action.revealDeclaration")
  end, { desc = "Go to declaration" })
  keymap.set("n", "gh", function()
    vscode.action("editor.action.showHover")
  end, { desc = "Show hover" })
  keymap.set("n", "gH", function()
    vscode.action("editor.action.referenceSearch.trigger")
  end, { desc = "Show references" })
  keymap.set("n", "gD", function()
    vscode.action("editor.action.peekDefinition")
  end, { desc = "Peek definition" })
  keymap.set("n", "gF", function()
    vscode.action("editor.action.peekDeclaration")
  end, { desc = "Peek declaration" })

  -- Formatting
  keymap.set("n", "=", function()
    vscode.action("editor.action.formatSelection")
  end, { desc = "Format selection" })
  keymap.set("n", "==", function()
    vscode.action("editor.action.formatDocument")
  end, { desc = "Format document" })
else
  -- Standalone Neovim keymaps
  -- Navigate vim panes better
  keymap.set("n", "<c-k>", ":wincmd k<CR>")
  keymap.set("n", "<c-j>", ":wincmd j<CR>")
  keymap.set("n", "<c-h>", ":wincmd h<CR>")
  keymap.set("n", "<c-l>", ":wincmd l<CR>")

  keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save File" })
  keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save File" })
  keymap.set("n", "<C-q>", ":qa<CR>", { desc = "Close Current Buffer" })
  keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Close Current Buffer" })

  -- window management
  keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
  keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
  keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
  keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

  keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
  keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
  keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
  keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
  keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

  keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
end

local toggleInlayHints = function()
  local isEnabled = vim.lsp.inlay_hint.is_enabled()

  if isEnabled then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end

keymap.set("n", "<leader>hi", toggleInlayHints, { desc = "Toggle inlay hints" })
