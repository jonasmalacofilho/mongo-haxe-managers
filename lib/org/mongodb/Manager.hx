package org.mongodb;

import haxe.macro.Context.*;
import haxe.macro.Expr;
import haxe.macro.Type;
import org.mongodb.Collection;
import org.mongodb.macro.Typer;
using haxe.macro.ComplexTypeTools;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;

class Manager<T> {

#if macro
    static function getType(e:Expr):ComplexType
    {
        switch (typeof(e)) {
        case TInst(_.get() => { pack : ["org","mongodb"], name : "Manager" },[tp]):
            var ct = tp.toComplexType();
            return ct;
        case all:
            throw 'Assert: $all';
        }
    }
#end

    public var col:Collection;

    public function new(col)
    {
        this.col = col;
    }

    public macro function find(ethis:Expr, e:Expr):Expr
    {
        Typer.typeCheck(getType(ethis), e);
        // TODO modify query to reject unnexpected null fields
        return macro @:privateAccess $ethis._find($e);
    }

    public macro function findOne(ethis:Expr, e:Expr):Expr
    {
        Typer.typeCheck(getType(ethis), e);
        // TODO modify query to reject unnexpected null fields
        // var _e = org.mongodb.macro.Typer.forbidNulls($v{ct}, e);
        // trace(haxe.macro.ExprTools.toString(_e));
        return macro @:privateAccess $ethis._findOne($e);
    }

		@:extern inline private function _findOne(dyn:Dynamic):T
		{
			return this.col.findOne(dyn);
		}

		@:extern inline private function _find(dyn:Dynamic):Cursor<T>
		{
			return cast this.col.find(dyn);
		}

    public function insert(doc:T):Void
    {
        col.insert(doc);
    }


    public macro function update(ethis:Expr, query:Expr, update:Expr, ?upsert:ExprOf<Bool>, ?multi:ExprOf<Bool>):Expr
    {
        Typer.typeCheck(getType(ethis), query);
        // TODO check update
        return macro $ethis.col.update($query, $update, $upsert, $multi);
    }

    public function drop():Void
    {
        col.drop();
    }

}

