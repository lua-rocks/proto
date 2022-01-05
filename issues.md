# Known issues

+ [ ] Extending custom `__index` is extremely hard task :<
+ [ ] You cannot see inheritance tree in debugger

## Theoretical solution for both issues

I should try to replace ugly nested metaindexes with
plain array of proto-objects stored in metatable,
which will also simplify the `get_tables` method to a single command.

... Or even simpler - add the field `super`. Of course, this means table
"infection" with extra slot, but what can I do better? Current implementation
(__index called with no arguments) is a dirty game too.

This is a big problem, because if I allow myself to expand the table, then this
library, although faster, but much less convenient than the previous one. In
that case, it would be better for me to optimize Object than to make a mutant
from Proto.
