local project_file = require("nuget.project_file")
local state = require("nuget.state")

local M = {}

function M.toggle_include_prerelease()
  state.include_prerelease = not state.include_prerelease
  project_file.load()
end

return M
