# `PRÖTØ` - the simplest prototype ÖØP in Lua

## 🎉 GOOD NEWS EVERYONE 🎉

Metatables are not supported anymore! 😆

SEE [NEWS.MD](news.md)

## Why?

It's no secret that there is a huge variety of different OOP libraries for Lua
and I'm even the author of one of them, but why did I think about writing
one more?

The fact is that no matter how lite and simple library is, it may somehow have
its own rules that the object-table must follow, and most often such tables are
modified (infected) with libraries, receiving various methods from them, without
which the table can not be considered object at all.

So I decided to write a library that treats absolutely any table as object.
It does not matter where this table came from, how it was created or what is
inside it. In fact, this library is just a set of auxiliary functions for
working with any tables in OOP style.

## Installation

`luarocks install proto`

Or download/clone the lua file/repository into your project,
To have smart tips in [VSCodium][2].

## General principles and terminology

Note that PRÖTØ uses a programming paradigm called [prototype programming][1].
The main difference between prototype-based and class-based OOP is that we
have no concept of Class.

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
  local super = proto.index(self)
  super.init(self, conf)

  self.conf = conf
  return self
end

-- For one instance we can simply init our table and start using it.
o:init(conf)

-- For many instances we need to use library.
local another_o = proto.link({}, o):init(conf)
```

## Arsenal

We have only 4 simple but powerful tools at our disposal:

+ `proto.link(t1, t2, name)`: simple inheritance (linking tables via `__index`)
+ `proto.parents(self, limit)`: iterator for all linked tables
+ `proto.slots(self, limit)`: iterator for all slots from self and linked tables
+ `proto.index(self)`: simply get __index

For detailed API see [proto.lua](proto.lua),
examples in [example.lua](example.lua).

The last thing you should notice is that `proto.link(t, ...)`
and `proto(t, ...)` are not functionally different, but if you are using
language server such as `sumneko.lua`, then the longer variant is better
for you, because this server is not smart enough (yet) to parse metatables.

## Recommended extensions for VSCodium

+ `sumneko.lua` - smart tips on all my functions and more
+ `rog2.luacheck` - linter
+ `tomblind.local-lua-debugger-vscode` - debugger

## Caveats

This library is still very young and poorly covered by tests, so it can easily
have bugs, inaccuracies and defects, but at the same time it is pretty simple
and fix any bug is not very difficult. So if you find a bug or if you have any
idea how to improve it - feel free to create issues!

[1]: https://en.wikipedia.org/wiki/Prototype-based_programming
[2]: https://vscodium.com
