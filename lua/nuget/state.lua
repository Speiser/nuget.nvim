local helpers = require("nuget.helpers")

local M = {}

M.config = {
  use_nuget_config_file = false,
}

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

--- @type string[]
M.package_info_urls = {}

--- @param package_info_url string
function M.add_package_info_url(package_info_url)
  if helpers.contains(M.package_info_urls, package_info_url) then
    return
  end

  table.insert(M.package_info_urls, package_info_url)
end

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
