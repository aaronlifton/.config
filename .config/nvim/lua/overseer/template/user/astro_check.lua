local overseer = require("overseer")
-- overseer.add_template_hook({ name = "cargo clean" }, function(task_defn, util)
--   util.remove_component(task_defn, "on_complete_notify")
-- end)

---@type overseer.TemplateFileDefinition
return {
  name = "astro_check",
  builder = function()
    return {
      cmd = [[ npm run astro check | grep error ]],
      components = {
        {
          "on_output_quickfix",
          -- errorformat = "%f:%l:%c - %t%*[a-z] %m",
          errorformat = "%f:%l:%c - %t%*[a-z] %*[a-z](%n): %m",
          items_only = true,
          tail = true,
          open = true,
          vim.notify,
        },
        -- "on_result_diagnostics",
        -- { "on_complete_dispose", timeout = 30 },
        { "on_complete_notify", "Astro Check" },
        "default",
      },
    }
  end,
  -- condition = {
  --   filetype = { "astro" },
  -- },
}
