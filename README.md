# Haxe MongoDB object managers

Specialized macro-built managers.

## Features

Feature summary:

 - Type checking for queries and documents
    - Type check queries
    - Type check insert/update documents
    - Ensure proper types for returned objects
      (inject projection specification in the query)
 - [PLANNED] Shorter syntax for simple queries

Document cache and other possible manager/ORM/SPOD responsibilities are not
planned for now.

## Samples

See `test/compile/TestBuild.hx` and `test/compile/TestTyping.hx`.

## Limitations

It is not possible to build a manager inside the module where its document type
is defined.

