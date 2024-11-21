const std = @import("std");

const c = @cImport({
    @cInclude("wgpu.h");
});

pub fn main() !void {
    std.log.info("Testing WGPU initialization...", .{});

    const instance = c.wgpuCreateInstance(null);
    if (instance == null) {
        std.log.err("Failed to create WGPU instance", .{});
        return error.WGPUInitFailed;
    }
    defer c.wgpuInstanceRelease(instance);
    std.log.info("WGPU instance created successfully", .{});
}
