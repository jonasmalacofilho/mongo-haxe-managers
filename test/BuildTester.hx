import StringTools.trim;
import Sys.println;
import utest.Assert;
import haxe.macro.Expr;
using haxe.macro.Context;

enum BuildResult {
    BSuccess;
    BFailure(code:Null<Int>, reg:Null<EReg>);
}

typedef Module = {
    module : String,
    ?libs : Array<String>,
    ?vars : Array<String>,
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
            println('Build testing module ${module.module}');
            if (module.vars != null && module.vars.length > 0)
                println('  with -D ${module.vars.join(",")}');

            var name = module.module + (module.vars != null ? '${module.vars}': "");

            var args = ["--interp", "-main", module.module, "-cp", "test", "-cp", "lib"];

            if (module.libs != null)
                for (lib in module.libs) {
                    args.push("-lib");
                    args.push(lib);
                }

            var vars = module.vars != null ? module.vars : [];
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
                Assert.equals(0, e, '$name failed to build with:\n      ${m.split("\n").join("\n      ")}');
            case BFailure(code, reg):
                Assert.notEquals(0, e, '$name should not build');
                println('  failed with:\n  ${trim(m).split("\n").join("\n  ")}');
                if (code != null)
                    Assert.equals(code, e);
                if (reg != null)
                    Assert.match(reg, m);
            }
        }
    }

}

