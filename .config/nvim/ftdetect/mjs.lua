vim.filetype.add({
  extension = {
    -- mjs = "tsx",
    -- cjs = "jsx",
    mjs = "javascript",
    cjs = "javascript",
  },
})
--
-- -- for files ending in astro.config.mjs, set filtype to astro
-- vim.filetype.add({
--   name = "astro",
--   pattern = [[\v\.astro\.config\.mjs$]],
-- })
-- -- for files that start with astro and end in ,ts, set filetype to astro
-- vim.filetype.add({
--   name = "astro",
--   pattern = [[\v^astro.*\.ts$]],
-- })
