// dear imgui: Renderer Backend for modern OpenGL with shaders / programmatic pipeline
// - Desktop GL: 2.x 3.x 4.x
// - Embedded GL: ES 2.0 (WebGL 1.0), ES 3.0 (WebGL 2.0)
// This needs to be used along with a Platform Backend (e.g. GLFW, SDL, Win32, custom..)

// Implemented features:
//  [X] Renderer: User texture binding. Use 'GLuint' OpenGL texture identifier as void*/ImTextureID. Read the FAQ about ImTextureID!
//  [x] Renderer: Desktop GL only: Support for large meshes (64k+ vertices) with 16-bit indices.

// You can use unmodified imgui_impl_* files in your project. See examples/ folder for examples of using this.
// Prefer including the entire imgui/ repository into your project (either as a copy or as a submodule), and only build the backends you need.
// If you are new to Dear ImGui, read documentation from the docs/ folder + read the top of imgui.cpp.
// Read online: https://github.com/ocornut/imgui/tree/master/docs

// About GLSL version:
//  The 'glsl_version' initialization parameter should be NULL (default) or a "#version XXX" string.
//  On computer platform the GLSL version default to "#version 130". On OpenGL ES 3 platform it defaults to "#version 300 es"
//  Only override if your GL version doesn't handle this GLSL version. See GLSL version table at the top of imgui_impl_opengl3.cpp.

#ifndef IMGUI_IMPL_OPENGL3_H
#define IMGUI_IMPL_OPENGL3_H
//#pragma once
//#include "cimgui/cimgui.h"      // IMGUI_IMPL_API

#if defined(__cplusplus)
extern "C"
{
#endif

struct ImDrawData;

// Backend API
bool     ImGui_ImplOpenGL3_Init(const char* glsl_version);
void     ImGui_ImplOpenGL3_Shutdown();
void     ImGui_ImplOpenGL3_NewFrame();
void     ImGui_ImplOpenGL3_RenderDrawData(struct ImDrawData* draw_data);

// (Optional) Called by Init/NewFrame/Shutdown
bool     ImGui_ImplOpenGL3_CreateFontsTexture();
void     ImGui_ImplOpenGL3_DestroyFontsTexture();
bool     ImGui_ImplOpenGL3_CreateDeviceObjects();
void     ImGui_ImplOpenGL3_DestroyDeviceObjects();

// Specific OpenGL ES versions
//#define IMGUI_IMPL_OPENGL_ES2     // Auto-detected on Emscripten
//#define IMGUI_IMPL_OPENGL_ES3     // Auto-detected on iOS/Android

#if defined(__cplusplus)
}
#endif

// Try to detect GLES on matching platforms
#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#endif
