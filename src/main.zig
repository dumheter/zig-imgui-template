const std = @import("std");
const glfw = @import("glfw");
const zimgui = @import("zimgui");
const zimgui_backend = @import("zimgui_backend");

pub fn main() !void {
    std.debug.print("-*- zig imgui template -*-\n", .{});

    var run: bool = true;

    const display_size = zimgui.Vec2{
        .x = 1280,
        .y = 720,
    };

    // setup glfw & imgui
    var window: glfw.Window = undefined;
    var ctx: zimgui.Context = undefined;
    var io: zimgui.Io = undefined;
    {
        try glfw.init(glfw.InitHints{});

        window = try glfw.Window.create(
            @floatToInt(u32, display_size.x),
            @floatToInt(u32, display_size.y),
            "zig imgui template",
            null,
            null,
            glfw.Window.Hints{
                .context_version_major = 3,
                .context_version_minor = 0,
        });

        try glfw.makeContextCurrent(window);
        try glfw.swapInterval(1); // vsync

        std.debug.print("imgui version: {s}\n", .{zimgui.getVersion()});
        zimgui.init();
        ctx = zimgui.getCurrentContext() orelse unreachable;

        zimgui.setImguiTheme();

        if (!zimgui_backend.Glfw.initForOpenGL(window.handle, true)) {
            std.debug.panic("Failed to init glfw for OpenGL.", .{});
        }

        const glsl_version = "#version 130";
        if (!zimgui_backend.OpenGL3.init(glsl_version)) {
            std.debug.panic("Failed to init OpenGL3.", .{});
        }

        io = ctx.getIo();
        var font_atlas = io.getFontAtlas();

        _ = font_atlas.addFontFromFileTTF("res/font/CascadiaMonoPL.ttf", 15.0);
        if (!font_atlas.build()) {
            std.debug.print("Failed to build fonts.", .{});
        }

        io.setDisplaySize(display_size);
    }

    // run loop
    var show_demo_window = false;
    while (run) {
        if (glfw.pollEvents()) {} else |err| {
            std.debug.panic("failed to poll events: {}", .{err});
        }

        // escape can exit the program
        var action: glfw.Action = window.getKey(glfw.Key.escape);
        if (action == glfw.Action.press or window.shouldClose()) {
            run = false;
        }

        zimgui_backend.OpenGL3.newFrame();
        zimgui_backend.OpenGL3.newFrame();
        zimgui.newFrame();

        ///////////////////////////////////////////////////////////////////////////////
        // YOUR CODE GOES HERE

        {
            var open: bool = true;
            _ = zimgui.begin("Your code goes here", &open, zimgui.WindowFlags{});

            zimgui.text("It's this easy to draw text with (z)imgui.", .{});

            if (zimgui.button("Toggle imgui demo window.", .{}, null)) {
                show_demo_window = !show_demo_window;
            }

            // draw imgui's demo window
            if (show_demo_window) {
                zimgui.showDemoWindow(&show_demo_window);
            }

            zimgui.end();
        }

        ///////////////////////////////////////////////////////////////////////////////

        zimgui.render();

        if (window.getFramebufferSize()) |size| {
            zimgui_backend.OpenGL3.glViewport(0, 0, size.width, size.height);
            zimgui_backend.OpenGL3.glClearColor(0.9, 0.9, 0.9, 0);
            zimgui_backend.OpenGL3.glClear(zimgui_backend.ClearMask.GL_COLOR_BUFFER_BIT);
            zimgui_backend.OpenGL3.renderDrawData(zimgui.getDrawData() orelse unreachable);
        } else |err| {
            std.debug.panic("failed to get frame buffer size: {}", .{err});
        }

        if (window.swapBuffers()) {} else |err| {
            std.debug.panic("failed to swap buffers: {}", .{err});
        }
    }

    // cleanup
    zimgui.deinit();
    window.destroy();
    glfw.terminate();
}
