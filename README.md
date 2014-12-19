# MongoDB typed managers for Haxe

Specialized macro-built managers for MongoDB collections that work on top of
the [mongodb] library. Please note that the current version expects a
particular [fork] of the mongodb library.

Finally, the manager build macros only work on current Haxe git versions,
[1fda495] or newer. Builds for these versions are available on the [hxbuilds]
website.

[![Build Status](https://travis-ci.org/jonasmalacofilho/mongo-haxe-managers.svg?branch=master)](https://travis-ci.org/jonasmalacofilho/mongo-haxe-managers)

[mongodb]: https://github.com/MattTuttle/mongo-haxe-driver
[fork]: https://github.com/jonasmalacofilho/mongo-haxe-driver/tree/managers
[1fda495]: https://github.com/HaxeFoundation/haxe/commit/1fda495a494665148c0171fef4189eb3c21fa5f6
[hxbuilds]: http://hxbuilds.s3-website-us-east-1.amazonaws.com/builds/haxe/index.html

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

