return {
  {
    "jellydn/gen.nvim",
    opts = {
      model = "codellama",
      host = "localhost",
      port = "11434",
      display_mode = "split",
      show_prompt = true,
      show_model = true,
      no_auto_close = false,
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/generate -d $body"
      end,
    },
    config = function(_, opts)
      local gen = require("gen")
      gen.setup(opts)

      gen.prompts["Elaborate_Text"] = {
        prompt = "Elaborate the following text:\n$text",
      }
      gen.prompts["Fix_Code"] = {
        prompt = "Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        extract = "```$filetype\n(.-)```",
      }
    end,
    keys = {
      { "<leader>aii", "<cmd>Gen<cr>", mode = { "n", "v" }, desc = "IA (Gen)" },
      { "<leader>aig", "<cmd>Gen Generate<cr>", mode = { "n" }, desc = "Generate" },
      { "<leader>aic", "<cmd>Gen Chat<cr>", mode = { "n" }, desc = "Chat" },
      { "<leader>ais", "<cmd>Gen Summarize<cr>", mode = { "n", "v" }, desc = "Summarize" },
      { "<leader>aia", "<cmd>Gen Ask<cr>", mode = { "v" }, desc = "Ask" },
      { "<leader>aiH", "<cmd>Gen Change<cr>", mode = { "v" }, desc = "Change" },
      { "<leader>aiG", "<cmd>Gen Enhance_Grammar_Spelling<cr>", mode = { "v" }, desc = "Enhance Grammar Spelling" },
      { "<leader>aiw", "<cmd>Gen Enhance_Wording<cr>", mode = { "v" }, desc = "Enhance Wording" },
      { "<leader>aiC", "<cmd>Gen Make_Concise<cr>", mode = { "v" }, desc = "Make Concise" },
      { "<leader>ail", "<cmd>Gen Make_List<cr>", mode = { "v" }, desc = "Make List" },
      { "<leader>ait", "<cmd>Gen Make_Table<cr>", mode = { "v" }, desc = "Make Table" },
      { "<leader>air", "<cmd>Gen Review_Code<cr>", mode = { "v" }, desc = "Review Code" },
      { "<leader>aie", "<cmd>Gen Enhance_Code<cr>", mode = { "v" }, desc = "Enhance Code" },
      { "<leader>aih", "<cmd>Gen Change_Code<cr>", mode = { "v" }, desc = "Change Code" },
      { "<leader>aif", "<cmd>Gen Fix_Code<cr>", mode = { "v" }, desc = "Fix Code" },
      { "<leader>aiE", "<cmd>Gen Elaborate_Text<cr>", mode = { "v" }, desc = "Elaborate Text" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = { "n", "v" },
        { "<leader>ai", group = "AI (Gen)" },
      },
    },
  },
}
