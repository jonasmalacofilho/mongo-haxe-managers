import utest.Runner;
import utest.ui.Report;

class TestAll {

    static function main()
    {
        var r = new Runner();

        // test itself (the build tester)
        r.addCase(new compile.self.TestTester());

        // test compile time behavior
        r.addCase(new compile.TestTyping());
        r.addCase(new compile.TestBuild());

        // test runtime behavior

        Report.create(r);
        r.run();
    }

}

