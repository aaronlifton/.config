local M = {
  default_theme = "catppuccin_macchiato",
}

function M.setTheme(themeName)
  local theme = M.themes[themeName]
  if not theme then error("Theme '" .. themeName .. "' not found") end
  hs.settings.set("theme", themeName)
end

M.themes = {
  catppuccin_macchiato = {
    rosewater = "#f4dbd6",
    flamingo = "#f0c6c6",
    pink = "#f5bde6",
    mauve = "#c6a0f6",
    red = "#ed8796",
    maroon = "#ee99a0",
    peach = "#f5a97f",
    yellow = "#eed49f",
    green = "#a6da95",
    teal = "#8bd5ca",
    sky = "#91d7e3",
    sapphire = "#7dc4e4",
    blue = "#8aadf4",
    lavender = "#b7bdf8",
    text = "#cad3f5",
    subtext1 = "#b8c0e0",
    subtext0 = "#a5adcb",
    overlay2 = "#939ab7",
    overlay1 = "#8087a2",
    overlay0 = "#6e738d",
    surface2 = "#5b6078",
    surface1 = "#494d64",
    surface0 = "#363a4f",
    base = "#24273a",
    mantle = "#1e2030",
    crust = "#181926",
  },
}

setmetatable(M, {
  __index = function(t, k)
    local theme = hs.settings.get("theme") or t.default_theme
    -- Logger.d("metatable.t: " .. hs.inspect(t) .. ", k: " .. k .. ", theme: " .. theme)
    local colors = t.themes[theme]
    if colors then
      if colors[k] then
        return colors[k]
      else
        error("Color '" .. k .. "' not found")
      end
    else
      error("Theme '" .. k .. "' not found")
    end
  end,
})

return M
