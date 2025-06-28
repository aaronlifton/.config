# yatline-tab-path.yazi

An addon for [yatline.yazi](https://github.com/imsi32/yatline.yazi) to allow colorizing the `tab_path` section.
You can have separate colors for the path and for the filter and also customize the filter labels.

## Requirements

- [yazi](https://github.com/sxyazi/yazi) version >= 25.2.7
- [yatline.yazi](https://github.com/imsi32/yatline.yazi)

## Installation

```sh
ya pack -a blackdaemon/yatline-tab-path.yazi
```

## Usage

> [!IMPORTANT]
> Add this to your `~/.config/yazi/init.lua` after `yatline.yazi` initialization.

With default settings:
```lua
require("yatline-tab-path"):setup()
```

Overriding the default settings:
```lua
require("yatline-tab-path"):setup({
    path_fg = "cyan",
    filter_fg = "brightyellow",
    search_label = " search",
    filter_label = " filter",
    no_filter_label = "",
    flatten_label = " flatten",
    separator = "  ",
})
```

Then, add it in one of your sections in the yatline configuration using:

```lua
{ type = "coloreds", custom = false, name = "tab_path" }
```

NOTE:
    It differs from the default `tab_path` provided by `yatline.yazi` in that it's of type
    `coloreds` instead of `string`.

## Credits

- [Yazi](https://github.com/sxyazi/yazi)
- [yatline.yazi](https://github.com/imsi32/yatline.yazi)
