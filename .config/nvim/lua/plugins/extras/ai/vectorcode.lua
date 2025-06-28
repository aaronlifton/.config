local prompt = function(prefix, suffix)
  local retrieval_results = require("vectorcode").query("some query message", {
    n_query = 5,
  })
  local file_context = ""
  for _, source in pairs(retrieval_results) do
    -- This works for qwen2.5-coder.
    file_context = file_context .. "<|file_sep|>" .. source.path .. "\n" .. source.document .. "\n"
  end
  return file_context .. "<|fim_prefix|>" .. prefix .. "<|fim_suffix|>" .. suffix .. "<|fim_middle|>"
end

--  vc_cacher = require("vectorcode.config").get_cacher_backend()

return {
  "Davidyz/VectorCode",
  version = "*",
  build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
  -- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- Default opts
    cli_cmds = {
      vectorcode = "vectorcode",
    },
    ---@type VectorCode.RegisterOpts
    async_opts = {
      debounce = 10,
      events = { "BufWritePost", "InsertEnter", "BufReadPost" },
      exclude_this = true,
      n_query = 1,
      notify = false,
      query_cb = require("vectorcode.utils").make_surrounding_lines_cb(-1),
      run_on_register = false,
    },
    async_backend = "default", -- or "lsp"
    exclude_this = true,
    n_query = 1,
    notify = true,
    timeout_ms = 5000,
    on_setup = {
      update = false, -- set to true to enable update when `setup` is called.
      lsp = false,
    },
    sync_log_env_var = false,
  },
  config = function(_, opts)
    require("vectorcode").setup(opts)
    local cacher = require("vectorcode.config").get_cacher_backend()
    local fts = { "*.go", "*.js", "*.ts", "*.ruby", "*.sql", "*.md" }
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = fts,
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        cacher.async_check("config", function()
          cacher.register_buffer(bufnr, {
            n_query = 10, -- 1
          })
        end, nil)
      end,
      desc = "Register buffer for VectorCode",
    })
    -- TODO: do we need this?
    -- vim.api.nvim_create_autocmd({ "BufDelete" }, {
    --   pattern = fts,
    --   callback = function(args)
    --     if cacher.buf_is_registered(args.buf) then cacher.deregister_buffer(args.buf) end
    --   end,
    -- })
  end,
}
