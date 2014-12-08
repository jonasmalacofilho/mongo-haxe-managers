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
            { module : "compile.TestTyping", vars : ["bt", "bterror8"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror9"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror10"], result : BFailure(null, ~/invalid type for field name/i) },
            { module : "compile.TestTyping", vars : ["bt", "bterror11"], result : BFailure(null, ~/\$in expects an array/i) },
            // { module : "compile.TestTyping", vars : ["bt", "bterror12"], result : BFailure(null, null) },
            // { module : "compile.TestTyping", vars : ["bt", "bterror13"], result : BFailure(null, null) },
            // { module : "compile.TestTyping", vars : ["bt", "bterror14"], result : BFailure(null, null) },
            // { module : "compile.TestTyping", vars : ["bt", "bterror15"], result : BFailure(null, null) },
            { module : "compile.TestTyping", vars : ["bt", "btcur"],     result : BSuccess }
        ]);
    }

}

#else

import compile.DocumentTypes;
import haxe.macro.Expr;
import mongodb._impl.ManagerMacros;

class TestTyping {

    public static function main()
    {
#if btgood
        // basics
        check(Person, { name : "Fury", age : 90 });
        check(Person, { name : "Fury" });
        check(Person, { age : 90 });
        check(Person, { name : "Fury", age : { "$gt" : 40 } });

        // emebedded objects
        check(Boss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(Boss, { title : "Director", person : { name : "Fury" } });
        check(Boss, { title : "Director" });

        // abstracts, classes and interfaces
        check(ABoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(CBoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(IBoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(CEBoss, { title : "Director", person : { name : "Fury", age : 90 } });
        check(Team, { name : "S.H.I.E.L.D", boss : { title : "Director", person : { name : "Fury", age : 90 } } });

        // embedded arrays
        check(Team, { people : [{ name : "Fury" }] });
        check(Team, { people : { "$in" : [{ name : "Fury" }] } });

        // op $in for matching values
        check(Person, { name : { "$in" : ["Coulson", "Fury"] } });

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
#elseif bterror8
        check(Team, { people : [{ name : 1 }] });
#elseif bterror9
        check(Team, { people : { "$in" : [{ name : 1 }] } });
#elseif bterror10
        check(Person, { name : { "$in" : [1] } });
#elseif bterror11
        check(Person, { name : { "$in" : "Fury" } });
#elseif btcur
        // var p = { people : [{ name : "Fury" }] };
        // var q:{ people:Array<{ name:String }> } = cast null;
        // p = q;
#end
    }

    public static macro function check(t:Expr, e:Expr):Expr
    {
        ManagerMacros.typeCheck(ManagerMacros.toComplexType(t), e);
        return macro null;
    }

}

#end

