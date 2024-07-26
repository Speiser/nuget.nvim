local M = {}

M.namespace = vim.api.nvim_create_namespace("nuget.nvim")

--- @class PackageDiagnostic
--- @field line_number number
--- @field latest_version string

--- @param diagnostics PackageDiagnostic[]
function M.add_diagnostics(diagnostics)
  --- @type vim.Diagnostic[]
  local vim_diagnostics = {}

  for _, diagnostic in ipairs(diagnostics) do
    table.insert(vim_diagnostics, {
      lnum = diagnostic.line_number,
      col = 0,
      message = diagnostic.latest_version,
      severity = vim.diagnostic.severity.HINT,
    })
  end

  vim.diagnostic.set(M.namespace, 0, vim_diagnostics)
end

return M
