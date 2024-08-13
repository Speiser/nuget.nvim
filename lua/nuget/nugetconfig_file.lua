local curl = require("nuget.curl")
local state = require("nuget.state")

local M = {}

local DEFAULT_PACKAGE_INFO_URL = "https://api.nuget.org/v3-flatcontainer/%s/index.json"

--- Reads nuget source api's from nuget.config
--- @param file_path string Path to the nuget.config
--- @return string[]
local function get_nuget_api_urls(file_path)
  local sources = {}
  local pattern = '<add key="([^"]-)" value="([^"]-)"'

  for line in io.lines(file_path) do
    local key, value = line:match(pattern)
    if key and value then
      table.insert(sources, value)
    end
  end

  return sources
end

local function get_package_info_url(nuget_api_url) end

function M.load()
  if state.nugetconfig_file == nil then
    state.add_package_info_url(DEFAULT_PACKAGE_INFO_URL)
    return
  end

  local sources = get_nuget_api_urls(state.nugetconfig_file)

  if #sources == 0 then
    state.add_package_info_url(DEFAULT_PACKAGE_INFO_URL)
    return
  end

  local responses_count = 0
  local package_info_sources = {}

  local function on_response(result_json)
    responses_count = responses_count + 1
    if responses_count == #sources then
      -- Finished
    end
  end

  -- TODO: If #sources == 0 -> provide default

  for _, source in ipairs(sources) do
    curl.run_curl(source, on_response)
  end

  print("loaded nuget.config")
end

return M
