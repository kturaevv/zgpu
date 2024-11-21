const std = @import("std");

const c = @cImport({
    @cInclude("wgpu.h");
});

pub fn main() !void {
    std.debug.print("Testing WGPU initialization...\n", .{});

    // Create instance
    const instance = c.wgpuCreateInstance(null);
    if (instance == null) {
        std.debug.print("Failed to create WGPU instance\n", .{});
        return error.WGPUInitFailed;
    }
    defer c.wgpuInstanceRelease(instance);

    std.debug.print("WGPU instance created successfully\n", .{});
}
