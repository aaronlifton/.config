return {
  {
    "gsuuon/model.nvim",
    -- Don't need these if lazy = false
    cmd = { "M", "Model", "Mchat" },
    init = function()
      vim.filetype.add({
        extension = {
          mchat = "mchat",
        },
      })
    end,
    ft = "mchat",
    keys = {
      { "<C-m>a", ":M<cr>", mode = "n", desc = "Run a completion prompt" },
      { "<C-m><space>", ":Mchat<cr>", mode = "n", desc = "Open a chat buffer" },
      { "<C-m>d", ":Mdelete<cr>", mode = "n" },
      { "<C-m>s", ":Mselect<cr>", mode = "n" },
      { "<C-m>ma", ":MCadd<cr>", mode = "n", desc = "Add the current file into context" },
      { "<C-m>md", ":MCremove<cr>", mode = "n", desc = "Remove the current file into context" },
      { "<C-m>mD", ":MCclear<cr>", mode = "n", desc = "Clear the current context" },
      { "<C-m>mp", ":MCpaste<cr>", mode = "n", desc = "Paste file into context" },
    },

    -- To override defaults add a config field and call setup()

    config = function()
      local openai = require("model.providers.openai")
      local hf = require("model.providers.huggingface")
      local starter_prompts = require("model.prompts.starters")
      local model = require("model")

      openai.initialize({
        model = "gpt-4",
      })

      -- require("model.providers.llamacpp").setup({
      --   binary = "~/path/to/server/binary",
      --   models = "~/path/to/models/directory",
      -- })
      local ollama_defaults = {
        provider = require("model.providers.ollama"),
        params = {
          model = "starling-lm",
        },
        run = require("model.format.starling").chat,
      }

      -- Interesting starters
      -- starter_prompts['llamacpp:zephyr']
      -- starter_prompts['together:stripedhyena']
      -- starter_prompts['together:phind/codellama34b_v2']
      -- starter_prompts['ollama:starling']
      -- starter_prompts['hf:starcoder']
      -- starter_prompts['openai:gpt4-code']
      -- starter_prompts['ollama:starling']
      --
      -- starter_prompts.commit -- Convential Commits
      --
      -- Extract the relevant path from an OpenAPI spec and include in the gpt request.
      -- Expects schema url as a command arg.
      -- (:M openapi https://myurl.json)'
      -- starter_prompts.openapi

      local prompts = vim.tbl_extend("force", starter_prompts, {
        NodeJsConvert = {
          provider = openai,
          mode = model.mode.INSERT_OR_REPLACE,
          builder = function(input, context)
            local code = input
            return {
              messages = {
                {
                  role = "user",
                  -- content = "Your mission is to convert given code to a nodejs-code. Don't describe or hinting the code. Only clean code. Here is the code to convert: ``` "
                  content = "Convert the following code to NodeJS code. Only return code and don't describe it. Here is the code to convert: ``` "
                    .. code
                    .. " ```",
                },
              },
            }
          end,
        },
        ConventialCommit = {
          provider = openai,
          mode = require("model").mode.REPLACE,
          builder = function()
            local cwd = vim.fn.expand("%:h:h")
            local git_diff = vim.fn.system({ "git", "-C", cwd, "diff", "--staged", "-U0" })

            if not git_diff:match("^diff") then
              error("Git error:\n" .. git_diff)
            end

            return {
              messages = {
                {
                  role = "user",
                  content = "Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. Try to stay below 80 characters total. Staged git diff: ```\n"
                    .. git_diff
                    .. '\n```. After an additional newline, add a short description in 1 to 4 sentences of WHY the changes are done after the commit message. Don\'t start it with "This commit", just describe the changes. Use the present tense. Lines must not be longer than 74 characters.',
                },
              },
            }
          end,
        },
      })

      local models = require("plugins.extras.ai.config.models").models()
      local chats = vim.tbl_extend("force", require("model.prompts.chats"), {
        PromptChecker = vim.tbl_extend("force", ollama_defaults, {
          system = models.prompt_checker,
          create = function(input, context)
            return "Prompt:" .. (context.selection and input or "")
          end,
        }),
        -- ['Prompt generator'] = {
        --     system = 'I want you to act as a guidance to create a prompt which defines a role for an AI. This prompt should be as short as possible. The prompt should start with "I want you to act as a ". Check the prompt on a scale from 1 to 10 and create a prompt which goes to 10'
        -- },
        ProductManger = {
          provider = require("model.providers.ollama"),
          system = models.product_manager .. models.asks_questions,
          params = {
            model = "starling-lm",
          },
          create = function(input, context)
            return "Topic: " .. (context.selection and input or "")
          end,
          run = require("model.format.starling").chat,
        },
        ProductManagerStories = {
          provider = require("model.providers.ollama"),
          system = "Act as a Product Owner. You are to write stories based on the user requirements I give you.",
          params = {
            model = "starling-lm",
          },
          create = function(input, context)
            return context.selection and input or ""
          end,
          run = require("model.format.starling").chat,
        },
        ReviewDiff = {
          provider = require("model.providers.ollama"),
          system = "You are an expert programmer that gives constructive feedback. Review the changes in the user's git diff. Don't describe what the user has done. Suggest some improvements if you find some.",
          params = {
            model = "starling-lm",
          },
          create = function()
            local cwd = vim.fn.expand("%:h:h")
            local git_diff = vim.fn.system({ "git", "-C", cwd, "diff", "--staged", "-U0" })

            if not git_diff:match("^diff") then
              error("Git error:\n" .. git_diff)
            end

            return git_diff
          end,
          run = require("model.format.starling").chat,
        },
      })

      model.setup({
        default_prompt = hf.default_prompt,
        chats = chats,
        prompts = prompts,
      })

      local augroup = vim.api.nvim_create_augroup("ai_model", {})
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "mchat",
        -- command = "nnoremap <silent><buffer> <leader>w :Mchat<cr>",
        callback = function()
          vim.keymap.set("n", "<leader><cr>", ":Mchat<cr>", { buffer = true, silent = true })
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "gitcommit",
        callback = function()
          local wk = require("which-key")
          vim.keymap.set(
            "n",
            "<C-m>g",
            ":M commit<cr>",
            { desc = "Generate git message", buffer = true, silent = true }
          )
          vim.api.nvim_echo({ { "Git commit message generator enabled", "Title" } }, true, {})
          wk.register({
            ["<C-m>g"] = {
              c = { ":Model commit<cr>", "Generate git message", noremap = true },
            },
          })
        end,
      })

      -- Override elixir-tools :M/:Mix command
      vim.api.nvim_command("command! M Model")
    end,
  },
}
