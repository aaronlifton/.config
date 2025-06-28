-- lua/code-vectorizer/init.lua
local M = {}

-- Configuration
local config = {
  rust_binary_path = "code-vectorizer", -- Path to compiled Rust binary
  max_results = 10,
  similarity_threshold = 0.7,
  auto_index = true,
  keymaps = {
    search_similar = "<leader>vs",
    index_project = "<leader>vi",
    search_global = "<leader>vg",
  },
}

-- State
local state = {
  indexed_projects = {},
  search_results = {},
  loading = false,
}

-- Utility functions
local function get_project_root()
  local markers = { ".git", "Cargo.toml", "go.mod", "package.json" }
  local current_dir = vim.fn.expand("%:p:h")

  while current_dir ~= "/" do
    for _, marker in ipairs(markers) do
      if
        vim.fn.isdirectory(current_dir .. "/" .. marker) == 1
        or vim.fn.filereadable(current_dir .. "/" .. marker) == 1
      then
        return current_dir
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return vim.fn.getcwd()
end

local function execute_rust_command(command, args, callback)
  local cmd = { config.rust_binary_path, command }
  for _, arg in ipairs(args or {}) do
    table.insert(cmd, arg)
  end

  local output = {}
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then table.insert(output, line) end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        local result = table.concat(output, "\n")
        if result ~= "" then
          local success, parsed = pcall(vim.fn.json_decode, result)
          if success then
            callback(nil, parsed)
          else
            callback("Failed to parse JSON response", nil)
          end
        else
          callback(nil, {})
        end
      else
        callback("Command failed with exit code " .. exit_code, nil)
      end
    end,
  })

  if job_id <= 0 then callback("Failed to start command", nil) end
end

-- Core functions
function M.index_project(path)
  path = path or get_project_root()

  if state.loading then
    vim.notify("Indexing already in progress", vim.log.levels.WARN)
    return
  end

  state.loading = true
  vim.notify("Starting to index project: " .. path, vim.log.levels.INFO)

  execute_rust_command("index", { path }, function(err, result)
    state.loading = false

    if err then
      vim.notify("Indexing failed: " .. err, vim.log.levels.ERROR)
    else
      state.indexed_projects[path] = true
      vim.notify("Project indexed successfully!", vim.log.levels.INFO)
    end
  end)
end

function M.search_similar_code(query, show_results)
  query = query or vim.fn.input("Search query: ")
  if query == "" then return end

  local project_root = get_project_root()
  if not state.indexed_projects[project_root] then
    vim.notify("Project not indexed. Run :CodeVectorizerIndex first", vim.log.levels.WARN)
    return
  end

  execute_rust_command("search", { query, "--limit", tostring(config.max_results) }, function(err, results)
    if err then
      vim.notify("Search failed: " .. err, vim.log.levels.ERROR)
      return
    end

    state.search_results = results or {}

    if show_results ~= false then M.show_search_results() end
  end)
end

function M.search_current_function()
  -- Get current function context
  local current_line = vim.api.nvim_get_current_line()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Try to extract function signature or meaningful context
  local function_context = M.extract_function_context(bufnr, cursor_pos[1])

  if function_context then
    M.search_similar_code(function_context, true)
  else
    -- Fallback to current line
    M.search_similar_code(current_line, true)
  end
end

function M.extract_function_context(bufnr, line_num)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

  -- Simple heuristic to find function signature
  for i = line_num, math.max(1, line_num - 10), -1 do
    local line = lines[i]
    if line then
      -- Rust function detection
      if filetype == "rust" and line:match("^%s*fn%s+") then return line:gsub("^%s*", "") end
      -- Go function detection
      if filetype == "go" and line:match("^%s*func%s+") then return line:gsub("^%s*", "") end
    end
  end

  return nil
end

function M.show_search_results()
  if #state.search_results == 0 then
    vim.notify("No search results found", vim.log.levels.INFO)
    return
  end

  -- Create quickfix list
  local qf_list = {}
  for _, result in ipairs(state.search_results) do
    table.insert(qf_list, {
      filename = result.file_path,
      lnum = result.line_number,
      col = 1,
      text = string.format("[%.2f] %s::%s", result.similarity, result.package_name, result.function_name),
      type = "I",
    })
  end

  vim.fn.setqflist(qf_list, "r")
  vim.cmd("copen")
  vim.notify(string.format("Found %d similar code snippets", #state.search_results), vim.log.levels.INFO)
end

function M.show_floating_results()
  if #state.search_results == 0 then
    vim.notify("No search results found", vim.log.levels.INFO)
    return
  end

  local lines = {}
  local highlights = {}

  for i, result in ipairs(state.search_results) do
    local header = string.format("%d. [%.2f] %s::%s", i, result.similarity, result.package_name, result.function_name)
    table.insert(lines, header)
    table.insert(highlights, { line = #lines - 1, hl_group = "Title" })

    local location = string.format("   %s:%d", result.file_path, result.line_number)
    table.insert(lines, location)
    table.insert(highlights, { line = #lines - 1, hl_group = "Comment" })

    -- Add code snippet preview
    local code_lines = vim.split(result.code_snippet, "\n")
    for j, code_line in ipairs(code_lines) do
      if j <= 3 then -- Limit preview lines
        table.insert(lines, "   " .. code_line)
      end
    end

    table.insert(lines, "") -- Empty line separator
  end

  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Apply highlights
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(buf, -1, hl.hl_group, hl.line, 0, -1)
  end

  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 4)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = " Search Results ",
    title_pos = "center",
  })

  -- Set up keymaps for the floating window
  local opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", opts)
end

-- Configuration
function M.setup(user_config)
  config = vim.tbl_extend("force", config, user_config or {})

  -- Set up commands
  vim.api.nvim_create_user_command("CodeVectorizerIndex", function(opts)
    M.index_project(opts.args ~= "" and opts.args or nil)
  end, { nargs = "?", complete = "dir" })

  vim.api.nvim_create_user_command("CodeVectorizerSearch", function(opts)
    M.search_similar_code(opts.args)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("CodeVectorizerSearchFunction", function()
    M.search_current_function()
  end, {})

  -- Set up keymaps
  if config.keymaps.search_similar then
    vim.keymap.set("n", config.keymaps.search_similar, M.search_current_function, { desc = "Search for similar code" })
  end

  if config.keymaps.index_project then
    vim.keymap.set("n", config.keymaps.index_project, M.index_project, { desc = "Index current project" })
  end

  if config.keymaps.search_global then
    vim.keymap.set("n", config.keymaps.search_global, function()
      M.search_similar_code()
    end, { desc = "Global code search" })
  end

  -- Auto-index on project open (if enabled)
  if config.auto_index then
    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
      callback = function()
        local project_root = get_project_root()
        if not state.indexed_projects[project_root] then
          vim.defer_fn(function()
            if vim.fn.confirm("Index this project for code search?", "&Yes\n&No", 1) == 1 then
              M.index_project(project_root)
            end
          end, 1000)
        end
      end,
    })
  end
end

return M
