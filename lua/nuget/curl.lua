local Job = require("plenary.job")

local M = {}

function M.get_versions_json(package_id, callback)
  local url = string.format("https://api.nuget.org/v3-flatcontainer/%s/index.json", package_id:lower())

  Job:new({
    command = "curl",
    args = { "-s", url },
    on_exit = function(job, return_val)
      local result_str = table.concat(job:result(), "\n")
      if return_val == 0 then
        if callback then
          callback(result_str)
        end
      else
        error(result_str)
      end
    end,
  }):start()
end

return M
