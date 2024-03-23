return {
  {
    "bignos/bookmacro",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      require("bookmacro").setup()
    end,
    keys = {
      -- Load a macro
      {
        "<leader>Ml",
        vim.cmd.MacroSelect,
        desc = "Load a macro to a registry",
      },

      -- Execute a macro
      {
        "<leader>Mx",
        vim.cmd.MacroExec,
        desc = "Execute a macro from BookMacro",
      },

      -- Add a macro
      {
        "<leader>Ma",
        vim.cmd.MacroAdd,
        desc = "Add a macro to BookMacro",
      },

      -- Edit a macro
      {
        "<leader>Me",
        vim.cmd.MacroEdit,
        desc = "Edit a macro from BookMacro",
      },
      -- Edit the description of a macro
      {
        "<leader>Md",
        vim.cmd.MacroDescEdit,
        desc = "Edit a description of a macro from BookMacro",
      },

      -- Edit a register
      {
        "<leader>Mr",
        vim.cmd.MacroRegEdit,
        desc = "Edit a macro from register",
      },

      -- Replace a macro with a register
      {
        "<leader>MR",
        vim.cmd.MacroReplace,
        desc = "Replace a macro from BookMacro with the content of a register",
      },

      -- Delete a macro
      {
        "<leader>MD",
        vim.cmd.MacroDel,
        desc = "Delete a macro from BookMacro",
      },

      -- Export BookMacro
      {
        "<leader>MX",
        vim.cmd.MacroExport,
        desc = "Export BookMacro to a JSON file",
      },

      -- Export a Macro
      {
        "<leader>Mz",
        vim.cmd.MacroExportTo,
        desc = "Export a macro to a JSON file",
      },

      -- Import a BookMacro
      {
        "<leader>MI",
        vim.cmd.MacroImport,
        desc = "Import BookMacro with a JSON file",
      },

      -- Import BookMacro from an Internet url
      {
        "<leader>MU",
        vim.cmd.MacroImportInternet,
        desc = "Import BookMacro from an URL",
      },

      -- Import a macro
      {
        "<leader>MZ",
        vim.cmd.MacroImportFrom,
        desc = "Import a macro from a JSON file",
      },

      -- Import a macro from Internet
      {
        "<leader>Mu",
        vim.cmd.MacroImportFromInternet,
        desc = "Import a macro from an URL",
      },

      -- Erase BookMacro
      {
        "<leader>ME",
        vim.cmd.MacroErase,
        desc = "Erase all macros from The Book",
      },

      -- Register substitution
      {
        "<leader>Ms",
        vim.cmd.RegSub,
        desc = "Use substitution on register",
      },
    },
  },
}
