local function open_parrot_chat(provider, model, target, prompt)
  local filename = vim.fn.bufname(vim.api.nvim_get_current_buf())
  if filename:match("parrot/chats") then return vim.api.nvim_win_close(0, true) end

  -- local ui = require("parrot.ui")
  target = target or "vsplit"
  local config = require("parrot.config")
  local chat_handler = config.chat_handler
  local kind = (target and target == "popup" and "popup") or "chat"
  local toggle_kind = chat_handler:toggle_resolve(kind)
  local params = { args = target }
  -- vim.api.nvim_echo({ { vim.inspect(chat_handler._toggle), "Normal" } }, true, {})
  -- vim.api.nvim_echo({ { kind, "Title" }, { vim.inspect(toggle_kind), "Normal" } }, true, {})
  local toggle_state = chat_handler._toggle[toggle_kind]
  -- vim.api.nvim_echo({ { "toggle state", "Title" }, { vim.inspect(toggle_state), "Normal" } }, true, {})
  if toggle_state and M.state.last_provider == provider then
    chat_handler:chat_toggle(params)
    chat_handler._toggle[toggle_kind] = toggle_state
    return
  else
    chat_handler._toggle[toggle_kind] = nil
  end
  chat_handler:set_provider(provider, true)
  chat_handler:switch_model(true, model, { name = provider })
  -- chat_handler:toggle_add(chat_handler._toggle_kind.chat, toggle)
  M.state.last_provider = provider
  chat_handler:chat_new(params, prompt)
end
