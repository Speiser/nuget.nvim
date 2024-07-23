local M = {}

M.namespace = vim.api.nvim_create_namespace("nuget.nvim")

function M.test_diagnostic()
  vim.diagnostic.set(M.namespace, 0, {
    {
      lnum = 0,
      col = 50,
      message = "Hello World",
    },
  })
end

return M
