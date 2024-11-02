local bigfiles = {
  "common.json",
  "listing_drafts_controller_spec.rb",
}

return {
  "LunarVim/bigfile.nvim",
  event = "LazyFile",
  opts = {
    filesize = 1, -- size of the file in MiB, the plugin round file sizes to the closest MiB
    pattern = function(bufnr, filesize_mib)
      -- you can't use `nvim_buf_line_count` because this runs on BufReadPre
      -- local filetype = vim.filetype.match({ buf = bufnr })
      -- if not (filetype == "ruby" or filetype == "json") then return end
      -- local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
      -- local file_length = #file_contents
      -- if file_length > 2500 then return true end

      local filepath = vim.api.nvim_buf_get_name(bufnr)
      local filename = filepath:match("([^/]+)$")
      for _, bigfile in ipairs(bigfiles) do
        if filename == bigfile then return true end
      end
    end,
  },
}
