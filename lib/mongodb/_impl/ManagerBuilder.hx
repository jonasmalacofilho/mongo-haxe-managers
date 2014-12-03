package mongodb._impl;

import haxe.macro.Context.*;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ComplexTypeTools;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;

class ManagerBuilder {

    public static function build():Type
    {
        return switch (getLocalType()) {
        case TInst(_.get() => cdef, [t]):
            getOrBuild(cdef.pack, cdef.name, t);
        case all:
            throw 'Assert: $all';
        }
    }

    static function getOrBuild(pack:Array<String>, baseName:String, t:Type):Type
    {
        var name = buildName(t, baseName);
        var fullName = '${pack.join(".")}.$name';

        var built = try getType(fullName) catch (e:Dynamic) null;
        if (built != null)
            return built;

        var man = macro class {

            public function new()
            {

            }

            public macro function find(ethis:haxe.macro.Expr, e:haxe.macro.Expr):haxe.macro.Expr
            {
                return mongodb._impl.ManagerMacros.findImpl($v{t.toComplexType()}, e);
            }

        };
        man.pack = pack;
        man.name = name;
        defineType(man);

        return getType(fullName);
    }

    static function buildName(t:Type, base:String):String
    {
        return switch (t) {
        case TInst(_.get().name => name, params):
            base + "_" + name + params.join("_");
        case TType(_.get().name => name, params):
            base + "_" + name + params.join("_");
        case all:
            throw 'Assert $all';
        }
    }

}

