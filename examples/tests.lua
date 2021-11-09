package.path = "src/?.lua;"..package.path
local emgr = require("emgr")

local function errcheck(perr, f, ...)
  local ok, err = pcall(f, ...)
  assert(not ok and not not err:find(perr))
end

do
end
