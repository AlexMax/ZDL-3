const builtin = @import("builtin");
const CrossTarget = @import("std").build.CrossTarget;
const Target = @import("std").build.Target;
const Builder = @import("std").build.Builder;
const warn = @import("std").debug.warn;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("ZDL", null);

    const srcs = [_][]const u8{
        "cfg.c", "dlg.c", "sub.c", "zdl.c"
    };

    for (srcs) |src| {
        exe.addCSourceFile(src, [_][]const u8{});
    }

    // This is not built automatically, it must be generated from the .rc
    // file by hand.
    //
    // If you use llvm-rc, note that you have to run the preprocessor against
    // the rc file in a separate step.
    //
    // windres might work, but is untested.
    exe.addObjectFile("zdl.res");

    exe.linkLibC();
    exe.linkSystemLibrary("advapi32");
    exe.linkSystemLibrary("comdlg32");
    exe.linkSystemLibrary("shell32");
    exe.linkSystemLibrary("shlwapi");
    exe.linkSystemLibrary("user32");
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
