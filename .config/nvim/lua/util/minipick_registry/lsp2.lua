-- LSP2: LSP picker derived from MiniExtra's implementation.
--
-- Differences:
-- - If LSP returns a single item, jump directly without showing the picker.
-- - Symbol scopes use MiniExtra-style icons/highlighting; non-symbol scopes use default show.
local M = {}

M.win = 0 -- current window
M.tagstack = {
  items = {}, -- list of tag items (empty here)
  idx = 0, -- current position in the tagstack
}

local function push_tag()
  local tag = {
    tagname = vim.fn.expand("<cword>"),
    from = { vim.fn.bufnr("%"), vim.fn.line("."), vim.fn.col("."), 0 },
    -- optional: curidx / user_data
  }
  vim.fn.settagstack(0, { items = { tag } }, "t") -- "t" = push
end

local function create_lsp_picker(MiniPick)
  local ns_id = vim.api.nvim_create_namespace("minipick-lsp2")
  local allowed_scopes = {
    "declaration",
    "definition",
    "document_symbol",
    "document_symbol_live",
    "implementation",
    "references",
    "type_definition",
    "workspace_symbol",
    "workspace_symbol_live",
  }

  local function validate_scope(scope)
    for _, name in ipairs(allowed_scopes) do
      if name == scope then return scope end
    end
    error("`lsp2` scope is not supported: " .. tostring(scope))
  end

  local function prepend_position(item)
    local path = item.path or item.filename
    if path ~= nil then item.path = path end

    local text = item.text or ""
    if path == nil then
      item.text = text
      return item
    end

    local rel = vim.fn.fnamemodify(path, ":.")
    local lnum = item.lnum or 1
    local col = item.col or 1
    item.text = string.format("%s:%d:%d: %s", rel, lnum, col, text)
    return item
  end

  local function lsp_items_compare(a, b)
    local a_path, b_path = a.path or "", b.path or ""
    if a_path ~= b_path then return a_path < b_path end

    local a_lnum, b_lnum = a.lnum or 1, b.lnum or 1
    if a_lnum ~= b_lnum then return a_lnum < b_lnum end

    local a_col, b_col = a.col or 1, b.col or 1
    if a_col ~= b_col then return a_col < b_col end

    return tostring(a) < tostring(b)
  end

  local function jump_to_item(item)
    if MiniPick.is_picker_active() then MiniPick.stop() end
    MiniPick.default_choose(item)
  end

  -- Reuse from Util.lsp
  local item_matches_cursor = Util.lsp.item_matches_cursor
  local dedupe_by_location = Util.lsp.dedupe_by_location

  local function pick_start(items, picker_opts, opts)
    local source = vim.tbl_deep_extend(
      "force",
      { items = items, choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked },
      picker_opts.source or {}
    )

    local start_opts = vim.tbl_deep_extend("force", picker_opts, opts or {}, { source = source })

    return MiniPick.start(start_opts)
  end

  local function get_symbol_kind_map()
    local res = {}
    local double_map = vim.lsp.protocol.SymbolKind
    for k, v in pairs(double_map) do
      if type(k) == "string" and type(v) == "number" then res[double_map[v]] = k end
    end
    return res
  end

  -- Returns LazyVim's symbol kinds
  -- lua = {
  --   "Class", "Constructor", "Enum", "Field", "Function", "Interface",
  --   "Method", "Module", "Namespace", "Property", "Struct", "Trait"
  -- }
  local function get_kind_filter()
    local ok, LazyVim = pcall(require, "lazyvim.config")
    if not ok or not LazyVim or not LazyVim.get_kind_filter then return end

    local buf_id = vim.api.nvim_get_current_buf()
    if MiniPick.is_picker_active() then
      local win_id = MiniPick.get_picker_state().windows.target
      if win_id then buf_id = vim.api.nvim_win_get_buf(win_id) end
    end

    return LazyVim.get_kind_filter(buf_id)
  end

  local function filter_symbols_by_kind(items)
    local kind_filter = get_kind_filter()
    if not kind_filter or #kind_filter == 0 then return items end

    local allowed = {}
    for _, kind in ipairs(kind_filter) do
      if type(kind) == "string" then allowed[kind] = true end
    end

    local filtered = {}
    for _, item in ipairs(items) do
      if item.kind == nil or allowed[item.kind] then filtered[#filtered + 1] = item end
    end

    return filtered
  end

  local function lsp_make_opts(source, opts)
    local is_symbol = source:find("symbol") ~= nil
    local picker_opts = { source = { name = string.format("LSP (%s)", source) } }

    local add_decor_data = function() end
    if is_symbol and _G.MiniIcons == nil then
      add_decor_data = function(item)
        item.hl = string.format("@%s", string.lower(item.kind or "unknown"))
      end
    end
    if is_symbol and _G.MiniIcons ~= nil then
      add_decor_data = function(item)
        if type(item.kind) ~= "string" then return end
        local icon, hl = MiniIcons.get("lsp", item.kind)
        local icon_prefix = item.kind_orig == item.kind and (icon .. " ") or ""
        item.text, item.hl = icon_prefix .. item.text, hl
      end
    end

    local function process(items)
      if source ~= "document_symbol" and source ~= "document_symbol_live" then
        items = vim.tbl_map(prepend_position, items)
      else
        for _, item in ipairs(items) do
          if item.filename or item.path then item.path = item.filename or item.path end
          item.text = item.text or ""
        end
      end
      if is_symbol then
        local kind_map = get_symbol_kind_map()
        for _, item in ipairs(items) do
          local orig = item.kind
          item.kind_orig = orig
          if type(orig) == "number" then
            item.kind = kind_map[orig]
          else
            item.kind = orig
          end
        end

        -- Util.debug.echo_once({ items = items }, "lsp2 otems before filter")
        -- NOTE: This only filters to functions
        items = filter_symbols_by_kind(items)

        for _, item in ipairs(items) do
          add_decor_data(item)
          item.kind_orig = nil
        end
      end
      table.sort(items, lsp_items_compare)
      return items
    end

    -- local show_explicit = MiniPick.config.source.show
    -- local sep = string.char(31)
    -- local sep_pattern = vim.pesc(sep)
    picker_opts.source.show = function(buf_id, items, query)
      -- if show_explicit ~= nil then return show_explicit(buf_id, items_to_show, query) end
      if items and #items > 0 then -- one buffer, one ft: Enable highlighting
        -- items = require("mini.align").align_strings(items, {
        --   justify_side = { "left", "right", "right" },
        --   merge_delimiter = { "", " ", "", " ", "" },
        --   split_pattern = "|",
        -- })
        local win_id = MiniPick.get_picker_state().windows.target
        local buf = vim.api.nvim_win_get_buf(win_id)
        local ft = vim.filetype.match({ buf = buf })
        -- local lang = vim.treesitter.language.get_lang(ft)
        -- local lang = Snacks.util.get_lang(ft)
        -- if vim.tbl_contains({ "latex" }, lang) then lang = nil end
        -- vim.api.nvim_echo({ { vim.inspect({ buf = buf, lang = lang, ft = ft }), "Normal" } }, true, {})
        --
        -- if not (lang and pcall(vim.treesitter.start, buf, lang)) then vim.bo[buf].syntax = ft end
        if ft then vim.bo[buf_id].filetype = ft end
      end
      if not is_symbol then return MiniPick.default_show(buf_id, items, query) end

      MiniPick.default_show(buf_id, items, query)

      -- vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)
      -- for i, item in ipairs(items) do
      --   if item.hl ~= nil then vim.api.nvim_buf_add_highlight(buf_id, ns_id, item.hl, i - 1, 0, -1) end
      -- end
    end

    local on_list = function(data)
      local items = data.items or {}
      for _, item in ipairs(items) do
        item.text = item.text or item.name or ""
        item.path = item.path or item.filename
      end
      items = process(items)

      if source == "definition" then items = dedupe_by_location(items) end

      if #items == 1 then
        jump_to_item(items[1])
        return
      end
      if source == "references" and #items == 2 then
        local buf_id = vim.api.nvim_get_current_buf()
        if item_matches_cursor(items[1], buf_id) then
          jump_to_item(items[2])
          return
        end
        if item_matches_cursor(items[2], buf_id) then
          jump_to_item(items[1])
          return
        end
      end

      if source == "workspace_symbol_live" and MiniPick.is_picker_active() then
        return MiniPick.set_picker_items(items, { do_match = false })
      end
      if source == "document_symbol_live" and MiniPick.is_picker_active() then
        return MiniPick.set_picker_items(items, { do_match = true })
      end

      return pick_start(items, picker_opts, opts)
    end

    return { on_list = on_list }, picker_opts, process
  end

  return function(local_opts, opts)
    local_opts = vim.tbl_deep_extend("force", { scope = nil, symbol_query = "" }, local_opts or {})

    if local_opts.scope == nil then error("`lsp2` needs an explicit scope.") end
    local scope = validate_scope(local_opts.scope)

    local buf_lsp_opts, picker_opts, process_items = lsp_make_opts(scope, opts)
    if scope == "definition" then push_tag() end
    if scope == "references" then
      push_tag()
      return vim.lsp.buf[scope](nil, buf_lsp_opts)
    end
    if scope == "workspace_symbol" then
      local query = tostring(local_opts.symbol_query)
      return vim.lsp.buf[scope](query, buf_lsp_opts)
    end
    if scope == "workspace_symbol_live" then
      local set_items_opts = { do_match = false, querytick = MiniPick.get_querytick() }

      picker_opts.source.match = function(_, _, query)
        local querytick = MiniPick.get_querytick()
        if querytick == set_items_opts.querytick then return end
        if #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end

        set_items_opts.querytick = querytick

        local win_id = MiniPick.get_picker_state().windows.target
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        vim.api.nvim_buf_call(buf_id, function()
          vim.lsp.buf.workspace_symbol(table.concat(query), {
            on_list = function(data)
              -- Discard stale responses
              if set_items_opts.querytick ~= MiniPick.get_querytick() then return end
              local items = data.items or {}
              for _, item in ipairs(items) do
                item.text = item.text or item.name or ""
                item.path = item.path or item.filename
              end
              items = process_items(items)
              MiniPick.set_picker_items(items, set_items_opts)
            end,
          })
        end)
      end

      return pick_start({}, picker_opts, opts)
    end
    if scope == "document_symbol_live" then
      local requested = false
      local client_requested = false
      picker_opts.source.match = function(stritems, inds, query)
        if not requested then
          requested = true
          local win_id = MiniPick.get_picker_state().windows.target
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          if not client_requested then
            vim.api.nvim_buf_call(buf_id, function()
              vim.lsp.buf.document_symbol(buf_lsp_opts)
            end)
            client_requested = true
          end
          -- local bufnr = vim.fn.bufnr()
          -- local clients = vim.lsp.get_clients({ bufnr = bufnr })
          -- for _, client in ipairs(clients) do
          --   if client:supports_method("document_symbol", bufnr) then c = client end
          -- end
        end
        return MiniPick.default_match(stritems, inds, query)
      end
      return pick_start({}, picker_opts, opts)
    end
    vim.lsp.buf[scope](buf_lsp_opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.lsp2 = create_lsp_picker(MiniPick)
end

return M
