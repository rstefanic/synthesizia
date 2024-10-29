const std = @import("std");
const r = @cImport({
    @cInclude("raylib.h");
});

const Note = @import("Note.zig").Note;
const Notes = @import("Note.zig").Notes;
const Oscillator = @import("Oscillator.zig");

// FULL_VOLUME is approx. half of 65536.0 to get
// us close to 100% volume when cast to a c_short
const FULL_VOLUME = 32000.0;
const SAMPLE_RATE = 44100;
const SAMPLE_SIZE = 16;
const CHANNELS = 1;
const MAX_SAMPLES_PER_UPDATE = 4096;

var note: Note = Notes[0];
var display_color: r.Color = r.BLACK;
var oscillator: Oscillator.Type = .SINE;

fn AudioInputCallback(buffer: ?*anyopaque, frames: c_uint) callconv(.C) void {
    var d: [*]c_short = @ptrCast(@alignCast(buffer));
    var step: f32 = 0.0;

    var i: usize = 0;
    while (i < frames) : (i += 1) {
        if (oscillator == .SINE) {
            step += Oscillator.sineStep(SAMPLE_RATE, note.frequency);
            d[i] = @intFromFloat(Oscillator.sineSample(FULL_VOLUME, step));
        } else if (oscillator == .SQUARE) {
            step += Oscillator.squareStep(SAMPLE_RATE, note.frequency);
            d[i] = @intFromFloat(Oscillator.squareSample(FULL_VOLUME, step));
        } else if (oscillator == .TRIANGLE) {
            step += Oscillator.triangleStep(SAMPLE_RATE, note.frequency);
            d[i] = @intFromFloat(Oscillator.triangleSample(FULL_VOLUME, step));
        }
    }
}

pub fn main() !void {
    // Window setup and configuration
    r.SetTraceLogLevel(r.LOG_ERROR);
    r.InitWindow(1024, 768, "Synthesizia");
    defer r.CloseWindow();

    // Audio Device Setup
    r.InitAudioDevice();
    defer r.CloseAudioDevice();

    // Audio Stream setup
    r.SetAudioStreamBufferSizeDefault(MAX_SAMPLES_PER_UPDATE);
    const stream = r.LoadAudioStream(SAMPLE_RATE, SAMPLE_SIZE, CHANNELS);
    defer r.UnloadAudioStream(stream);
    r.SetAudioStreamCallback(stream, AudioInputCallback);
    r.PlayAudioStream(stream);

    while (!r.WindowShouldClose()) {
        note = Notes[0]; // default to the "rest note"
        var i: usize = 1; // skip the "rest note" at index 0
        while (i < Notes.len) : (i += 1) {
            if (r.IsKeyDown(Notes[i].key)) {
                note = Notes[i];
            }
        }

        // Toggle Oscillator
        if (r.IsKeyPressed(r.KEY_SPACE)) {
            oscillator = switch (oscillator) {
                .SINE => .SQUARE,
                .SQUARE => .TRIANGLE,
                .TRIANGLE => .SINE,
            };
        }

        stepDisplayColor(&display_color, note.color);

        r.BeginDrawing();
        r.ClearBackground(display_color);

        const negative_color: r.Color = .{
            .r = ~display_color.r,
            .g = ~display_color.g,
            .b = ~display_color.b,
            .a = 255,
        };

        const osc_display_text = switch (oscillator) {
            .SINE => "Sine wave",
            .SQUARE => "Square wave",
            .TRIANGLE => "Triangle wave",
        };

        r.DrawText(osc_display_text, 850, 740, 24, negative_color);

        r.EndDrawing();
    }
}

fn stepDisplayColor(display: *r.Color, target: r.Color) void {
    const step = 1;

    if (display.r != target.r) {
        if (display.r > target.r) {
            display.r -= step;
        } else {
            display.r += step;
        }
    }

    if (display.g != target.g) {
        if (display.g > target.g) {
            display.g -= step;
        } else {
            display.g += step;
        }
    }

    if (display.b != target.b) {
        if (display.b > target.b) {
            display.b -= step;
        } else {
            display.b += step;
        }
    }
}
