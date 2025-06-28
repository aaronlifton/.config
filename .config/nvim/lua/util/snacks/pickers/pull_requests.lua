local M = {}

---@param opts? snacks.picker.Config
function M.pull_requests(opts)
  return Snacks.picker.pick(vim.tbl_deep_extend("keep", opts or {}, {
    title = "Pull Requests",
    finder = function(f_opts, ctx)
      return require("snacks.picker.source.proc").proc({
        f_opts,
        {
          cmd = "gh",
          args = { "pr", "list", "--json", "number,title,body", "--jq", '".[] | [.number, .title, .body] | @tsv"' },
          transform = function(item) ---@param item snacks.picker.finder.Item
            local split = vim.split(item.text, "\t")
            item.pr_number = tonumber(split[1])
            item.pr_title = split[2]
            item.pr_body = split[3]
          end,
        },
      }, ctx)
    end,
    confirm = function(picker, item)
      Util.snacks.pickers.run_picker_system(picker)(
        { "gh", "pr", "checkout", item.pr_number },
        { timeout = 10000 },
        function(out)
          picker:close()
          vim.schedule(function()
            Snacks.notify.info(out.stderr)
          end)
        end
      )
    end,
    format = function(item)
      local res = {}
      table.insert(res, { "#" .. item.pr_number, "Function" })
      table.insert(res, { " " })
      table.insert(res, { item.pr_title })
      return res
    end,
    preview = function(ctx)
      ctx.preview:highlight({ ft = "markdown" })
      ctx.preview:set_lines(vim.split(ctx.item.pr_body, [[\r\n]]))
    end,
  } --[[@as snacks.picker.Config]]))
end

return M.pull_requests
