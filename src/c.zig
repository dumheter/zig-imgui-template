pub const c = @cImport({
    @cDefine("CIMGUI_DEFINE_ENUMS_AND_STRUCTS", "1");
    @cInclude("cimgui/cimgui.h");
    @cUndef("CIMGUI_DEFINE_ENUMS_AND_STRUCTS");
    @cInclude("cimgui/imgui_impl_glfw.h");
    @cInclude("cimgui/imgui_impl_opengl3.h");
    @cInclude("cimgui/imgui_impl_opengl3_loader.h");
});
