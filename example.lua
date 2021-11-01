local proto = require 'proto'

-- Variables named with capital letters called
-- "**prototypes**", not a "*classes*"! 😝
--
-- `proto(...)` is shortcut for `proto.link(...)`
-- Names at the end can be skipped. It's only for debugging.
--
-- But when you call them in format `require.path-name`,
-- debugging of your entire project becomes much more convenient!
---@class lib.example-animal
---@field dead boolean
---@field legs number?
---@field paws number?
local Animal = proto({
  dead = false
}, 'Animal') -- "lib.example-animal" is better than "Animal" for debugging

function Animal:can_breath()
  return not self.dead
end

function Animal:can_walk()
  if not self.dead
    and (self.paws or 0) > 2
    or (self.legs or 0) > 1
    then return true
    else return false
  end
end


---@class lib.example-bird:lib.example-animal
---@field wings number?
local Bird = proto({ wings = 2 }, Animal, 'Bird')

function Bird:can_fly()
  if not self.dead
    and (self.wings or 0) > 1
    then return true
    else return false
  end
end


---@class lib.example-mammal:lib.example-animal
local Mammal = proto({}, Animal, 'Mammal')


---@class lib.example-cat:lib.example-mammal
---@field tails number?
local Cat = proto({
  paws = 4,
  tails = 1
}, Mammal, 'Cat')


function Cat:born(name) -- Constructor.
  self.name = name or self.name
end


function Cat.shout()
  print 'Meow!'
end


---@class lib.example-knife
local Knife = {}

function Knife.hit(target)
  for _, limbs in ipairs {'paws', 'wings'} do
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
local cat1 = proto({}, Cat, 'cat1')
cat1:born('Tom')


local cat1_hierarchy = proto.get_tables(cat1)
assert(cat1_hierarchy[1] == cat1)
assert(cat1_hierarchy[2] == Cat)
assert(cat1_hierarchy[3] == Mammal)
assert(cat1_hierarchy[4] == Animal)


-- `proto(t)` (with **ONE** argument) is shortcut for `proto.iter(t)`
local function dump(x)
  for k, v, t in proto(x) do
    print(tostring(x) ..
      ' has slot ' .. k ..
      ' from table ' .. tostring(t) ..
      ' and its value is ' .. tostring(v))
  end
end


assert(cat1:can_walk() == true)
Knife.hit(cat1)
assert(cat1:can_walk() == false)
Knife.hit(cat1)
assert(cat1:can_breath() == false)
print('RIP, ' .. cat1.name .. '.')


---@class lib.example-penguin:lib.example-animal,lib.example-bird
---@field description string
local Penguin = proto({
  paws = 2,
  description = 'Penguin is complex Animal',
  can_fly = function () return false end
}, Animal, nil, Bird, 'Penguin') -- Nils are skipped!

---@type lib.example-penguin
local peng1 = proto({ name = 'Tux' }, Penguin, 'peng1')

assert(peng1.paws == 2)
assert(peng1.wings == 2)

dump(peng1)

-- Meta-merge test

local Bird_mt = getmetatable(Bird)

function Bird_mt:__call()
  print(self.name .. ' CALLED!')
end

proto.merge_meta(peng1)
peng1()
