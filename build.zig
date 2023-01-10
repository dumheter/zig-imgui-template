const Builder = @import("std").build.Builder;
const glfw = @import("deps/mach-glfw/build.zig");
const zimgui = @import("deps/zimgui/build.zig");

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("zig-imgui-template", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    // Add glfw to our project.
    exe.addPackagePath("glfw", "deps/mach-glfw/src/main.zig");
    glfw.link(b, exe, .{}) catch unreachable;

    // Add the zig imgui bindings via zimgui.
    exe.addPackagePath("zimgui", "deps/zimgui/src/zimgui.zig");
    _ = zimgui.link(b, exe, .{});

    // Also, add the backend which will be rendering imgui.
    exe.addPackagePath("zimgui_backend", "deps/zimgui/src/backend_glfw_opengl3.zig");
    zimgui.addBackendGlfwOpenGl3(b, exe, .{});

    exe.install();
    b.default_step.dependOn(&exe.step);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run zig imgui template");
    run_step.dependOn(&run_cmd.step);

    var exe_tests = b.addTest("src/main.zig");
    exe_tests.setBuildMode(mode);
    exe_tests.linkLibCpp();

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
