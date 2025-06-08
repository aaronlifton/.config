local extensions = { "sql", "plsql" }
-- local sql_ft = { "sql", "mysql", "plsql" }
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "pg_format", "sqlfluff" },
      },
      formatters = {
        pg_format = {
          command = "pg_format",
          stdin = true,
          condition = function(self, ctx)
            local is_in_migrations = ctx.dirname:match("migrations/sql")
            if not is_in_migrations then return false end
            for _, v in ipairs(extensions) do
              if ctx.filename:match("%." .. v .. "$") then return true end
            end
          end,
          prepend_args = {
            -- "--no-space-function",
            -- "--keep-newline",
            -- "-w 120"
          },
        },
      },
    },
  },
}
