# Zig imgui template
Zig imgui template that uses opengl3 and glfw, where glfw already has zig bindings provided by [mach-glfw](https://github.com/hexops/mach-glfw). Imgui (v 1.85) is provided using [cimgui](https://github.com/cimgui/cimgui), with some modifications made to the generated code to adapt it. A better font is included, [cascadia code](https://github.com/microsoft/cascadia-code). And finally, a solarized light theme is included.

## Preview
``` zig
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
```
[preview image](https://github.com/dumheter/zig-imgui-template/blob/main/preview.png)
