# MongoDB typed managers for Haxe

Specialized macro-built managers for MongoDB collections that work on top of
the [mongodb] library.

Please note that the currenct version expects a particular [fork] of the
mongodb library.

[![Build Status](https://travis-ci.org/jonasmalacofilho/mongo-haxe-managers.svg?branch=master)](https://travis-ci.org/jonasmalacofilho/mongo-haxe-managers)

[mongodb]: https://github.com/MattTuttle/mongo-haxe-driver
[fork]: https://github.com/jonasmalacofilho/mongo-haxe-driver/tree/managers

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

