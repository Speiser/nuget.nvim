local project_file = require("nuget.project_file")

local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("nuget", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "InsertLeave", "TextChanged" }, {
    group = group,
    callback = project_file.load,
  })
end

return M
