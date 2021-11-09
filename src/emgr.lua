-- https://github.com/ImagicTheCat/lua-emgr
-- MIT license (see LICENSE or src/emgr.lua)
--[[
MIT License

Copyright (c) 2021 ImagicTheCat

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local emgr = {}

local entity = {}

-- Initialize the entity into a manager.
-- Can be called even if already initialized.
function entity:init(manager, ...)
  manager:init(self, ...)
  self[manager] = true
end

-- Free the entity from a manager.
-- Can be called even if already freed.
function entity:free(manager)
  manager:free(self)
  self[manager] = nil
end

-- Check if the entity has a manager as composition (i.e. is managed by a manager).
-- Low-level alternative: check `entity[manager]`
function entity:has(manager)
  if manager == nil then error("missing argument") end
  return self[manager] ~= nil
end

local function entity_gc(self)
  for manager in pairs(self) do manager:free(self) end
end

-- Create an entity.
function emgr.entity()
  return setmetatable({}, {__index = entity, __gc = entity_gc})
end

return emgr
