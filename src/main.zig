const std = @import("std");
const glfw = @import("glfw");
const zui = @import("zimgui");
const zgl = @import("zimgui_backend").OpenGl3;
const zglfw = @import("zimgui_backend").Glfw;

pub fn main() !void {
    std.debug.print("-*- zig imgui template -*-\n", .{});

    const display_size = zui.Vec2{
        .x = 1280,
        .y = 720,
    };

    ///////////////////////////////////////////////////////////////////////////////
    // setup glfw & imgui
    var window: glfw.Window = undefined;
    var ctx: zui.Context = undefined;
    var io: zui.Io = undefined;
    {
        try glfw.init(glfw.InitHints{});

        glfw.setErrorCallback(glfwErrorCallback);

        window = try glfw.Window.create(
            @floatToInt(u32, display_size.x),
            @floatToInt(u32, display_size.y),
            "zig imgui template",
            null,
            null,
            glfw.Window.Hints{
                .context_version_major = 4,
                .context_version_minor = 5,
                .opengl_profile = .opengl_core_profile,
        });

        try glfw.makeContextCurrent(window);
        try glfw.swapInterval(1); // vsync

        if (zgl.gladLoadGLLoader(glfw.getProcAddress) == 0) {
            std.debug.panic("Could not pass glad the loader function.\n", .{});
        }

        std.debug.print("imgui version: {s}\n", .{zui.getVersion()});
        zui.init();
        ctx = zui.getCurrentContext() orelse unreachable;

        zui.setImguiTheme();

        if (!zglfw.initForOpenGL(window.handle, true)) {
            std.debug.panic("Failed to init glfw for OpenGL.", .{});
        }

        const glsl_version = "#version 450";
        if (!zgl.init(glsl_version)) {
            std.debug.panic("Failed to init OpenGL3.", .{});
        }

        io = ctx.getIo();
        var font_atlas = io.getFontAtlas();

        _ = font_atlas.addFontFromFileTTF("res/font/CascadiaMonoPL.ttf", 15.0);
        if (!font_atlas.build()) {
            std.debug.print("Failed to build fonts.", .{});
        }

        io.setDisplaySize(display_size);

        zgl.enable(zgl.DEBUG_OUTPUT) catch {};
        var not_user_param: usize = undefined;
        zgl.debugMessageCallback(onOpenGl3DebugMessage, @ptrCast(*const anyopaque, &not_user_param));
    }

    ///////////////////////////////////////////////////////////////////////////////
    // run loop
    var run: bool = true;
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

        zgl.newFrame();
        zui.newFrame();

        ///////////////////////////////////////////////////////////////////////////////
        // YOUR CODE GOES HERE

        {
            var open: bool = true;
            _ = zui.begin("Your code goes here", &open, zui.WindowFlags{});

            zui.text("It's this easy to draw text with (z)imgui.", .{});

            if (zui.button("Toggle imgui demo window.", .{}, null)) {
                show_demo_window = !show_demo_window;
            }

            // draw imgui's demo window
            if (show_demo_window) {
                zui.showDemoWindow(&show_demo_window);
            }

            zui.end();
        }

        ///////////////////////////////////////////////////////////////////////////////

        zui.render();

        if (window.getFramebufferSize()) |size| {
            try zgl.viewport(0, 0, @intCast(i32, size.width), @intCast(i32, size.height));
            zgl.clearColor(0.9, 0.9, 0.9, 0);
            try zgl.clear(zgl.COLOR_BUFFER_BIT);
            zgl.renderDrawData(zui.getDrawData() orelse unreachable);
        } else |err| {
            std.debug.panic("failed to get frame buffer size: {}", .{err});
        }

        if (window.swapBuffers()) {} else |err| {
            std.debug.panic("failed to swap buffers: {}", .{err});
        }
    }

    // cleanup
    zui.deinit();
    window.destroy();
    glfw.terminate();
}

///////////////////////////////////////////////////////////////////////////////
// See debug messages from glfw and opengl

fn glfwErrorCallback(error_code: glfw.Error, msg: [:0]const u8) void {
    std.debug.print("glfw error {}: {s}\n", .{error_code, msg});
}

fn onOpenGl3DebugMessage(source: zgl.ValueType, type_: zgl.ValueType, id: u32, severity: zgl.ValueType, length: i32, message: [*c]const u8, user_param: *const anyopaque) void {
    _ = user_param;
    var msg = message[0..@intCast(usize, length)];
    std.debug.print("OpenGL3: {{id: {}, severity: {}, message: {s}, source: {}, type: {}}}\n", .{id, severity, msg, source, type_});
}
