local Path = require("plenary.path")

local M = {}

--- Finds the .sln and nuget.config files in the directory hierarchy.
--- @return string? sln_path
--- @return string? nugetconfig_path
function M.find_solution_and_nugetconfig()
  local function get_parent_directory(path)
    local parent = Path:new(path):parent()
    return tostring(parent)
  end

  -- Needed if this `find_solution_and_nugetconfig` is called because a file was opened.
  local current_file_dir = vim.fn.expand("%:p:h")
  if vim.loop.os_uname().sysname == "Windows_NT" then
    current_file_dir = current_file_dir:gsub("/", "\\")
  end
  local start_dir = (current_file_dir ~= "" and current_file_dir) or vim.fn.getcwd()
  local sln_path = nil
  local nuget_path = nil
  local current_dir = start_dir

  while current_dir ~= "/" and current_dir ~= "" do
    if not sln_path then
      local sln_files = vim.fn.glob(Path:new(current_dir):joinpath("*.sln").filename)
      if sln_files ~= "" then
        sln_path = sln_files
      end
    end

    if not nuget_path then
      local nuget_files = vim.fn.glob(Path:new(current_dir):joinpath("nuget.config").filename)
      if nuget_files ~= "" then
        nuget_path = nuget_files
      end
    end

    if sln_path and nuget_path then
      return sln_path, nuget_path
    end

    local parent_dir = get_parent_directory(current_dir)
    if parent_dir == current_dir then
      break
    end
    current_dir = parent_dir
  end

  return sln_path, nuget_path
end

--- @param versions string[]
--- @param include_prerelease boolean
function M.get_latest_version(versions, include_prerelease)
  if not include_prerelease then
    for i = #versions, 1, -1 do
      if not versions[i]:find("-") then
        return versions[i]
      end
    end
  end
  return versions[#versions]
end

function M.contains(array, value)
  for _, v in ipairs(array) do
    if v == value then
      return true
    end
  end
  return false
end

return M
