package compile;

#if !bt

class TestTyping extends BuildTester {

    public function new()
    {
        super([
            { module : "compile.TestTyping", vars : ["bt", "btgood"],    result : BSuccess },
            { module : "compile.TestTyping", vars : ["bt", "bterror1"],  result : BFailure(null, ~/unexpected 1/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror2"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror3"],  result : BFailure(null, ~/invalid type for field age/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror4"],  result : BFailure(null, ~/invalid type for field age/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror5"],  result : BFailure(null, ~/invalid type for field title/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror6"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror7"],  result : BFailure(null, ~/invalid type for field age/i) },
            // { module : "compile.TestTyping", vars : ["bt", "bterror8"],  result : BFailure(null, null) },
            // { module : "compile.TestTyping", vars : ["bt", "bterror9"],  result : BFailure(null, null) },
            // { module : "compile.TestTyping", vars : ["bt", "bterror10"], result : BFailure(null, null) },
            { module : "compile.TestTyping", vars : ["bt", "btcur"],     result : BSuccess }
        ]);
    }

}

#else

import haxe.macro.Expr;
import mongodb._impl.ManagerMacros;

typedef Person = {
    name : String,
    age : Int
}

typedef Boss = {
    title : String,
    person : Person
}

// `to Boss` is important! FIXME
@:forward
abstract ABoss(Boss) to Boss {
}

class CBoss {
    public var title : String;
    public var person : Person;
}

interface IBoss {
    var title : String;
    var person : Person;
}

class CEBoss extends CBoss {
}

typedef Team = {
    name : String,
    boss : CBoss,
    people : Array<Person>
}

class TestTyping {

    public static function main()
    {
#if btgood
        check(Person, { name : "Fury", age : 90 });
        check(Person, { name : "Fury" });
        check(Person, { age : 90 });
        check(Person, { name : "Fury", age : { "$gt" : 40 } });

        check(Boss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(Boss, { title : "Director", person : { name : "Fury" } });
        check(Boss, { title : "Director" });

        check(ABoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(CBoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(IBoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(CEBoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(Team, { name : "S.H.I.E.L.D", boss : { title : "Director", person : { name : "Fury", age : 90 } } });

        // Expected errors: 
#elseif bterror1
        check(1, { age : "ninety" });
#elseif bterror2
        check(Person, { name : 1 });
#elseif bterror3
        check(Person, { age : "ninety" });
#elseif bterror4
        check(Person, { age : { "$gt" : "forty" } });
#elseif bterror5
        check(Boss, { title : 1 });
#elseif bterror6
        check(Boss, { title : "Director", person : { name : 1 } });
#elseif bterror7
        check(Team, { name : "S.H.I.E.L.D", boss : { person : { age : "ninety" } } });
// #elseif bterror8
// #elseif bterror9
// #elseif bterror10
#elseif btcur
#end
    }

    public static macro function check(t:Expr, e:Expr):Expr
    {
        return ManagerMacros.findImpl(ManagerMacros.toComplexType(t), e);
    }

}

#end

