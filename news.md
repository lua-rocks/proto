# News

At some point I decided to discontinue support this repository because found the
implementation of the `__index` metamethod inheritance incredibly complex. Plus
it was already implemented and had worked fine in my previous OOP library, so I
decided to go back to it.

But later it occurred to me - how important is meta-table inheritance in OOP?
First of all, what do we use meta-tables for? What are their advantages and
disadvantages? This is the conclusion I came to:

## Advantages

+ Our code looks nicer at the expense of homemade syntactic sugar;
+ We can impose read and write restrictions;
+ We can optimize the garbage collector by specifying weakness (`__mode`).

## Disadvantages

+ Hell for the LSP - the code editor can't provide smart hints
  and other important help;
+ We have to always keep in mind the fact that the table is "special"
  and if we forget, it can cause very unpleasant bugs.
+ Code without meta-tables is faster (except for `__mode`).

## Conclusions

First of all, we are faced with a choice: which is more convenient - a short
syntax at the expense of meta-tables or a long syntax with smart hints and
strict typing?

This choice reminds me a lot of choosing between
[moonscript](https://moonscript.org) and
[teal](https://github.com/teal-language/tl); between sweet and warm. Personally
I prefer strict typing (it's a pity that OOP in teal is not supported yet).

About the other two advantages - I feel that 99.99% of the time they should be
applied to the instances rather than inherited from classes. Even if it
wouldn't be as convenient for you, it would be much faster in execution!

Anyway, I've decided to restore this repository and continue to support it. This
library will become even lighter and faster, **BUT** I have to impose a very
strong restriction - **no more meta-table inheritance**!

If you don't like this solution, that's fine! Especially for you I have
[Öbject](https://github.com/lua-rocks/object).
