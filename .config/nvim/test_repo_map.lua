local Utils = require("avante.utils")
local rm = require("avante_repo_map")
local filepath = "app/models/listing.rb"
local content = Utils.file.read_content(filepath) or ""
local definitions = rm.stringify_definitions("ruby", content)
print(definitions)
