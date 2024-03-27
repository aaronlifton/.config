local QuickScratch = {}
---@tag quick-scratch-config
local Config = {
  scratch_dir = vim.fn.stdpath("state") .. "/scratch",
  default_ext = "lua",
  scratch_file_options = {
    mode = "vertical", -- vertical | horizontal | tab
  },
}

--- Open scratch file
---@param config
function Scratch(config)
  config = Config:new(config)

  open_scratch_file(config.default_ext)
end

--- Module setup.
---@param config table|nil Partial or full configuration table. See |quick-scratch-config|.
---@usage `require('quick-scratch').setup({})`
QuickScratch.setup = function(config)
  _G.QuickScratch = QuickScratch
  return Config:new(config)
end
--- Set config

---@param opts
---@return Config
function Config:new(opts)
  opts = opts or {}
  self.__index = self
  vim.tbl_extend("force", self, opts)
  -- vim.tbl_deep_extend("force", config, opts or {})
  return setmetatable({ config = opts }, self)
end
-- make sure this file is loaded only once
if vim.g.loaded_scratch == 1 then
  vim.cmd("echo 'Scratch file is already loaded'")
  return
end
vim.g.loaded_scratch = 1
require("nvim-lightbulb").get_status_text(vim.api.nvim_get_current_buf())

local function open_scratch_file(ext)
  ext = ext or default_ext
  -- get list  of files in scratch dir
  local files = vim.fn.readdir(config.scratch_dir)
  -- generate next filename starting with 1
  local index = 1
  while files[index] ~= nil do
    index = index + 1
  end

  local filename = config.scratch_dir .. "/" .. index .. "." .. ext
  vim.cmd("edit " .. filename)
  local scratch_file = vim.fn.stdpath("state") .. "/scratch"
  -- if config.scratch_file_options ~= nil then
  --   vim.cmd("setlocal " .. config.scratch_file_options)
  -- end
  if config.scratch_file_options.dir == "vertical" then
    vim.cmd("vsplit " .. scratch_file)
  elseif config.scratch_file_options.dir == "horizontal" then
    vim.cmd("split " .. scratch_file)
  elseif config.scratch_file_options.dir == "tab" then
    vim.cmd("tabedit " .. scratch_file)
  end
  vim.cmd("edit " .. scratch_file)

  return scratch_file
end

local function save_scratch_file() vim.cmd("w") end

local commands = {
  open_default = open_scratch_file,
  open = function()
    -- get user input for ext
    local ext = vim.fn.input("Extension: ")
    open_scratch_file(ext)
  end,
  save = save_scratch_file,
}

local keys = {
  { "<leader>sc", commands.open_default, desc = "Open default scratch file" },

  { "<leader>sC", commands.open, desc = "Open scratch file" },
  { "<leader>ss", commands.save, desc = "Save scratch file" },
}

return {
  setup = function(opts) QuickScratch.setup(opts) end,
  commands = commands,
  keys = keys,
}
