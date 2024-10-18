const r = @cImport({
    @cInclude("raylib.h");
});

pub const Note = struct {
    frequency: f32,
    color: r.Color,
    key: u8,
};

pub const Notes: [13]Note = .{
    .{ .frequency = 0.0000, .color = r.BLACK, .key = 0 }, // Rest Note
    .{ .frequency = 261.63, .color = r.RED, .key = r.KEY_ONE }, // C
    .{ .frequency = 277.18, .color = r.DARKPURPLE, .key = r.KEY_TWO }, // C#
    .{ .frequency = 293.66, .color = r.YELLOW, .key = r.KEY_THREE }, // D
    .{ .frequency = 311.13, .color = r.MAROON, .key = r.KEY_FOUR }, // D#
    .{ .frequency = 329.63, .color = r.SKYBLUE, .key = r.KEY_FIVE }, // E
    .{ .frequency = 349.23, .color = r.MAGENTA, .key = r.KEY_SIX }, // F
    .{ .frequency = 369.99, .color = r.DARKBLUE, .key = r.KEY_SEVEN }, // F#
    .{ .frequency = 392.00, .color = r.ORANGE, .key = r.KEY_EIGHT }, // G
    .{ .frequency = 415.30, .color = r.PURPLE, .key = r.KEY_NINE }, // G#
    .{ .frequency = 440.00, .color = r.GREEN, .key = r.KEY_ZERO }, // A
    .{ .frequency = 440.16, .color = r.VIOLET, .key = r.KEY_MINUS }, // A#
    .{ .frequency = 493.88, .color = r.BLUE, .key = r.KEY_EQUAL }, // B
};
