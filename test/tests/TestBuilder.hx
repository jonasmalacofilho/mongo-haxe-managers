package tests;

#if !bt

class TestBuilder extends BuildTester {

    public function new()
    {
        super([
            { module : "tests.TestBuilder", libs : ["mongodb"], vars : ["bt", "btgood"],    result : BSuccess },
            { module : "tests.TestBuilder", libs : ["mongodb"], vars : ["bt", "bterror1"],  result : BFailure(null, null) },
            { module : "tests.TestBuilder", libs : ["mongodb"], vars : ["bt", "bterror2"],  result : BFailure(null, null) },
            { module : "tests.TestBuilder", libs : ["mongodb"], vars : ["bt", "bterror3"],  result : BFailure(null, null) },
            { module : "tests.TestBuilder", libs : ["mongodb"], vars : ["bt", "btcur"],     result : BSuccess }
        ]);
    }

}

#else

import tests.SomeTypes;
import org.mongodb.*;

class TestBuilder {

    public static function main()
    {
        var mongo = new Mongo();
        var db = mongo.hxmomTests;
        var people = new Manager<Person>(db.people);
#if btgood
        // basics
        people.insert({ name : "John", age : 20 });
        trace(people.findOne({ name : "John"}));
        trace(Lambda.array(people.find({ name : "John"})));

        // Expected errors:
#elseif bterror1
        trace(people.findOne({ name : 1 }));
#elseif bterror2
        trace(people.findOne({ _name : "John" }));
#elseif bterror3
        people.insert({ name : "John" });
#elseif btcur
#end
    }

}

#end


