--[[
This file includes examples of the __index extending problems and possible bugs.
I already solved all these problems in my previous OOP library,
but it was quite messy and slow.
]]

local proto = require("proto")

---@class test.vector2
---@field [1] number
---@field [2] number
local Vector2 = {}

function Vector2:init(n1, n2)
  self[1] = n1
  self[2] = n2
  return self
end

-- Problematic part
local t, t_mt = {}, {}
function t_mt:__index(key)
  if key == "x" then
    return self[1]
  end
  if key == "y" then
    return self[2]
  end
  return rawget(self, key)
end
setmetatable(t, t_mt)

---@class test.pos:test.vector2
---@field x number
---@field y number
local Pos = proto.link(t, Vector2)

---@class test.size:test.vector2
---@field w number
---@field h number
local Size = proto.link({}, Vector2)

local pos = proto.link({}, Pos)
proto.merge_meta(pos)

local size = proto.link({ 10, 20 }, Size)

pos:init(1, 2)

assert(pos[1] == 1)
assert(pos[2] == 2)
assert(size[1] == 10)
assert(size[2] == 20)

print(pos.x)
assert(pos.x == 1)

print("no errors")
