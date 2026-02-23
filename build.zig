const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .none,
    });
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSmall });

    const hal_mod = b.addModule("hal", .{ .root_source_file = b.path("src/hal/uart.zig") });
    const lib_mod = b.addModule("lib", .{ .root_source_file = b.path("src/lib/shell.zig") });

    lib_mod.addImport("hal", hal_mod);

    const kernel_mod = b.createModule(.{
        .root_source_file = b.path("src/kernel/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    kernel_mod.addImport("hal", hal_mod);
    kernel_mod.addImport("lib", lib_mod);

    kernel_mod.addAssemblyFile(b.path("src/arch/boot.S"));
    kernel_mod.addAssemblyFile(b.path("src/arch/trap.S"));

    const kernel = b.addExecutable(.{
        .name = "nusa-os.elf",
        .root_module = kernel_mod,
    });

    kernel.setLinkerScript(b.path("src/linker.ld"));
    b.installArtifact(kernel);
}