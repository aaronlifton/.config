return {
  name = "Rubocop autocorrect cop",
  builder = function()
    local rel_path = vim.fn.expand("%:p")
    local cop
    vim.ui.input({ prompt = "Cop: " }, function(input)
      cop = input
    end)

    return {
      cmd = {
        "bundle",
        "exec",
        "rubocop",
        "-A",
        "--only",
        cop,
        rel_path,
      },
      components = { "on_complete_notify", "on_complete_dispose", "default" },
    }
  end,
  condition = {
    callback = function(search)
      return string.match(vim.fn.expand("%:t"), ".rb")
    end,
  },
}
