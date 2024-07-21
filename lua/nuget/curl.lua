local Job = require("plenary.job")

local M = {}

---@return string string
function M.get_latest(package_id)
  local url = string.format("https://api.nuget.org/v3-flatcontainer/%s/index.json", package_id:lower())

  local result = Job:new({
    command = "curl",
    args = { "-s", url },
  }):sync()

  if not result or #result == 0 then
    error("Failed to fetch package data")
  end

  local result_str = table.concat(result, "\n")
  local success, data = pcall(vim.fn.json_decode, result_str)
  if not success then
    error("Failed to decode JSON data")
  end

  local versions = data.versions
  return versions[#versions]
end

return M
