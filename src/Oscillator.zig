const std = @import("std");

pub const Type = enum {
    SINE,
    SQUARE,
    TRIANGLE,
};

pub fn sineStep(sample_rate: f32, frequency: f32) f32 {
    const rate = sample_rate / frequency;
    return std.math.tau / rate;
}

pub fn sineSample(amplitude: f32, step: f32) f32 {
    return amplitude * @sin(step);
}

pub fn squareStep(sample_rate: f32, frequency: f32) f32 {
    return sineStep(sample_rate, frequency);
}

pub fn squareSample(amplitude: f32, step: f32) f32 {
    const sample = sineSample(amplitude, step);
    return if (sample > 0.0) amplitude else -1.0;
}

pub fn triangleStep(sample_rate: f32, frequency: f32) f32 {
    var step = frequency / sample_rate;
    if (step > 1.0) step -= 1.0;
    return step;
}

pub fn triangleSample(amplitude: f32, step: f32) f32 {
    return 2 * amplitude * (@abs(2 * @mod(step, 1) - 1) - 0.5);
}
