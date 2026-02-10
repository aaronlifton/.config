---@type LazyPicker
local picker = {
  name = "snacks",
  commands = {
    files = "files",
    live_grep = "grep",
    oldfiles = "recent",
  },

  ---@param source string
  ---@param opts? snacks.picker.Config
  open = function(source, opts)
    return Snacks.picker.pick(source, opts)
  end,
}

vim.g.lazyvim_picker = "snacks"
LazyVim.pick.name = "snacks"
if not LazyVim.pick.register(picker) then return {} end

return {
  desc = "Fast and modern file picker",
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>,", false },
      { "<leader>/", false },
      { "<leader>:", false },
      { "<leader><space>", false },
      { "<leader>fb", false },
      { "<leader>fB", false },
      { "<leader>fc", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fg", false },
      { "<leader>fr", false },
      { "<leader>fR", false },
      { "<leader>gd", false },
      { "<leader>gs", false },
      { "<leader>gS", false },
      -- { "<leader>sb", false},
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sp", false },
      { "<leader>sw", false },
      { "<leader>sW", false },
      { "<leader>su", false },
      { "<leader>sU", false },
      { "<leader>s/", false },
      { "<leader>sa", false },
      { "<leader>sc", false },
      { "<leader>sC", false },
      -- { "<leader>sd", false},
      -- { "<leader>sD", false},
      { "<leader>sH", false },
      { "<leader>sl", false },
      { "<leader>sM", false },
      { "<leader>sm", false },
      { "<leader>sR", false },
      { "<leader>sq", false },
      { "<leader>sj", false },
      { '<leader>s"', false },
      { "<leader>sh", false },
      { "<leader>uC", false },
    },
  },
  {
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = {
      {
        "<leader>,",
        function()
          Snacks.picker.buffers({ layout = { preset = "center", layout = { height = 0.4 } } })
        end,
        desc = "Buffers",
      },
      { "<leader>/", LazyVim.pick("grep"), desc = "Grep (Root Dir)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader><space>", LazyVim.pick("files", { layout = { preset = "center" }}), desc = "Find Files (Root Dir)" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
      { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
      { "<leader>f<C-f>", false },
      { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>sj", false},
      { "<leader>fj", LazyVim.pick("jumps"), desc = "Jumps" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
      -- { "<leader>fr", LazyVim.pick("oldfiles"), desc = "Recent" },
      { "<leader>fr", LazyVim.pick("oldfiles", { filter  = { paths = { [vim.fn.stdpath("data")] = true } } }), desc = "Recent" },
      { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
      { "<leader>fp", function() Snacks.picker.files({ title = "Plugins", dirs = { get_lazyvim_plugins_dir() }}) end, desc = "Find Config Files" },
      { "<leader>fl", function() Snacks.picker.files({ title = "LazyVim", dirs = { get_lazyvim_base_dir() }}) end, desc = "Find LazyVim Files" },
      {
        "<leader>f<C-t>",
        function()
          Snacks.picker.files({
            title = "Today",
            args = { "--changed-within", "1d", "--no-ignore" },
            layout = { layout = { height = 0.4, width = 0.4 } },
          })
        end,
        desc = "Today",
      },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sw", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      { "<leader>sW", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      -- Added these
      { "<leader>su", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      { "<leader>sU", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      { "<leader>sp", LazyVim.pick("live_grep", { title = "Plugins", dirs = { get_lazyvim_plugins_dir() } }), desc = "Grep Plugins" },
      { "<leader>s<M-c>", LazyVim.pick("live_grep", { title = "Config", dirs = { vim.fn.stdpath("config") } }), desc = "Grep Config Files" },
      { "<leader>s<M-l>", LazyVim.pick("live_grep", { title = "LazyVim", dirs = { get_lazyvim_base_dir() } }), desc = "Grep LazyVim Files" },
      {
        "<leader>sN",
        function()
          local path = Util.picker.node_modules_dir()
          if not path then return end
          Snacks.picker.grep({ title = "Node Modules", dirs = { path } })
        end,
        desc = "Grep Plugins"
      },
      {
        "<leader>s<M-r>",
        function()
          Util.picker.gem_dir(function(path, name)
            Snacks.picker.grep({ title = name, dirs = { path } })
          end)
        end,
      },
      {
        "<leader>s<C-m>",
        function()
          -- Grep ruby gem or node module dir, if current buf is a file inside of one
          local result = Util.picker.node_module_subdir()
          if result then
            local path = result.path or result
            local display = result.display
            Snacks.picker.grep({ title = ("node_modules/%s"):format(display), dirs = { path } })
          end
        end,
        desc = "Node module subdir",
      },
      -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      -- search
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      -- Switched these around
      -- { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      -- { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", has = "definition" },
            { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Symbols", has = "documentSymbol" },
            { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
            { "<leader>s<M-s>", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter, layout = { preset = "vscode" } }) end, desc = "LSP Symbols", has = "documentSymbol", },
            { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" },
            { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" },
          },
        },
      },
    },
  },
}
