import utest.*;
import utest.ui.Report;

class TestAll {

    static function main()
    {
        var r = new Runner();

        // test itself (the build tester)
        r.addCase(new tests.TestTester());

        // test compile time behavior
        r.addCase(new tests.TestTyper());
        r.addCase(new tests.TestBuilder());

        // test runtime behavior

        Report.create(r);
        r.run();

#if sys
        var res:TestResult = null;
        r.onProgress.add(function (o) if (o.done == o.totals) res = o.result);
        r.run();
        Sys.exit(res.allOk() ? 0 : 1);
#end
    }

}

