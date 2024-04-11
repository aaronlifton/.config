return {
  {
    "f-person/git-blame.nvim",
    name = "gitblame",
    opts = {
      -- the character used for virtual text padding
      padding_char = " ",
      -- whether the blame info should be automatically hidden when leaving the window containing the file
      auto_hide = true,
      -- text to show in the virtual text section
      virt_text = true,
      -- text to show in the virtual text section when there is no blame info
      virt_text_missing = "???",
      -- head character and color
      head = " ",
      head_style = "bold",
      head_color = "cyan",
      -- file info separator character and color
      file_info_separator = " ",
      file_info_separator_style = "bold",
      file_info_separator_color = "green",
      -- git blame virt text color
      virt_text_color = "blue",
      -- git blame virt text style
    },
    config = function(_, opts)
      require("gitblame").setup(opts)
    end,
  },
}
