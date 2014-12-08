import StringTools.trim;
import Sys.println;
import utest.Assert;

enum BuildResult {
    BSuccess;
    BFailure(code:Null<Int>, reg:Null<EReg>);
}

typedef Module = {
    module : String,
    vars : Array<String>,
    result : BuildResult
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
            println('Build testing module ${module.module}' + (module.vars.length > 0 ? ' with -D ${module.vars.join(",")}' : ''));
            var file = module.module;

            var args = ["--interp", "-main", file, "-cp", "test", "-cp", "lib", "-lib", "utest"];

            var vars = module.vars;
            #if HXMOM_TYPER_TRACES vars.push("HXMOM_TYPER_TRACES"); #end
            for (v in vars) {
                args.push("-D");
                args.push(v);
            }

            var p = new sys.io.Process("haxe", args);
            Sys.print(p.stdout.readAll().toString());
            var m = p.stderr.readAll().toString();
            var e = p.exitCode();

            switch (module.result) {
            case BSuccess:
                Assert.equals(0, e, '$file${module.vars} failed to build with:\n      ${m.split("\n").join("\n      ")}');
            case BFailure(code, reg):
                Assert.notEquals(0, e, '$file${module.vars} should not build');
                println('failed with:\n  ${trim(m).split("\n").join("\n  ")}');
                if (code != null)
                    Assert.equals(code, e);
                if (reg != null)
                    Assert.match(reg, m);
            }
        }
    }

}

