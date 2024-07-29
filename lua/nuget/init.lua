local commands = require("nuget.commands")
local project_file = require("nuget.project_file")

local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("nuget", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "InsertLeave", "TextChanged" }, {
    group = group,
    callback = project_file.load,
  })
  vim.api.nvim_create_user_command("ToggleIncludePrerelease", commands.toggle_include_prerelease, { nargs = 0 })
end

return M
