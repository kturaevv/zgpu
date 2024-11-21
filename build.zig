const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_wgpu_native_from_source = b.addSystemCommand(&.{ "make", "lib-native-release" });
    build_wgpu_native_from_source.setCwd(b.path("wgpu-native"));

    const exe = b.addExecutable(.{
        .name = "zgpu",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibC();
    exe.linkSystemLibrary("m"); // math library
    exe.linkSystemLibrary("dl"); // dynamic linking library
    exe.linkSystemLibrary("wgpu_native"); // .a files go with underscore
    exe.addIncludePath(b.path("wgpu-native/ffi"));
    exe.addIncludePath(b.path("wgpu-native/ffi/webgpu-headers"));
    exe.addLibraryPath(b.path("wgpu-native/target/release"));
    exe.step.dependOn(&build_wgpu_native_from_source.step);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe); // Evalutaes after dependency is established
    run_cmd.step.dependOn(b.getInstallStep()); // here

    // Exec cmd. line args, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
