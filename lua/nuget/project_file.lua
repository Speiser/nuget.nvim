local curl = require("nuget.curl")
local diagnostics = require("nuget.diagnostics")
local helpers = require("nuget.helpers")
local state = require("nuget.state")

local M = {}

--- @return boolean
local function is_csproj()
  local current_file = vim.api.nvim_buf_get_name(0)
  return current_file:sub(-7) == ".csproj"
end

--- @class ProjectFilePackageDefinition
--- @field name string
--- @field version string
--- @field line_number number

--- @return ProjectFilePackageDefinition[]
local function get_packages()
  local packages = {}
  local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local pattern = '<PackageReference Include="(.-)" Version="(.-)"%s*/?>'

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

  if state.sln_file == nil or state.nugetconfig_file == nil then
    state.sln_file, state.nugetconfig_file = helpers.find_solution_and_nugetconfig()
  end

  local packages = get_packages()
  local packages_with_latest = {}

  --- @param versions string[]
  local function on_version_received(line_number, current_version, versions)
    vim.schedule(function()
      local latest_version = helpers.get_latest_version(versions, state.include_prerelease)

      table.insert(packages_with_latest, {
        line_number = line_number,
        version = current_version,
        latest_version = latest_version,
      })

      if #packages_with_latest == #packages then
        --- @type PackageDiagnostic[]
        local package_diagnostics = {}
        for _, package in ipairs(packages_with_latest) do
          if package.version ~= package.latest_version then
            table.insert(package_diagnostics, {
              line_number = package.line_number,
              latest_version = package.latest_version,
            })
          end
        end
        diagnostics.add_diagnostics(package_diagnostics)
      end
    end)
  end

  local function on_json_received(name, line_number, current_version, versions_json)
    vim.schedule(function()
      local success, data = pcall(function()
        return vim.fn.json_decode(versions_json)
      end)

      if not success then
        table.insert(packages_with_latest, {
          line_number = line_number,
          version = current_version,
          latest_version = current_version,
        })
        return
      end

      local versions = data.versions
      state.add_package({
        name = name,
        versions = versions,
      })
      on_version_received(line_number, current_version, versions)
    end)
  end

  for _, package in ipairs(packages) do
    local found, versions = state.get_package_versions(package.name)
    if found then
      assert(versions ~= nil)
      on_version_received(package.line_number, package.version, versions)
    else
      curl.get_versions_json(package.name, function(versions_json)
        on_json_received(package.name, package.line_number, package.version, versions_json)
      end)
    end
  end
end

return M
