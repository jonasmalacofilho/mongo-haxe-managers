package compile.self;

import BuildTester;

class TestBuild extends BuildTester {

    public function new()
    {
        super([
            { module : "compile.self.TestBuildSuccess", vars : [], result : BSuccess },
            { module : "compile.self.TestBuildFailure", vars : [], result : BFailure(null, null) },
            { module : "compile.self.TestBuildFailure", vars : [], result : BFailure(null, ~/int should be string/i) }
        ]);
    }

}

