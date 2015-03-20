package org.mongodb.macro;

#if macro

import haxe.macro.Context.*;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ComplexTypeTools;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using org.mongodb.macro.ExprTools;
using org.mongodb.macro.TypeTools;

class Typer {

    public static function typeCheck(t:ComplexType, e:Expr, ?name:String)
    {
        _typeCheck(t.toType(),e,name);
    }

    private static function _typeCheck(t:Type, e:Expr, ?name:String)
    {
#if HXMOM_TYPER_TRACES
        trace('Type check { $name : ${e.toString()} }:${t.toString()}');
        // trace(e);
        // trace(t);
#end
        switch (e.expr) {
        case EObjectDecl(fs):
            if (name == null) {  // query/base object
                for (f in fs)
                    _typeCheck(t, f.expr, f.field);
            } else {
                for (f in fs) {
                    if (f.field.substr(0, 9) == "@$__hx__$") {  // mongo operators, i.e., $gt
                        var op = f.field.substr(8);
                        switch (op) {
                        case "$in", "$nin", "$all" if (!f.expr.expr.match(EArrayDecl(_))):
                            error('Query operator $op expects an array', e.pos);
                        case all:
                            _typeCheck(t, f.expr, name);
                        }
                    } else {  // embedded object fields
                        var ft = t.getField(name);
                        if (ft != null) {
                            // trace(ft.type);
                            switch (ft.type) {
                            case TInst(_.get() => { name : "Array" }, [atype]):  // embedded array
                                _typeCheck(atype, e, null);
                            case all:
                                _typeCheck(ft.type, e, null);
                            }
                        } else {
                            error('No field $name', e.pos);
                        }
                    }
                }
            }
        case EBlock([]):  // {}
            // NOOP: emtpy query is always valid
        case EArrayDecl(subs):
            for (s in subs)
                _typeCheck(t, s, name);
        case all:
#if HXMOM_TYPER_TRACES
            trace('Final type check field $name');
#end
            var t = TypeTools.getUnderlying(t).toComplexType();
            try {
                typeof(macro {
                    var p = { $name : $e };
                    var q:$t = cast null;
                    p = q;
                });
            } catch (exception:Dynamic) {
                try {
                    typeof(macro {
                        var p = { $name : [$e] };
                        var q:$t = cast null;
                        p = q;
                    });
                } catch (exception:Dynamic) {
                    trace(exception);
                    var reg = ~/(.+) should be (.+)/g;
                    error(reg.replace(exception.toString(), "$2 should be $1"), e.pos);
                }
            }
        }
    }

    static function _forbidNulls(t:ComplexType, e:Expr):Expr
    {
        // TODO
        return e;
    }

    public static function forbidNulls(t:ComplexType, e:Expr):Expr
    {
        switch (e.expr) {
        case EObjectDecl(_):
            return e.map(_forbidNulls.bind(t));
        case all:
            throw 'Assert: $all';
        }
    }

}

#end

