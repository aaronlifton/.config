---@module 'snacks'

return {
  desc = "Fast and modern file picker",
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ["<a-c>"] = {
                "toggle_cwd",
                mode = { "n", "i" },
              },
            },
          },
        },
        actions = {
          ---@param p snacks.Picker
          toggle_cwd = function(p)
            local root = Util.lazy.root({ buf = p.input.filter.current_buf, normalize = true })
            local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>,",                                          function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>/",                                          function() Snacks.picker.grep() end,                                    desc = "Grep (Root Dir)" },
      { "<leader>:",                                          function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader><space>",                                    function() Snacks.picker.files() end,                                   desc = "Find Files (Root Dir)" },
      { "<leader>n",                                          function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      -- find
      { "<leader>fb",                                         function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>fB",                                         function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
      { "<leader>fc, Snacks.picker., desc = Find Config File" },
      { "<leader>ff",                                         function() Snacks.picker.files() end,                                   desc = "Find Files (Root Dir)" },
      { "<leader>fF",                                         function() Snacks.picker.files({ root = false }) end,                   desc = "Find Files (cwd)" },
      { "<leader>fg",                                         function() Snacks.picker.git_files() end,                               desc = "Find Files (git-files)" },
      { "<leader>fr",                                         function() Snacks.picker.recent() end,                                  desc = "Recent" },
      { "<leader>fR",                                         function() Snacks.picker.recent({ filter = { cwd = true } }) end,       desc = "Recent (cwd)" },
      { "<leader>fp",                                         function() Snacks.picker.projects() end,                                desc = "Projects" },
      -- git
      { "<leader>gd",                                         function() Snacks.picker.git_diff() end,                                desc = "Git Diff (hunks)" },
      { "<leader>gs",                                         function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>gS",                                         function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      -- Grep
      { "<leader>sb",                                         function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>sB",                                         function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      { "<leader>sg",                                         function() Snacks.picker.grep() end,                                    desc = "Grep (Root Dir)" },
      { "<leader>sG",                                         function() Snacks.picker.grep() end,                                    { root = false },                             desc = "Grep (cwd)" },
      { "<leader>sp",                                         function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
      { "<leader>sw",                                         function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      { "<leader>sW",                                         function() Snacks.picker.grep_word() end,                               { root = false },                             desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      -- search
      { '<leader>s"',                                         function() Snacks.picker.registers() end,                               desc = "Registers" },
      { '<leader>s/',                                         function() Snacks.picker.search_history() end,                          desc = "Search History" },
      { "<leader>sa",                                         function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      { "<leader>sc",                                         function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>sC",                                         function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<leader>sd",                                         function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>sD",                                         function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      { "<leader>sh",                                         function() Snacks.picker.help() end,                                    desc = "Help Pages" },
      { "<leader>sH",                                         function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      { "<leader>si",                                         function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<leader>sj",                                         function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      { "<leader>sk",                                         function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      { "<leader>sl",                                         function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      { "<leader>sM",                                         function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      { "<leader>sm",                                         function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sR",                                         function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<leader>sq",                                         function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<leader>su",                                         function() Snacks.picker.undo() end,                                    desc = "Undotree" },
      -- ui
      { "<leader>uC",                                         function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   -- opts = function()
  --   --   local Keys = require("util.lazy.plugins.lsp.keymaps").get()
  --   --   -- stylua: ignore
  --   --   vim.list_extend(Keys, {
  --   --     { "gd",         function() Snacks.picder.lsp_definitions() end,                                              desc = "Goto Definition",       has = "definition" },
  --   --     { "gr",         function() Snacks.picker.lsp_references() end,                                               nowait = true,                  desc = "References" },
  --   --     { "gI",         function() Snacks.picder.lsp_implementations() end,                                          desc = "Goto Implementation" },
  --   --     { "gy",         function() Snacks.picker.lsp_type_definitions() end,                                         desc = "Goto T[y]pe Definition" },
  --   --     { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter }) end,           desc = "LSP Symbols",           has = "documentSymbol" },
  --   --     { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
  --   --   })
  --   -- end,
  --   config = function()
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  --       callback = function(event)
  --         -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  --         -- to define small helper and utility functions so you don't have to repeat yourself.
  --         --
  --         -- In this case, we create a function that lets us more easily define mappings specific
  --         -- for LSP related items. It sets the mode, buffer and description for us each time.
  --         local map = function(keys, func, desc, mode)
  --           mode = mode or "n"
  --           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  --         end
  --
  --         -- Rename the variable under your cursor.
  --         --  Most Language Servers support renaming across files, etc.
  --         map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
  --
  --         -- Execute a code action, usually your cursor needs to be on top of an error
  --         -- or a suggestion from your LSP for this to activate.
  --         map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
  --
  --         -- Find references for the word under your cursor.
  --         map("grr", function()
  --           Snacks.picker.lsp_references()
  --         end, "[G]oto [R]eferences")
  --
  --         -- Jump to the implementation of the word under your cursor.
  --         --  Useful when your language has ways of declaring types without an actual implementation.
  --         map("gri", function()
  --           Snacks.picker.lsp_implementations()
  --         end, "[G]oto [I]mplementation")
  --
  --         -- Jump to the definition of the word under your cursor.
  --         --  This is where a variable was first declared, or where a function is defined, etc.
  --         --  To jump back, press <C-t>.
  --         map("grd", function()
  --           Snacks.picker.lsp_definitions()
  --         end, "[G]oto [D]efinition")
  --
  --         -- WARN: This is not Goto Definition, this is Goto Declaration.
  --         --  For example, in C this would take you to the header.
  --         map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  --         map("grt", function()
  --           Snacks.picker.lsp_type_definitions()
  --         end, "[G]oto [T]ype Definition")
  --
  --         -- Fuzzy find all the symbols in your current document.
  --         --  Symbols are things like variables, functions, types, etc.
  --         -- map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
  --
  --         -- Fuzzy find all the symbols in your current workspace.
  --         --  Similar to document symbols, except searches over your entire project.
  --         -- map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
  --
  --         -- Jump to the type of the word under your cursor.
  --         --  Useful when you're not sure what type a variable is and you want to see
  --         --  the definition of its *type*, not where it was *defined*.
  --         -- map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
  --
  --         -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
  --         ---@param client vim.lsp.Client
  --         ---@param method vim.lsp.protocol.Method
  --         ---@param bufnr? integer some lsp support methods only in specific files
  --         ---@return boolean
  --         local function client_supports_method(client, method, bufnr)
  --           if vim.fn.has("nvim-0.11") == 1 then
  --             return client:supports_method(method, bufnr)
  --           else
  --             return client.supports_method(method, { bufnr = bufnr })
  --           end
  --         end
  --
  --         -- The following two autocommands are used to highlight references of the
  --         -- word under your cursor when your cursor rests there for a little while.
  --         --    See `:help CursorHold` for information about when this is executed
  --         --
  --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
  --         local client = vim.lsp.get_client_by_id(event.data.client_id)
  --         if
  --           client
  --           and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
  --         then
  --           local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
  --           vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.document_highlight,
  --           })
  --
  --           vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.clear_references,
  --           })
  --
  --           vim.api.nvim_create_autocmd("LspDetach", {
  --             group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
  --             callback = function(event2)
  --               vim.lsp.buf.clear_references()
  --               vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
  --             end,
  --           })
  --         end
  --
  --         -- The following code creates a keymap to toggle inlay hints in your
  --         -- code, if the language server you are using supports them
  --         --
  --         -- This may be unwanted, since they displace some of your code
  --         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
  --           map("<leader>th", function()
  --             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
  --           end, "[T]oggle Inlay [H]ints")
  --         end
  --       end,
  --     })
  --   end,
  -- },
  {
    "folke/todo-comments.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end,                                          desc = "Todo" },
      { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      table.insert(opts.dashboard.preset.keys, 3, {
        icon = " ",
        key = "p",
        desc = "Projects",
        action = ":lua Snacks.picker.projects()",
      })
    end,
  },
  {
    "folke/flash.nvim",
    optional = true,
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<M-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        },
      },
    },
  },
}
