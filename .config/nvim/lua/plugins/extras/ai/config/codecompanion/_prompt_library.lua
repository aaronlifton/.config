return {
  ["Code Expert"] = {
    strategy = "chat",
    description = "Get some special advice from an LLM",
    opts = {
      mapping = "<LocalLeader>ce",
      modes = { "v" },
      short_name = "expert",
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = true,
    },
    prompts = {
      {
        role = "system",
        content = function(context)
          return "I want you to act as a senior "
            .. context.filetype
            .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
        end,
      },
      {
        role = "user",
        content = function(context)
          local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

          return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
  ["Conventional Commit"] = {
    strategy = "inline",
    description = "Generate a conventional commit from staged files",
    opts = {
      placement = "replace",
      auto_submit = true,
      short_name = "conventional-commit",
    },
    prompts = {
      {
        role = "system",
        content = "You are an expert at following the Conventional Commit specification.",
      },
      {
        role = "user",
        content = function(context)
          local cwd = vim.fn.expand("%:h:h")
          local git_diff = require("util.git").get_git_diff({ "git", "-C", cwd, "diff", "--staged", "-U0" })

          return "Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. Try to stay below 80 characters total. Don't specify the commit subcategory (`fix(deps):`), just the category (`fix:`). Staged git diff: ```\n"
            .. git_diff
            .. '\n```. After an additional newline, add a short description in 1 to 4 sentences of WHY the changes are done after the commit message. Don\'t start it with "This commit", just describe the changes. Use the present tense. Lines must not be longer than 74 characters.\n\n'
        end,
        opts = {
          contains_code = true,
        },
      },
    },
    -- keymaps = {
    --   send = {
    --     modes = {
    --       n = { "<CR>", "<C-s>" },
    --       i = "<C-s>",
    --     },
    --     index = 1,
    --     callback = "keymaps.send",
    --     description = "Send",
    --   },
    -- },
  },
  ["Code Explain"] = {
    strategy = "chat",
    description = "Get an explanation of code",
    opts = {
      is_slash_cmd = false,
      modes = { "v" },
      short_name = "code-explain",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "system",
        content = [[When asked to explain code, follow these steps:

1. Identify the programming language and/or framework.
2. Describe the purpose of the code and if appropriate, reference concepts from the programming language, framework, or APIs used (such as the neovim lua API).
3. When answering, take into account the context/files provided. The selected code may use methods from these other files or libraries.
3. Simply explain what the code does.]],
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = function(context)
          -- local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
          local code = require("util.ai.markdown").markdown_code_fence(context)

          return string.format(
            [[Please explain this code from buffer %d:
%s]],
            context.bufnr,
            code
          )
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
  ["Ripgrep regex help"] = {
    strategy = "chat",
    description = "Get help with searching with ripgrep",
    opts = {
      is_slash_cmd = false,
      modes = { "n" },
      short_name = "ripgrep-regex-help",
      auto_submit = false,
      user_prompt = true,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "system",
        content = [[When asked to generate regex, follow these steps:

  1. For the content in the <search> tag, generate a ripgrep regex search query that will match it.
  2. Describe how the regex works.]],
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = function(context)
          return [[Please help me write a regex that will find this string:
<search>
</search>
If it helps, the regex that I've tried is: ``]]
        end,
        opts = {
          contains_code = false,
        },
      },
    },
  },
}
