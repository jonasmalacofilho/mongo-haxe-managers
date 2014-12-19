package org.mongodb.macro;

import haxe.macro.Context.*;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ComplexTypeTools;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;

class Builder {

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

        var ct = t.toComplexType();

        var _E = macro :haxe.macro.Expr;
        var _EBool = macro :haxe.macro.Expr.ExprOf<Bool>;

        var man = macro class {

            public var col:org.mongodb.Collection;

            public function new(col)
            {
                this.col = col;
            }

            public macro function find(ethis:$_E, e:$_E):$_E
            {
                org.mongodb.macro.Typer.typeCheck($v{ct}, e);
                // TODO modify query to reject unnexpected null fields
                return macro $ethis.col.find($e);
            }

            public macro function findOne(ethis:$_E, e:$_E):$_E
            {
                org.mongodb.macro.Typer.typeCheck($v{ct}, e);
                // TODO modify query to reject unnexpected null fields
                // var _e = org.mongodb.macro.Typer.forbidNulls($v{ct}, e);
                // trace(haxe.macro.ExprTools.toString(_e));
                return macro $ethis.col.findOne($e);
            }

            public function insert(doc:$ct):Void
            {
                col.insert(doc);
            }

            public macro function update(ethis:$_E, query:$_E, update:$_E, ?upsert:$_EBool, ?multi:$_EBool):$_E
            {
                org.mongodb.macro.Typer.typeCheck($v{ct}, query);
                // TODO check update
                return macro $ethis.col.update($query, $update, $upsert, $multi);
            }

            public function drop():Void
            {
                col.drop();
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
				case TAbstract(_.get().name => name, params):
            base + "_" + name + params.join("_");
        case all:
            throw 'Assert $all';
        }
    }

}

