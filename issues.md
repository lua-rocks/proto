# Known issues

+ [ ] Extending custom `__index` is extremely hard task :<
+ [ ] You cannot see inheritance tree in debugger

## Theoretical solution for both issues

I should try to replace ugly nested metaindexes with
plain array of proto-objects stored in metatable,
which will also simplify the `get_tables` method to a single command.
