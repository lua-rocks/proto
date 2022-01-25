local huge = math.huge

---## `PRÖTØ`
---### The simplest implementation of a prototype ÖØP in Lua.
---@class lib.table.proto
local proto = {}

---Link T2 to T1 via `__index`.
---@generic T1, T2
---@param t1 T1
---@param t2 T2
---@param name? string
---@return T1|T2 result
function proto.link(t1, t2, name)
  local _, mt = proto.set_name(t1, name)
  mt.__index = t2
  return t1
end

---Constructor.
---Table must have method `init`, which will be called without arguments.
---
---```lua
---local size = proto.new(Vector, {640, 480})
---```
---@generic T
---@param super T
---@param init T
---@param name? string
---@return T
function proto.new(super, init, name)
  name = name or ("new " .. tostring(super))
  return proto.link(init, super, name):init()
end

---Create a copy of self.
---@generic T
---@param t T
---@return T
function proto.copy(t)
  local new = {}
  for key, value in proto.slots(t) do
    new[key] = value
  end
  local mt = getmetatable(t)
  if mt then
    setmetatable(new, { __tostring = mt.__tostring })
  end
  return new
end

---Parents iterator.
---@param t table
---@param limit number
---@return fun(): table
function proto.parents(t, limit)
  limit = limit or huge
  local counter = 0
  local function next_iter()
    if counter < limit then
      local mt = getmetatable(t)
      if type(mt) == "table" and type(mt.__index) == "table" then
        t = mt.__index
        counter = counter + 1
        return t
      end
    end
  end
  return next_iter
end

---Slots iterator.
---@param t table
---@param limit number
---@return fun(): any, any, table
function proto.slots(t, limit)
  limit = limit or huge
  local counter = 0
  local key, value
  local function next_iter()
    if counter < limit then
      key, value = next(t, key)
      if key then
        return key, value, t
      else
        local mt = getmetatable(t)
        if type(mt) == "table" and type(mt.__index) == "table" then
          t = mt.__index
          counter = counter + 1
          return next_iter()
        end
      end
    end
  end
  return next_iter
end

---Helper for getting __index.
---@param t table
---@return table?
function proto.get_index(t)
  local mt = getmetatable(t)
  if mt then
    return mt.__index
  end
end

---Helper for setting __tostring.
---@generic T
---@param t T
---@param name? string
---@return T
---@return table metatable
function proto.set_name(t, name)
  local mt = getmetatable(t)
  if not mt then
    mt = {}
    setmetatable(t, mt)
  end
  if name then
    mt.__tostring = function()
      return name
    end
  end
  return t, mt
end

return proto:set_name("PRÖTØ v0.3.0")
