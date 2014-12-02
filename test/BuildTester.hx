import utest.Assert;

enum BuildResult {
    BSuccess;
    BFailure(code:Null<Int>, reg:Null<EReg>);
}

typedef Module = {
    var module:String;
    var vars:Array<String>;
    var result:BuildResult;
}

class BuildTester {
    var modules:Array<Module>;
    
    public function new(modules)
    {
        this.modules = modules;
    }

    public function testBuild()
    {
        for (module in modules) {
            trace(module);
            var file = module.module;

            var args = ["--interp", "-main", file, "-cp", "test", "-cp", "lib", "-lib", "utest"];
            for (v in module.vars) {
                args.push("-D");
                args.push(v);
            }

            var p = new sys.io.Process("haxe", args);
            Sys.print(p.stdout.readAll().toString());
            var m = p.stderr.readAll().toString();
            var e = p.exitCode();

            switch (module.result) {
            case BSuccess:
                Assert.equals(0, e, '$file failed to build with:\n      ${m.split("\n").join("\n      ")}');
            case BFailure(code, reg):
                Assert.notEquals(0, e, '$file should not build');
                trace('Failure message:\n$m');
                if (code != null)
                    Assert.equals(code, e);
                if (reg != null)
                    Assert.match(reg, m);
            }
        }
    }

}

