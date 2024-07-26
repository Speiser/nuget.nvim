local curl = require("nuget.curl")
local diagnostics = require("nuget.diagnostics")

local M = {}

--- @return boolean
local function is_csproj()
  local current_file = vim.api.nvim_buf_get_name(0)
  return current_file:sub(-7) == ".csproj"
end

--- @class Package
--- @field name string
--- @field version string
--- @field line_number number

--- @return Package[]
local function get_packages()
  local packages = {}
  local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local pattern = '<PackageReference Include="(.-)" Version="(.-)" />'

  for line_number, line in ipairs(buffer) do
    local name, version = line:match(pattern)
    if name and version then
      table.insert(packages, {
        name = name,
        version = version,
        line_number = line_number - 1,
      })
    end
  end

  return packages
end

function M.load()
  if not is_csproj() then
    return
  end
  -- TODO: Make non blocking
  vim.schedule(function()
    local packages = get_packages()
    --- @type PackageDiagnostic[]
    local package_diagnostics = {}
    for _, package in ipairs(packages) do
      local latest = curl.get_latest(package.name)
      if latest ~= package.version then
        table.insert(package_diagnostics, {
          line_number = package.line_number,
          latest_version = latest,
        })
      end
    end
    diagnostics.add_diagnostics(package_diagnostics)
  end)
end

function M.update()
  if not is_csproj() then
    return
  end
  print("Update")
end

return M
