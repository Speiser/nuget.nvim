local curl = require("nuget.curl")
local diagnostics = require("nuget.diagnostics")

local M = {}

---@return boolean
local function is_csproj()
  local current_file = vim.api.nvim_buf_get_name(0)
  return current_file:sub(-7) == ".csproj"
end

local function get_packages()
  local packages = {}

  local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(buffer, "\n")
  local pattern = '<PackageReference Include="(.-)" Version="(.-)" />'

  for name, version in content:gmatch(pattern) do
    table.insert(packages, { name = name, version = version })
  end

  return packages
end

function M.load()
  if not is_csproj() then
    return
  end
  print("Load")
  local packages = get_packages()
  for _, package in ipairs(packages) do
    local latest = curl.get_latest(package.name)
    print("Package: " .. package.name .. ", Version: " .. package.version .. ", Latest: " .. latest)
  end
  diagnostics.test_diagnostic()
end

function M.update()
  if not is_csproj() then
    return
  end
  print("Update")
end

return M
