local huge = math.huge

---## `PRÖTØ`
---### The simplest implementation of a prototype ÖØP in Lua.
---@class lib.proto
local proto = {}

---Link T1 to T2 via `__index`.
---@generic T1:table, T2:table
---@param t1 T1
---@param t2 T2
---@param name? string
---@return T1|T2 result
function proto.link(t1, t2, name)
  local mt = getmetatable(t1) or {}
  if type(name) == "string" then
    mt.__tostring = function()
      return name
    end
  end
  mt.__index = t2
  return setmetatable(t1, mt)
end

---Parents iterator.
---@param self table
---@param limit number
---@return fun(): table
function proto.parents(self, limit)
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
function proto.slots(self, limit)
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
---@return table
function proto.index(self)
  local mt = getmetatable(self)
  if mt then
    return mt.__index
  end
end

return setmetatable(proto, {
  __tostring = function()
    return "PRÖTØ v0.2.0"
  end,
})
