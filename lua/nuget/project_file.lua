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

  local packages = get_packages()
  local package_diagnostics = {}

  local function on_json_received(name, line_number, versions_json)
    -- TODO: Store all versions to cache
    if versions_json == "" then
      error("Failed to fetch package data")
    end

    vim.schedule(function()
      -- Decode the JSON result using vim.fn.json_decode
      local success, data = pcall(function()
        return vim.fn.json_decode(versions_json)
      end)

      if not success then
        error("Failed to decode JSON data " .. data)
      end

      -- Extract the latest version
      local versions = data.versions
      local latest_version = versions[#versions]

      table.insert(package_diagnostics, {
        line_number = line_number,
        latest_version = latest_version,
      })

      if #package_diagnostics == #packages then
        diagnostics.add_diagnostics(package_diagnostics)
      end
    end)
  end

  for _, package in ipairs(packages) do
    curl.get_versions_json(package.name, function(versions_json)
      on_json_received(package.name, package.line_number, versions_json)
    end)
  end
end

function M.update()
  if not is_csproj() then
    return
  end
  print("Update")
end

return M
