# Changelog

## 0.3.0 - Constructor is ready to use

```lua
local size = proto.new(Vector, {640, 480})
```

## 0.2.0 - Remove metatables inheritance

All functionality relating to meta-table inheritance was unnecessary bloat and I
decided to remove it, but that's not a problem at all, because you can simply
set meta-tables from normal methods, such as constructor.

## 0.1.0 - Init

- Initialize git repository
