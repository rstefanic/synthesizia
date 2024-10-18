const std = @import("std");
const r = @cImport({
    @cInclude("raylib.h");
});

const Note = @import("Note.zig").Note;
const Notes = @import("Note.zig").Notes;

const SAMPLE_RATE = 44100;
const SAMPLE_SIZE = 16;
const CHANNELS = 1;
const MAX_SAMPLES_PER_UPDATE = 4096;

var note: Note = Notes[0];

fn AudioInputCallback(buffer: ?*anyopaque, frames: c_uint) callconv(.C) void {
    const incr = note.frequency / SAMPLE_RATE;

    var sineIdx: f32 = 0.0;
    var d: [*]c_short = @ptrCast(@alignCast(buffer));

    var i: usize = 0;
    while (i < frames) : (i += 1) {
        d[i] = @intFromFloat(32000.0 * @sin(2 * 3.14 * sineIdx));
        sineIdx += incr;
        if (sineIdx > 1.0) sineIdx -= 1.0;
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
        r.BeginDrawing();
        defer r.EndDrawing();

        note = Notes[0]; // default to the "rest note"
        var i: usize = 1; // skip the "rest note" at index 0
        while (i < Notes.len) : (i += 1) {
            if (r.IsKeyDown(Notes[i].key)) {
                note = Notes[i];
            }
        }

        r.ClearBackground(note.color);
    }
}
