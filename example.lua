local proto = require("init")

-- Variables named with capital letters called
-- "**prototypes**", not a "*classes*"! 😝
--
-- Names at the end can be skipped. It's only for debugging.
-- But when you call them in format `require.path-name`,
-- debugging of your entire project becomes much more convenient!
---@class lib.example-animal
---@field dead boolean
---@field legs number?
---@field paws number?
local Animal = proto.set_name({ dead = false }, "lib.example-animal")

function Animal:can_breath()
  return not self.dead
end

function Animal:can_walk()
  if not self.dead and (self.paws or 0) > 2 or (self.legs or 0) > 1 then
    return true
  else
    return false
  end
end

---@class lib.example-bird:lib.example-animal
---@field wings number?
local Bird = proto.link({ wings = 2 }, Animal, "lib.example-bird")

function Bird:can_fly()
  if not self.dead and (self.wings or 0) > 1 then
    return true
  else
    return false
  end
end

---@class lib.example-mammal:lib.example-animal
local Mammal = proto.link({}, Animal, "lib.example-mammal")

---@class lib.example-cat:lib.example-mammal
---@field tails number?
local Cat = proto.link({
  paws = 4,
  tails = 1,
}, Mammal, "lib.example-cat")

function Cat:born(name) -- Simplest initializer.
  self.name = name or self.name
end

function Cat.shout()
  print("Meow!")
end

---@class lib.example-knife
local Knife = {}

function Knife.hit(target)
  for _, limbs in ipairs({ "paws", "wings" }) do
    if target[limbs] then
      target[limbs] = target[limbs] - 2
      target.shout()
      if target[limbs] < 1 then
        target[limbs] = 0
        target.dead = true
      end
    end
  end
end

---@type lib.example-cat
local cat1 = proto.link({}, Cat, "cat1")
cat1:born("Tom")

local cat1_hierarchy = {}
for parent in proto.parents(cat1) do
  table.insert(cat1_hierarchy, parent)
end
assert(cat1_hierarchy[1] == Cat)
assert(cat1_hierarchy[2] == Mammal)
assert(cat1_hierarchy[3] == Animal)

cat1_hierarchy = {}
for parent in proto.parents(cat1, 1) do -- don't search deeper than 1
  table.insert(cat1_hierarchy, parent)
end
assert(cat1_hierarchy[1] == Cat)
assert(cat1_hierarchy[2] == nil)
assert(cat1_hierarchy[3] == nil)

assert(cat1:can_walk() == true)
Knife.hit(cat1)
assert(cat1:can_walk() == false)
Knife.hit(cat1)
assert(cat1:can_breath() == false)
print("RIP, " .. cat1.name .. ".")

for k, v, t in proto.slots(cat1) do
  print(k, v, t)
end
