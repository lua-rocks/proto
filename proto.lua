-- local inspect = require 'inspect'
-- local function dump(...) print(inspect(...)) end


---# `PRÖTØ`
---## The simplest implementation of a prototype ÖØP in Lua
---**Memoire:** when using variadic arguments in any functions from this
---library, their order is always matters!
---The variables on the left have a higher priority.
---@class lib.proto
local proto = {}


---## `__index` combining
---Accepts many `__index` metaslots and returns universal one.
---### Technical details
---The result can be either a table or a function.
---If you are not satisfied that the resulting `__index` is a function,
---you can call it without arguments to get an array of `__index`
---(which may turn out to be the same functions).
---
---Incorrect types are skipped without causing errors.
---@vararg table|function `__index` set
---@return table|function combined `__index`
local function mix_index(...)
  local args_num = select("#", ...)
  if args_num < 2 then return ... end

  local indexes = {} ---@type function[]
  local last = 0
  for i = 1, args_num do
    local index = select(i, ...)
    if index then
      local t = type(index)
      last = last + 1
      if t == 'table' then
        indexes[last] = function(_, key)
          if key == nil then return { index } end
          return index[key]
        end
      elseif t == 'function' then
        indexes[last] = index
      end
    end
  end

  return function (_, key)
    if key == nil then return indexes end
    for _, index in ipairs(indexes) do
      local result = index(_, key)
      if result ~= nil then return result end
    end
  end
end


---## Multiple inheritance (fast)
---Links a table via `__index` with all tables passed in arguments.
---Optionally you can give it a name in `__tostring`
---by passing **string** at the end.
---
---Calling `proto()` with more than one argument will redirect to this function.
---@generic T
---@param t T a table that will link to all the other tables
---@vararg table set of any tables
---@return T result
function proto.link(t, ...)
  local last = select(-1, ...)
  local mt = getmetatable(t) or {}
  mt.__index = mix_index(mt.__index, ...)
  if type(last) == 'string' then
    mt.__tostring = function () return last end
  end
  return setmetatable(t, mt)
end


---## Metadata merging
---Modifies the metatable of the passed table, combining all metaslots in it:
---its own and inherited from linked via `__index`.
---*Doesn't return anything!*
---@param t table
function proto.merge_meta(t)
  local t_mt = getmetatable(t)
  if not t_mt or not t_mt.__index then return end

  local tables_array = proto.get_tables(t)
  for _, tbl in ipairs(tables_array) do
    local tbl_mt = getmetatable(tbl)
    if tbl_mt then
      for key, value in pairs(tbl_mt) do
        if not t_mt[key] then
          t_mt[key] = value
        end
      end
    end
  end
  setmetatable(t, t_mt)
end


---## Extracting relatives
---Gets all tables adhered to this table through `__index`
---in order, starting with itself. Supports combined indexes
---(index functions that return an array with indexes
---when called without arguments).
---@param t table
---@return table[] all tables
function proto.get_tables(t)
  local result = {}
  local function recursive_extract(index)
    local index_type = type(index)
    if index_type == 'table' then
      table.insert(result, index)
      local mt = getmetatable(index)
      if mt then
        local next_mt_index = mt.__index
        if next_mt_index then
          recursive_extract(next_mt_index)
        end
      end
    elseif index_type == 'function' then
      local index_array = index()
      for _, v in ipairs(index_array) do
        recursive_extract(v)
      end
    end
  end
  recursive_extract(t)
  return result
end


---## Slot looping
---Iterator to enumerate tables with `__index` metaslots
---
---Calling `proto()` with a single argument will redirect to this function.
---```lua
---for k, v, t in proto(x) do
---  print(tostring(x) ..
---    ' has slot ' .. tostring(k) ..
---    ' from table ' .. tostring(t) ..
---    ' and its value is ' .. tostring(v))
---end
---```
function proto.iter(t)
  local passed = {}
  local array = proto.get_tables(t)
  return function ()
    for _, sub_t in ipairs(array) do
      for slot_key, slot_val in pairs(sub_t) do
        if not passed[slot_key] then
          passed[slot_key] = true
          return slot_key, slot_val, sub_t
        end
      end
    end
  end
end


return setmetatable(proto, {
  __call = function (_, ...)
    if select("#", ...) == 1 then
      return proto.iter(...)
    end
    return proto.link(...)
  end,
  __tostring = function ()
    return 'PRÖTØ v0.1.0'
  end
})
