package org.mongodb.macro;

import haxe.macro.Type;
using haxe.macro.TypeTools;

class TypeTools {

    static function isVar(f:ClassField)
    {
        return f.kind.match(FVar(_));
    }

    public static function getUnderlying(t:Type)
    {
        return switch(t.follow()) {
            case TAbstract(_.get() => abs, params) if (!abs.meta.has(':coreType')):
              getUnderlying( abs.type.applyTypeParameters(abs.params, params) );
            case t:
              t;
        }
    }

    public static function selectField(fields:Array<ClassField>, name:String):Null<ClassField>
    {
        for (f in fields)
            if (isVar(f) && f.name == name)
                return f;
        return null;
    }

    public static function getField(t:Type, name:String):Null<ClassField>
    {
        switch (t) {
        case TType(_, _):
            return getField(t.follow(), name);
        case TAnonymous(_.get() => anon):
            return selectField(anon.fields, name);
        case TInst(_.get() => cl, _):
            return cl.findField(name);
        case TAbstract(_.get() => abs, _):
            if (abs.meta.has(":coreType"))
                throw 'Assert: core $abs';
            return getField(abs.type, name);
        case all:
            throw 'Assert: $all';
        }
    }

    public static function fields(t:Type):Array<ClassField>
    {
        switch (t) {
        case TType(_, _):
            return fields(t.follow());
        case TAnonymous(_.get() => anon):
            return anon.fields.filter(isVar);
        case TInst(_.get() => cl, _):
            return cl.fields.get().filter(isVar);
        // case TAbstract(_.get() => abs, _):
        //     if (abs.meta.has(":coreType"))
        //         throw 'Assert: core $abs';
        //     return typeFields(abs.type);
        case all:
            throw 'Assert: $all';
        }
    }

}

