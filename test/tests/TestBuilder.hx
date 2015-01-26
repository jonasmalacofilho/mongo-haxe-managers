package tests;

#if !bt

class TestBuilder extends BuildTester {

    public function new()
    {
        super([
            { module : "tests.TestBuilder", libs : ["mongodb", "utest"], vars : ["bt", "btgood"],    result : BSuccess },
            { module : "tests.TestBuilder", libs : ["mongodb", "utest"], vars : ["bt", "bterror1"],  result : BFailure(null, null) },
            { module : "tests.TestBuilder", libs : ["mongodb", "utest"], vars : ["bt", "bterror2"],  result : BFailure(null, null) },
            { module : "tests.TestBuilder", libs : ["mongodb", "utest"], vars : ["bt", "bterror3"],  result : BFailure(null, null) },
            // { module : "tests.TestBuilder", libs : ["mongodb", "utest"], vars : ["bt", "bterror4"],  result : BFailure(null, null) },
            // { module : "tests.TestBuilder", libs : ["mongodb", "utest"], vars : ["bt", "bterror5"],  result : BFailure(null, null) },
            { module : "tests.TestBuilder", libs : ["mongodb", "utest"], vars : ["bt", "btcur"],     result : BSuccess }
        ]);
    }

}

#else

import org.mongodb.*;
import tests.SomeTypes;
import utest.*;
import utest.ui.Report;

class TestBuilder {

    public function new()
    {

    }

    public function testAll()
    {
        var mongo = new Mongo();
        var db = mongo.hxmomTests;
        var people = new Manager<Person>(db.people);

        people.drop();
        people.insert({ name : "John", age : 20 });
        people.col.insert({ name : "Bob" });  // incomplete document
        Assert.equals(2, people.find({}).toArray().length);

#if btgood
        // basics
        Assert.notEquals(null, people.findOne({ name : "John", age : 20 }));
        // Assert.equals(null, people.findOne({ name : "Bob"}));  // FAILING for now

        people.update({ name : "John" }, { name : "John", age : 21 });
        Assert.equals(21, people.findOne({ name : "John" }).age);
        people.update({ name : "Alice" }, { name : "Alice", age : 30 }, true);
        Assert.notEquals(null, people.findOne({ name : "Alice" }));
        people.update({ name : "Alice" }, { name : "Alice", age : 31 });
        Assert.equals(31, people.findOne({ name : "Alice" }).age);

        // Expected errors:
#elseif bterror1
        people.findOne({ name : 1 });
#elseif bterror2
        people.findOne({ _name : "John" });
#elseif bterror3
        people.insert({ name : "Brenda" });
#elseif bterror4
#elseif bterror5
#elseif btcur
#end
        Assert.isTrue(true);
    }

    static function main()
    {
        var runner = new Runner();

        runner.addCase(new TestBuilder());

        var result = null;
        runner.onProgress.add(function (o) if (o.done == o.totals) result = o.result);

        runner.run();
        for (a in result.assertations) {
            if (!a.match(Success(_)))
                throw a;
        }
    }

}

#end


