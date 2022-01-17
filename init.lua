local huge = math.huge

---## `PRÖTØ`
---### The simplest implementation of a prototype ÖØP in Lua.
---@class lib.proto
local proto = {}

---Link T2 to T1 via `__index`.
---@generic T1:table, T2:table
---@param self T1
---@param t2 T2
---@param name? string
---@return T1|T2 result
function proto:link(t2, name)
  local _, mt = proto.set_name(self, name)
  mt.__index = t2
  return self
end

---Create a copy of self
---@generic T
---@param self T
---@return T
function proto:copy()
  local t = {}
  for key, value in proto.slots(self) do
    t[key] = value
  end
  local mt = getmetatable(self)
  if mt then
    setmetatable(t, { __tostring = mt.__tostring })
  end
  return t
end

---Parents iterator.
---@param self table
---@param limit number
---@return fun(): table
function proto:parents(limit)
  limit = limit or huge
  local counter = 0
  local function next_iter()
    if counter < limit then
      local mt = getmetatable(self)
      if type(mt) == "table" and type(mt.__index) == "table" then
        self = mt.__index
        counter = counter + 1
        return self
      end
    end
  end
  return next_iter
end

---Slots iterator.
---@param self table
---@param limit number
---@return fun(): any, any, table
function proto:slots(limit)
  limit = limit or huge
  local counter = 0
  local key, value
  local function next_iter()
    if counter < limit then
      key, value = next(self, key)
      if key then
        return key, value, self
      else
        local mt = getmetatable(self)
        if type(mt) == "table" and type(mt.__index) == "table" then
          self = mt.__index
          counter = counter + 1
          return next_iter()
        end
      end
    end
  end
  return next_iter
end

---Simple helper for getting __index.
---@param self table
---@return table?
function proto:get_index()
  local mt = getmetatable(self)
  if mt then
    return mt.__index
  end
end

---Simple helper for setting __tostring.
---@generic T: table
---@param self T
---@param name? string
---@return T
---@return table metatable
function proto:set_name(name)
  local mt = getmetatable(self)
  if not mt then
    mt = {}
    setmetatable(self, mt)
  end
  if name then
    mt.__tostring = function()
      return name
    end
  end
  return self, mt
end

return proto:set_name("PRÖTØ v0.2.2")
