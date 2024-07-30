local M = {}

--- @class Package
--- @field name string
--- @field versions string[]

--- @type table<string, Package>
local cached_packages = {}

--- @type boolean
M.include_prerelease = true

--- @type string?
M.sln_file = nil

--- @type string?
M.nugetconfig_file = nil

--- @param package Package
function M.add_package(package)
  cached_packages[package.name] = package
end

--- @param package_name string
--- @return boolean, string[] | nil
function M.get_package_versions(package_name)
  local package = cached_packages[package_name]
  if package then
    return true, package.versions
  else
    return false, nil
  end
end

return M
