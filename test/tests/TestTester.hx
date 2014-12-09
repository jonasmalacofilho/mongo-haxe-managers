package tests;

import BuildTester;

class TestTester extends BuildTester {

    public function new()
    {
        super([
            { module : "tests.TesterSuccess", result : BSuccess },
            { module : "tests.TesterFailure", result : BFailure(null, null) },
            { module : "tests.TesterFailure", result : BFailure(null, ~/int should be string/i) }
        ]);
    }

}

