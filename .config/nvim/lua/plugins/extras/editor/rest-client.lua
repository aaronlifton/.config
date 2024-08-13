return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "http" },
    },
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = {
      {
        "gennaro-tedesco/nvim-jqx",
        ft = { "json", "yaml" },
      },
    },
    ft = { "http" },
    opts = {
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Encode URL before making request
      encode_url = true,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      env_file = ".env",
      custom_dynamic_variables = {},
      result = {
        split = {
          horizontal = true,
          in_place = false,
        },
        -- behavior = {
        --   show_info = {
        --     -- toggle showing URL, HTTP info, headers at top the of result window
        --     url = true,
        --     headers = true,
        --     http_info = true,
        --   }
        --   -- executables or functions for formatting response body [optional]
        --   -- set them to false if you want to disable them
        --   formatters = {
        --     json = "jq",
        --     html = function(body)
        --       return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
        --     end,
        --   },
        -- }
      },
    },
    config = function(_, opts)
      require("rest-nvim").setup(opts)
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").load_extension("rest")
      end)
    end,
    -- stylua: ignore
    keys = {
      { "<leader>thp", function() require("rest-nvim").run(true) end, desc = "Preview Request" },
      { "<leader>thr", function() require("rest-nvim").run() end, desc = "Run Request" },
      { "<leader>sv", function() require("telescope").extensions.rest.select_env() end, desc = "Env Files" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>th"] = { name = "http" },
      },
    },
  },
}
