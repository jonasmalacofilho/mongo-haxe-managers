# MongoDB typed managers for Haxe

Specialized macro-built managers for MongoDB collections that work on top of
the [mongodb] library.  

[mongodb]: https://github.com/jonasmalacofilho/mongo-haxe-driver

## Features

Feature summary:

 - Type checking for queries and documents
    - Type check queries
    - Type check insert/update documents
    - Ensure proper types for returned objects (TODO)
 - [PLANNED] Support projections; change to `Manager<Object, Projection>`
 - [PLANNED] Shorter syntax for simple queries

Document cache and other possible manager/ORM/SPOD responsibilities are not
planned for the time being.

## Samples

See `test/compile/TestBuilder.hx` and `test/compile/TestTyper.hx`.

## Limitations

It is not possible to build a manager inside the module where its document type
is defined.

