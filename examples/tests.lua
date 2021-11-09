package.path = "src/?.lua;"..package.path
local emgr = require("emgr")

local function errcheck(perr, f, ...)
  local ok, err = pcall(f, ...)
  assert(not ok and not not err:find(perr))
end

-- Managers.

local name_mgr = {count = 0, ents = setmetatable({}, {__mode = "k"})}
function name_mgr:__init(e, name)
  if not self.ents[e] then self.count = self.count+1 end
  self.ents[e] = name
end
function name_mgr:__free(e)
  if self.ents[e] then
    self.ents[e] = nil
    self.count = self.count-1
  end
end
function name_mgr:get(e) return self.ents[e] end

local pos_mgr = {count = 0, ents = setmetatable({}, {__mode = "k"})}
function pos_mgr:__init(e, x, y)
  if not self.ents[e] then self.count = self.count+1 end
  self.ents[e] = {x,y}
end
function pos_mgr:__free(e)
  if self.ents[e] then
    self.ents[e] = nil
    self.count = self.count-1
  end
end
function pos_mgr:getPosition(e)
  local data = self.ents[e]
  if not data then error("invalid entity") end
  return data[1], data[2]
end
function pos_mgr:setPosition(e, x, y)
  local data = self.ents[e]
  if not data then error("invalid entity") end
  data[1], data[2] = x, y
end

-- Tests.

do -- test ownership
  local ent1 = emgr.entity()
  assert(ent1)
  ent1:init(name_mgr, "test")
  ent1:init(pos_mgr, 0, 0)
  -- check name
  assert(ent1:has(name_mgr))
  assert(name_mgr.count == 1)
  -- check pos
  assert(ent1:has(pos_mgr))
  assert(pos_mgr.count == 1)
  assert(name_mgr:get(ent1) == "test")
  ent1:free(name_mgr)
  assert(not ent1:has(name_mgr))
  ent1:init(name_mgr, "ent1")
  -- check GC
  ent1 = nil
  collectgarbage("collect")
  collectgarbage("collect")
  assert(name_mgr.count == 0)
  assert(pos_mgr.count == 0)
end
do -- test errors
  local ent1 = emgr.entity()
  errcheck("missing argument", ent1.has, ent1, nil)
end
