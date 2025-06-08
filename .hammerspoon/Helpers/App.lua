local App = {}
App.__index = App

App.bundles = {
  chrome = "com.google.Chrome",
  finder = "com.apple.finder",
  kitty = "net.kovidgoyal.kitty",
  cursor = "com.cursorapp.Cursor",
  preview = "com.apple.Preview",
  slack = "com.tinyspeck.slackmacgap",
  tableplus = "com.tinyapp.TablePlus",
  vscode = "com.microsoft.VSCode",
  ghostty = "com.mitchellh.ghostty",
}

function App.is(bundle)
  return hs.application.frontmostApplication():bundleID() == bundle
end

function App.is_current(bundle, ...)
  local bundles = bundle
  if type(bundle) == "string" then bundles = table.pack(bundle, ...) end

  return Util.table.tbl_contains(bundles, hs.application.frontmostApplication():bundleID())
end

function App.in_terminal()
  return App.is_current(App.bundles.kitty, App.bundles.ghostty)
end

return App
