const Builder = @import("std").build.Builder;
const glfw = @import("mach-glfw/build.zig");

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("zig-imgui-template", "src/main.zig");
    const target = b.standardTargetOptions(.{});
    exe.setTarget(target);
    exe.setBuildMode(b.standardReleaseOptions());

    exe.addPackagePath("glfw", "mach-glfw/src/main.zig");
    glfw.link(b, exe, .{});

    exe.addCSourceFiles(&[_][]const u8 {
        "imgui/imgui.cpp",
        "imgui/imgui_draw.cpp",
        "imgui/imgui_tables.cpp",
        "imgui/imgui_widgets.cpp",
        "imgui/imgui_demo.cpp",
        "imgui/cimgui/imgui_impl_glfw.cpp",
        "imgui/cimgui/imgui_impl_opengl3.cpp",
        "imgui/cimgui/cimgui.cpp",
        }, &[_][]const u8 {});
    exe.linkLibCpp();
    exe.addIncludeDir("imgui");

    exe.install();
    b.default_step.dependOn(&exe.step);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const main_step = b.step("main", "run");
    main_step.dependOn(&run_cmd.step);
}
