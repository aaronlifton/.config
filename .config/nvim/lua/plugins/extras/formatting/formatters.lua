-- Require these formatters in a specific order, because
-- each overrides the other so that projets with multiple formatters choose the
-- right one
return {
  { import = "plugins.extras.formatting.prettier-extended" },
  { import = "plugins.extras.formatting.biome" },
  { import = "plugins.extras.formatting.dprint" },
}
