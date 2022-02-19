const Builder = @import("std").build.Builder;
const glfw = @import("deps/mach-glfw/build.zig");

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("dedit", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    exe.addPackagePath("glfw", "deps/mach-glfw/src/main.zig");
    glfw.link(b, exe, .{});

    exe.addCSourceFiles(&[_][]const u8 {
        "deps/imgui/imgui.cpp",
        "deps/imgui/imgui_draw.cpp",
        "deps/imgui/imgui_tables.cpp",
        "deps/imgui/imgui_widgets.cpp",
        "deps/imgui/imgui_demo.cpp",
        "deps/imgui/cimgui/imgui_impl_glfw.cpp",
        "deps/imgui/cimgui/imgui_impl_opengl3.cpp",
        "deps/imgui/cimgui/cimgui.cpp",
        }, &[_][]const u8 {});
    exe.linkLibCpp();
    exe.addIncludeDir("deps/imgui");

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
