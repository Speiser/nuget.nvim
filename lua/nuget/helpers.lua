local M = {}

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

return M
