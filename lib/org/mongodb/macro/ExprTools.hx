package org.mongodb.macro;

import haxe.macro.Context.*;
import haxe.macro.Expr;
using haxe.macro.ExprTools;

class ExprTools {

    public static function toComplexType(t:Expr):ComplexType
    {
        return switch (parse('(_:${t.toString()})', t.pos)) {
        case macro (_:$t): t;
        case all: throw "assert";
        }
    }

    public static function hasField(e:Expr, name:String):Bool
    {
        return switch (e.expr) {
        case EObjectDecl(fs):
            for (f in fs) {
                if (f.field == name)
                    return true;
            }
            return false;
        case all:
            throw 'Assert: $all';
        }
    }

}

