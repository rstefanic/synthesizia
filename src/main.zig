const std = @import("std");
const r = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    r.SetTraceLogLevel(r.LOG_ERROR);
    r.InitWindow(1024, 768, "Synthesizia");
    defer r.CloseWindow();

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        defer r.EndDrawing();
        r.ClearBackground(r.BLACK);
    }
}
