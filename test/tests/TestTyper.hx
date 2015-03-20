package tests;

#if !bt

class TestTyper extends BuildTester {

    public function new()
    {
        super([
            { module : "tests.TestTyper", vars : ["bt", "btgood"],    result : BSuccess },
            { module : "tests.TestTyper", vars : ["bt", "bterror1"],  result : BFailure(null, ~/unexpected 1/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror2"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror3"],  result : BFailure(null, ~/invalid type for field age/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror4"],  result : BFailure(null, ~/invalid type for field age/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror5"],  result : BFailure(null, ~/invalid type for field title/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror6"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror7"],  result : BFailure(null, ~/invalid type for field age/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror8"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror9"],  result : BFailure(null, ~/invalid type for field name/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror10"], result : BFailure(null, ~/invalid type for field name/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror11"], result : BFailure(null, ~/\$in expects an array/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror12"], result : BFailure(null, ~/invalid type for field name/i) },
            { module : "tests.TestTyper", vars : ["bt", "bterror13"], result : BFailure(null, ~/invalid type for field tag/i) },
            // { module : "tests.TestTyper", vars : ["bt", "bterror14"], result : BFailure(null, null) },
            // { module : "tests.TestTyper", vars : ["bt", "bterror15"], result : BFailure(null, null) },
            { module : "tests.TestTyper", vars : ["bt", "btcur"],     result : BSuccess }
        ]);
    }

}

#else

import haxe.macro.Expr;
import org.mongodb.macro.Typer;
import tests.SomeTypes;
using org.mongodb.macro.ExprTools;

class TestTyper {

    public static function main()
    {
#if btgood
        // basics
        check(Person, { name : "Fury", age : 90 });
        check(Person, { name : "Fury" });
        check(Person, { age : 90 });
        check(Person, { name : "Fury", age : { "$gt" : 40 } });
        check(Person, {});

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
        check(Team, { people : { name : "Fury" } });
        check(Team, { tags : "blue" });  // issue #1

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
#elseif bterror12
        check(Team, { people : { name : 1 } });
#elseif bterror13
        check(Team, { tags : 33 });
#elseif btcur
#end
    }

    public static macro function check(t:Expr, e:Expr):Expr
    {
        Typer.typeCheck(t.toComplexType(), e);
        return macro null;
    }

}

#end

