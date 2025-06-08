local mcphub = require("mcphub")

-- Add tool for git status
mcphub.add_tool("git_helper", {
  name = "git_status",
  description = "Get git status of current repository",
  handler = function(_, res)
    local status = vim.fn.system("git status --porcelain")
    if vim.v.shell_error ~= 0 then return res:error("Not a git repository or git command failed") end

    if status == "" then return res:text("Working directory clean, no changes to commit."):send() end

    return res:text("Git status:\n" .. status):send()
  end,
})

-- Add tool for git log
mcphub.add_tool("git_helper", {
  name = "git_log",
  description = "Get recent git commits",
  inputSchema = {
    type = "object",
    properties = {
      count = {
        type = "number",
        description = "Number of commits to show",
        default = 5,
      },
    },
  },
  handler = function(req, res)
    local count = req.params.count or 5
    local log = vim.fn.system(string.format("git log -n %d --oneline", count))

    if vim.v.shell_error ~= 0 then return res:error("Not a git repository or git command failed") end

    return res:text("Recent commits:\n" .. log):send()
  end,
})

-- Add resource for branch information
mcphub.add_resource("git_helper", {
  name = "branch_info",
  uri = "git_helper://branch",
  description = "Get current branch information",
  handler = function(_, res)
    local branch = vim.fn.system("git branch --show-current")

    if vim.v.shell_error ~= 0 then return res:error("Not a git repository or git command failed") end

    local remote = vim.fn.system("git config --get branch." .. branch:gsub("\n", "") .. ".remote")
    local upstream = ""

    if vim.v.shell_error == 0 and remote ~= "" then
      upstream = vim.fn.system("git config --get branch." .. branch:gsub("\n", "") .. ".merge")
      upstream = upstream:gsub("refs/heads/", ""):gsub("\n", "")
    end

    local info = {
      current_branch = branch:gsub("\n", ""),
      remote = remote:gsub("\n", ""),
      upstream = upstream,
    }

    return res:text(vim.inspect(info)):send()
  end,
})

-- Add resource template for commit information
mcphub.add_resource_template("git_helper", {
  name = "commit_info",
  uriTemplate = "git_helper://commit/{hash}",
  description = "Get detailed information about a specific commit",
  handler = function(req, res)
    local hash = req.params.hash

    local commit_info = vim.fn.system("git show --no-patch --format='%an <%ae>%n%at%n%s%n%b' " .. hash)

    if vim.v.shell_error ~= 0 then return res:error("Invalid commit hash or git command failed") end

    local lines = {}
    for line in commit_info:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end

    local author = lines[1] or ""
    local timestamp = lines[2] or ""
    local subject = lines[3] or ""
    local body = table.concat({ select(4, unpack(lines)) }, "\n")

    local date = os.date("%Y-%m-%d %H:%M:%S", tonumber(timestamp))

    local info = {
      hash = hash,
      author = author,
      date = date,
      subject = subject,
      body = body,
    }

    return res:text(vim.inspect(info)):send()
  end,
})

-- Add a chat prompt
mcphub.add_prompt("git_helper", {
  name = "commit_message_help",
  description = "Help write a commit message based on changes",
  arguments = {
    {
      name = "type",
      description = "Commit type (feat, fix, docs, etc.)",
      required = true,
    },
  },
  handler = function(req, res)
    local commit_type = req.params.type
    local diff = vim.fn.system("git diff --staged")

    if vim.v.shell_error ~= 0 then return res:error("Git command failed or no staged changes") end

    -- Limit diff size to avoid overwhelming the LLM
    if #diff > 2000 then diff = diff:sub(1, 2000) .. "\n... (diff truncated)" end

    return res
      :user()
      :text(
        string.format("Help me write a %s commit message for these changes:\n\n```diff\n%s\n```", commit_type, diff)
      )
      :llm()
      :text("I'll help you write a commit message based on the changes. Here's a suggested commit message:")
      :text(string.format("%s: ", commit_type))
      :send()
  end,
})

return true
