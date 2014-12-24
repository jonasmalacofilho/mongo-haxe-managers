import utest.*;
import utest.ui.Report;

class TestAll {

    static function main()
    {
        var r = new Runner();

        // test the build tester itself
        r.addCase(new tests.TestTester());

        // actual tests
        r.addCase(new tests.TestTyper());
        r.addCase(new tests.TestBuilder());

        Report.create(r);

#if sys
        var res:TestResult = null;
        r.onProgress.add(function (o) if (o.done == o.totals) res = o.result);
        r.run();
        Sys.exit(res.allOk() ? 0 : 1);
#else
        r.run();
#end
    }

}

