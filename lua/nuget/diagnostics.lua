local M = {}

M.namespace = vim.api.nvim_create_namespace("nuget.nvim")

--- @param diagnostics vim.Diagnostic[]
function M.add_diagnostics(diagnostics)
  vim.diagnostic.set(M.namespace, 0, diagnostics)
end

return M
