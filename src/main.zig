const std = @import("std");
const c = @import("c.zig").c;
const glfw = @import("glfw");
const theme = @import("theme.zig");

pub fn main() !void {
    std.debug.print("-*- zig imgui template -*-\n", .{});

    var font: *c.ImFont = undefined;
    var run: bool = true;

    var display_size = c.ImVec2{
        .x = 1280,
        .y = 720,
    };

    // setup glfw & imgui
    var window: glfw.Window = undefined;
    var context: *c.ImGuiContext = undefined;
    var io: *c.ImGuiIO = undefined;
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

        std.debug.print("imgui version: {s}\n", .{c.igGetVersion()});
        context = c.igCreateContext(null);

        theme.setImguiTheme(&c.igGetStyle().*.Colors);

        if (!c.ImGui_ImplGlfw_InitForOpenGL(@ptrCast(*c.GLFWwindow, window.handle), true)) {
            std.debug.panic("", .{});
        }

        const glsl_version = "#version 130";
        if (!c.ImGui_ImplOpenGL3_Init(glsl_version)) {
            std.debug.panic("could not init opengl", .{});
        }

        io = c.igGetIO();
        var text_pixels: [*c]u8 = undefined;
        var text_w: i32 = undefined;
        var text_h: i32 = undefined;
        c.ImFontAtlas_GetTexDataAsRGBA32(io.Fonts, &text_pixels, &text_w, &text_h, null);
        font = c.ImFontAtlas_AddFontFromFileTTF(io.Fonts, "res/font/CascadiaMonoPL.ttf", 15.0, null, c.ImFontAtlas_GetGlyphRangesDefault(io.Fonts));
        _ = c.ImFontAtlas_Build(io.Fonts);

        io.DisplaySize = display_size;
        io.DeltaTime = 1.0 / 60.0;
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

        c.ImGui_ImplOpenGL3_NewFrame();
        c.ImGui_ImplGlfw_NewFrame();
        c.igNewFrame();
        c.igPushFont(font);

        ///////////////////////////////////////////////////////////////////////////////
        // YOUR CODE GOES HERE

        {
            _ = c.igBegin("Your code goes here", 0, 0);

            c.igText("It's this easy to draw text with imgui");

            var text_size: c.ImVec2 = undefined;
            c.igCalcTextSize(&text_size, "toggle imgui demo", null, true, 1000.0);
            if (c.igButton("toggle imgui demo", c.ImVec2{.x = text_size.x + 8, .y = text_size.y + 8})) {
                show_demo_window = !show_demo_window;
            }

            c.igEnd();
        }

        // draw imgui's demo window
        if (show_demo_window) {
            c.igShowDemoWindow(&show_demo_window);
        }

        ///////////////////////////////////////////////////////////////////////////////

        c.igPopFont();
        c.igRender();

        if (window.getFramebufferSize()) |size| {
            c.glViewport(0, 0, @intCast(c_int, size.width), @intCast(c_int, size.height));
            c.glClearColor(0.9, 0.9, 0.9, 0);
            c.glClear(c.GL_COLOR_BUFFER_BIT);
            c.ImGui_ImplOpenGL3_RenderDrawData(c.igGetDrawData());
        } else |err| {
            std.debug.panic("failed to get frame buffer size: {}", .{err});
        }

        if (window.swapBuffers()) {} else |err| {
            std.debug.panic("failed to swap buffers: {}", .{err});
        }
    }

    // cleanup
    c.igDestroyContext(context);
    window.destroy();
    glfw.terminate();
}
