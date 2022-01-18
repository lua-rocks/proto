# `PRÖTØ` - the simplest prototype ÖØP in Lua

## 🎉 GOOD NEWS EVERYONE 🎉

Metatables are not supported anymore! 😆

SEE [NEWS.MD](news.md)

## Why?

It's no secret that there is a huge variety of different OOP libraries for Lua
and I'm even the author of one of them, but why did I think about writing one
more?

The fact is that no matter how lite and simple library is, it may somehow have
its own rules that the object-table must follow, and most often such tables are
modified (infected) with libraries, receiving various methods from them, without
which the table can not be considered object at all.

So I decided to write a library that treats absolutely any table as object. It
does not matter where this table came from, how it was created or what is inside
it. In fact, this library is just a set of auxiliary functions for working with
any tables in OOP style.

## Installation

`luarocks install proto`

Or download/clone the lua file/repository into your project, To have smart tips
in [VSCodium][2].

## General principles and terminology

Note that PRÖTØ uses a programming paradigm called [prototype programming][1].
The main difference between prototype-based and class-based OOP is that we have
no concept of Class.

It's very simple: instead of creating classes and their instances, we create an
ordinary table and specify its "relatives" using this library, which it will
refer to via the `__index` meta-method. In this case we call all tables as
tables instead of objects or classes, which in theory makes our life easier and
more pleasant 😺.

Just as a table in lua combines an object and an array, we can also use the
generic term "slot" when talking about methods or fields, as long as we don't
focus on the type of variable.

For example: the `__index` metamethod is more correctly called **metaslot**,
because it can be both a function and a table.

Our tables have no library garbage, so they don't even have constructor
functions, but you can create your own:

```lua
local proto = require "proto"

local o = {}

function o:init(conf)
  -- This way we can init inherited objects:
  proto.get_index(self).init(self, conf)

  self.conf = conf
  return self
end

-- For one instance we can simply init our table and start using it.
o:init(conf)

-- For many instances we need to use library.
local another_o = proto.link({}, o):init(conf)
```

There is one thing you should know, which can make your life much easier - you
no need to use interface (table `conf` in example above) as constructor argument
(`init(conf)`)! You can just use it as first argument in `proto.link`, so you
will no need to write annoying code like `self.something = conf.something`, but
only update it if it needs to be changed in initialization process.

Example:

```lua
function vector:init()
  --- Deprecated:
  -- self[1] = conf[1]
  -- self[2] = conf[2]

  -- Update only if needed
  if type(self[1]) == "string" then self[1] == tonumber(self[1]) end

  return self
end

local v = proto.link({"640", 480}, vector):init()
```

In this case you can use `proto.new`, which will automatically call table's
`init` method right after linking **without arguments**.

```lua
local v = proto.new({"640", 480}, vector)
```

## Arsenal

We have only 7 simple but powerful tools at our disposal:

- Main:
  - `proto.link(self, t2, name?)`: inheritance (linking tables via `__index`)
  - `proto.copy(self)`: sometimes cloning copies is faster than building
- Iterators:
  - `proto.parents(self, limit?)`: for all linked tables
  - `proto.slots(self, limit?)`: for all slots from self and linked tables
- Helpers:
  - `proto.get_index(self)`: get `__index` metaslot
  - `proto.set_name(self, name?)`: set `__tostring` metaslot
  - `proto.new(self, name?)`: constructor for tables with `init` method

For detailed API see [init.lua](init.lua), examples in
[example.lua](example.lua).

## Recommended extensions for VSCodium

- `sumneko.lua` - smart tips on all my functions and more
- `rog2.luacheck` - linter
- `tomblind.local-lua-debugger-vscode` - debugger

## Caveats

This library is still very young and poorly covered by tests, so it can easily
have bugs, inaccuracies and defects, but at the same time it is pretty simple
and fix any bug is not very difficult. So if you find a bug or if you have any
idea how to improve it - feel free to create issues!

[1]: https://en.wikipedia.org/wiki/Prototype-based_programming
[2]: https://vscodium.com
