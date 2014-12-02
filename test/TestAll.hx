import utest.Runner;
import utest.ui.Report;

class TestAll {

    static function main()
    {
        var r = new Runner();

        // test itself
        r.addCase(new compile.self.TestBuild());

        // test compile time behavior
        r.addCase(new compile.TestTyping());

        // test runtime behavior

        Report.create(r);
        r.run();
    }

}

