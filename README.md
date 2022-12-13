# Zig imgui template
Zig imgui template that uses opengl3 and glfw, where glfw already has zig bindings provided by [mach-glfw](https://github.com/hexops/mach-glfw). Imgui (v 1.89 WIP) is provided using [zimgui](https://github.com/dumheter/zimgui), which has an incomplete set of imgui to zig bindings. A better font is included, [cascadia code](https://github.com/microsoft/cascadia-code). And finally, a solarized light theme is included.

## Preview
``` zig
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
```
![preview image](https://github.com/dumheter/zig-imgui-template/blob/main/preview.png)
