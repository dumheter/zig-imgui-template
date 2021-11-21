const std = @import("std");
const glfw = @import("glfw");
const c = @cImport({
    @cDefine("CIMGUI_DEFINE_ENUMS_AND_STRUCTS", "1");
    @cDefine("IMGUI_IMPL_API", "extern \"C\" __declspec(dllexport)");
    @cInclude("cimgui/cimgui.h");
    @cUndef("CIMGUI_DEFINE_ENUMS_AND_STRUCTS");
    @cInclude("cimgui/imgui_impl_glfw.h");
    @cInclude("cimgui/imgui_impl_opengl3.h");
    @cInclude("cimgui/imgui_impl_opengl3_loader.h");
});

pub fn main() !void {
    try glfw.init();
    defer glfw.terminate();

    const stdout = std.io.getStdOut().writer();
    try stdout.print("-*- zig-imgui-template -*-\n", .{});

    const glsl_version = "#version 130";
    try glfw.Window.hint(glfw.Window.Hint.context_version_major, 3);
    try glfw.Window.hint(glfw.Window.Hint.context_version_minor, 0);
    const window = try glfw.Window.create(1280, 720, "-*- zig-imgui-template -*-", null, null);
    defer window.destroy();

    try glfw.makeContextCurrent(window);
    try glfw.swapInterval(1); // vsync

    try stdout.print("imgui version: {s}\n", .{c.igGetVersion()});
    var igContext = c.igCreateContext(null);
    defer c.igDestroyContext(igContext);

    var style = c.igGetStyle();
    var cl: *[c.ImGuiCol_COUNT]c.ImVec4 = &style.*.Colors;

    // -*- Solarized Light/Dark -*-
    // http://www.zovirl.com/2011/07/22/solarized_cheat_sheet/
    const base03  = c.ImVec4{.x=0.00,.y=0.17,.z=0.21,.w=1.00};
    const base02  = c.ImVec4{.x=0.03,.y=0.21,.z=0.26,.w=1.00};
    const base01  = c.ImVec4{.x=0.35,.y=0.43,.z=0.46,.w=1.00};
    const base00  = c.ImVec4{.x=0.40,.y=0.48,.z=0.51,.w=1.00};
    const base0   = c.ImVec4{.x=0.51,.y=0.58,.z=0.59,.w=1.00};
    const base1   = c.ImVec4{.x=0.58,.y=0.63,.z=0.63,.w=1.00};
    const base2   = c.ImVec4{.x=0.93,.y=0.91,.z=0.84,.w=1.00};
    const base3   = c.ImVec4{.x=0.99,.y=0.96,.z=0.89,.w=1.00};
    const yellow  = c.ImVec4{.x=0.71,.y=0.54,.z=0.00,.w=1.00};
    const orange  = c.ImVec4{.x=0.80,.y=0.29,.z=0.09,.w=1.00};
    const red     = c.ImVec4{.x=0.86,.y=0.20,.z=0.18,.w=1.00};
    const magenta = c.ImVec4{.x=0.83,.y=0.21,.z=0.51,.w=1.00};
    const violet  = c.ImVec4{.x=0.42,.y=0.44,.z=0.77,.w=1.00};
    const blue    = c.ImVec4{.x=0.15,.y=0.55,.z=0.82,.w=1.00};
    const cyan    = c.ImVec4{.x=0.16,.y=0.63,.z=0.60,.w=1.00};
    const green   = c.ImVec4{.x=0.52,.y=0.60,.z=0.00,.w=1.00};
    _ = base03;
    _ = base02;
    _ = base01;
    _ = base0;
    _ = base1;
    _ = yellow;
    _ = orange;
    _ = red;
    _ = magenta;
    _ = violet;
    _ = blue;
    _ = cyan;
    _ = green;
    // light:
    //  base 01 - emphasized content
    //  base 00 - body text / primary content
    //  base 1  - comments / secondary content
    //  base 2  - background highlights
    //  base 3  - background
    cl[c.ImGuiCol_Text]                 = base00;
    cl[c.ImGuiCol_TextDisabled]         = base1;
    cl[c.ImGuiCol_WindowBg]             = base3;
    cl[c.ImGuiCol_ChildBg]              = base3;
    cl[c.ImGuiCol_PopupBg]              = base3;
    cl[c.ImGuiCol_Border]               = base2;
    cl[c.ImGuiCol_BorderShadow]         = c.ImVec4{.x=0.00,.y=0.00,.z=0.00,.w=0.00};
    cl[c.ImGuiCol_FrameBg]              = base3;
    cl[c.ImGuiCol_FrameBgHovered]       = base3;
    cl[c.ImGuiCol_FrameBgActive]        = base3;
    cl[c.ImGuiCol_TitleBg]              = base2;
    cl[c.ImGuiCol_TitleBgActive]        = base2;
    cl[c.ImGuiCol_TitleBgCollapsed]     = base3;
    cl[c.ImGuiCol_MenuBarBg]            = base2;
    cl[c.ImGuiCol_ScrollbarBg]          = c.ImVec4{.x=0.98,.y=0.98,.z=0.98,.w=0.53};
    cl[c.ImGuiCol_ScrollbarGrab]        = c.ImVec4{.x=0.69,.y=0.69,.z=0.69,.w=0.80};
    cl[c.ImGuiCol_ScrollbarGrabHovered] = c.ImVec4{.x=0.49,.y=0.49,.z=0.49,.w=0.80};
    cl[c.ImGuiCol_ScrollbarGrabActive]  = c.ImVec4{.x=0.49,.y=0.49,.z=0.49,.w=1.00};
    cl[c.ImGuiCol_CheckMark]            = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=1.00};
    cl[c.ImGuiCol_SliderGrab]           = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.78};
    cl[c.ImGuiCol_SliderGrabActive]     = c.ImVec4{.x=0.46,.y=0.54,.z=0.80,.w=0.60};
    cl[c.ImGuiCol_Button]               = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.40};
    cl[c.ImGuiCol_ButtonHovered]        = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=1.00};
    cl[c.ImGuiCol_ButtonActive]         = c.ImVec4{.x=0.06,.y=0.53,.z=0.98,.w=1.00};
    cl[c.ImGuiCol_Header]               = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.31};
    cl[c.ImGuiCol_HeaderHovered]        = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.80};
    cl[c.ImGuiCol_HeaderActive]         = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=1.00};
    cl[c.ImGuiCol_Separator]            = c.ImVec4{.x=0.39,.y=0.39,.z=0.39,.w=0.62};
    cl[c.ImGuiCol_SeparatorHovered]     = c.ImVec4{.x=0.14,.y=0.44,.z=0.80,.w=0.78};
    cl[c.ImGuiCol_SeparatorActive]      = c.ImVec4{.x=0.14,.y=0.44,.z=0.80,.w=1.00};
    cl[c.ImGuiCol_ResizeGrip]           = c.ImVec4{.x=0.35,.y=0.35,.z=0.35,.w=0.17};
    cl[c.ImGuiCol_ResizeGripHovered]    = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.67};
    cl[c.ImGuiCol_ResizeGripActive]     = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.95};
    cl[c.ImGuiCol_Tab]                  = c.ImVec4{.x=0.76,.y=0.80,.z=0.84,.w=0.93};
    cl[c.ImGuiCol_TabHovered]           = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.80};
    cl[c.ImGuiCol_TabActive]            = c.ImVec4{.x=0.60,.y=0.73,.z=0.88,.w=1.00};
    cl[c.ImGuiCol_TabUnfocused]         = c.ImVec4{.x=0.92,.y=0.93,.z=0.94,.w=0.99};
    cl[c.ImGuiCol_TabUnfocusedActive]   = c.ImVec4{.x=0.74,.y=0.82,.z=0.91,.w=1.00};
    cl[c.ImGuiCol_PlotLines]            = c.ImVec4{.x=0.39,.y=0.39,.z=0.39,.w=1.00};
    cl[c.ImGuiCol_PlotLinesHovered]     = c.ImVec4{.x=1.00,.y=0.43,.z=0.35,.w=1.00};
    cl[c.ImGuiCol_PlotHistogram]        = c.ImVec4{.x=0.90,.y=0.70,.z=0.00,.w=1.00};
    cl[c.ImGuiCol_PlotHistogramHovered] = c.ImVec4{.x=1.00,.y=0.45,.z=0.00,.w=1.00};
    cl[c.ImGuiCol_TableHeaderBg]        = c.ImVec4{.x=0.78,.y=0.87,.z=0.98,.w=1.00};
    cl[c.ImGuiCol_TableBorderStrong]    = c.ImVec4{.x=0.57,.y=0.57,.z=0.64,.w=1.00};
    cl[c.ImGuiCol_TableBorderLight]     = c.ImVec4{.x=0.68,.y=0.68,.z=0.74,.w=1.00};
    cl[c.ImGuiCol_TableRowBg]           = c.ImVec4{.x=0.00,.y=0.00,.z=0.00,.w=0.00};
    cl[c.ImGuiCol_TableRowBgAlt]        = c.ImVec4{.x=0.30,.y=0.30,.z=0.30,.w=0.09};
    cl[c.ImGuiCol_TextSelectedBg]       = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.35};
    cl[c.ImGuiCol_DragDropTarget]       = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.95};
    cl[c.ImGuiCol_NavHighlight]         = c.ImVec4{.x=0.26,.y=0.59,.z=0.98,.w=0.80};
    cl[c.ImGuiCol_NavWindowingHighlight]= c.ImVec4{.x=0.70,.y=0.70,.z=0.70,.w=0.70};
    cl[c.ImGuiCol_NavWindowingDimBg]    = c.ImVec4{.x=0.20,.y=0.20,.z=0.20,.w=0.20};
    cl[c.ImGuiCol_ModalWindowDimBg]     = c.ImVec4{.x=0.20,.y=0.20,.z=0.20,.w=0.35};

    var io: *c.ImGuiIO = c.igGetIO();
    var text_pixels: [*c]u8 = undefined;
    var text_w: i32 = undefined;
    var text_h: i32 = undefined;
    c.ImFontAtlas_GetTexDataAsRGBA32(io.Fonts, &text_pixels, &text_w, &text_h, null);

    _ = c.ImGui_ImplGlfw_InitForOpenGL(@ptrCast(*c.GLFWwindow, window.handle), true);
    _ = c.ImGui_ImplOpenGL3_Init(glsl_version);

    var font = c.ImFontAtlas_AddFontFromFileTTF(io.Fonts, "res/font/CascadiaMonoPL.ttf", 15.0, null, c.ImFontAtlas_GetGlyphRangesDefault(io.Fonts));
    _ = c.ImFontAtlas_Build(io.Fonts);

    var display_size = c.ImVec2{
        .x = 1280,
        .y = 720,
    };
    io.DisplaySize = display_size;
    io.DeltaTime = 1.0 / 60.0;

    var show_demo_window = true;

    var run = true;
    while (!window.shouldClose() and run) {
        try glfw.pollEvents();

        var optional_action: ?glfw.Action = window.getKey(glfw.Key.escape) catch null;
        if (optional_action) |action| {
            if (action == glfw.Action.press) {
                run = false;
            }
        }

        c.ImGui_ImplOpenGL3_NewFrame();
        c.ImGui_ImplGlfw_NewFrame();
        c.igNewFrame();

        c.igPushFont(font);

        c.igShowDemoWindow(&show_demo_window);

        {
            _ = c.igBegin("colors", null, 0);

            const size = c.ImVec2{.x=50, .y=24};

            c.igPushStyleColor_Vec4(c.ImGuiCol_ButtonHovered, base3);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base03);
            _ = c.igButton("base03", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base02);
            _ = c.igButton("base02", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base01);
            _ = c.igButton("base01", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base00);
            _ = c.igButton("base00", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base0);
            _ = c.igButton("base0", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base1);
            _ = c.igButton("base1", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base2);
            _ = c.igButton("base2", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, base3);
            _ = c.igButton("base3", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, yellow);
            _ = c.igButton("yellow", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, orange);
            _ = c.igButton("orange", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, red);
            _ = c.igButton("red", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, magenta);
            _ = c.igButton("magenta", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, violet);
            _ = c.igButton("violet", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, blue);
            _ = c.igButton("blue", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, cyan);
            _ = c.igButton("cyan", size);
            c.igPopStyleColor(1);

            c.igPushStyleColor_Vec4(c.ImGuiCol_Button, green);
            _ = c.igButton("green", size);
            c.igPopStyleColor(1);

            c.igPopStyleColor(1);

            c.igEnd();
        }

        c.igPopFont();

        c.igRender();

        const size = try window.getFramebufferSize();
        c.glViewport(0, 0, @intCast(c_int, size.width), @intCast(c_int, size.height));
        c.glClearColor(0.9, 0.9, 0.9, 0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);
        c.ImGui_ImplOpenGL3_RenderDrawData(c.igGetDrawData());

        try window.swapBuffers();
    }
}
