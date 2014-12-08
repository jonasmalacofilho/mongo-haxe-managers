package compile.self;

import BuildTester;

class TestTester extends BuildTester {

    public function new()
    {
        super([
            { module : "compile.self.TesterSuccess", result : BSuccess },
            { module : "compile.self.TesterFailure", result : BFailure(null, null) },
            { module : "compile.self.TesterFailure", result : BFailure(null, ~/int should be string/i) }
        ]);
    }

}

