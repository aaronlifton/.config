---@module "lazy"
---@type LazySpec
return {
  "TymekDev/spotlight.nvim",
  ---@module "spotlight"
  ---@diagnostic disable-next-line: undefined-doc-name
  ---@type spotlight.ConfigPartial
  opts = {
    -- Defaults
    -- Should the spotlights have their ordinal number displayed in the sign column?
    -- Every buffer has its own counter.
    count = true,

    -- The highlight group applied to the spotlighted lines
    hl_group = "Visual",
  },
  config = true,
}
