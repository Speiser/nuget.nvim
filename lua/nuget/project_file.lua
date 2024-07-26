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
  local packages_with_latest = {}

  local function on_json_received(name, line_number, current_version, versions_json)
    -- TODO: Store all versions to cache
    vim.schedule(function()
      -- Decode the JSON result using vim.fn.json_decode
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

      -- Extract the latest version
      local versions = data.versions
      local latest_version = versions[#versions]

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

  for _, package in ipairs(packages) do
    curl.get_versions_json(package.name, function(versions_json)
      on_json_received(package.name, package.line_number, package.version, versions_json)
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
