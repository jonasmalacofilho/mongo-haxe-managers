import utest.Runner;
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
    }

}

