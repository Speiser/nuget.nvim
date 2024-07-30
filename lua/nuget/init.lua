local commands = require("nuget.commands")
local helpers = require("nuget.helpers")
local project_file = require("nuget.project_file")
local state = require("nuget.state")

local M = {}

function M.setup()
  state.sln_file, state.nugetconfig_file = helpers.find_solution_and_nugetconfig()

  local group = vim.api.nvim_create_augroup("nuget", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "InsertLeave", "TextChanged" }, {
    group = group,
    callback = project_file.load,
  })
  vim.api.nvim_create_user_command("ToggleIncludePrerelease", commands.toggle_include_prerelease, { nargs = 0 })
end

return M
