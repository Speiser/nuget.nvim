local commands = require("nuget.commands")
local helpers = require("nuget.helpers")
local nugetconfig_file = require("nuget.nugetconfig_file")
local project_file = require("nuget.project_file")
local state = require("nuget.state")

local M = {}

function M.setup()
  if state.config.use_nuget_config_file then
    state.sln_file, state.nugetconfig_file = helpers.find_solution_and_nugetconfig()
    nugetconfig_file.load()
  end

  local group = vim.api.nvim_create_augroup("nuget", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "InsertLeave", "TextChanged" }, {
    group = group,
    callback = project_file.load,
  })
  vim.api.nvim_create_user_command("ToggleIncludePrerelease", commands.toggle_include_prerelease, { nargs = 0 })
end

return M
