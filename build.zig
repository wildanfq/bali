const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
        .abi = .none,
    });

    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSmall });

    const drivers = b.addModule("drivers", .{ .root_source_file = b.path("src/drivers/uart.zig") });
    const lib = b.addModule("lib", .{ .root_source_file = b.path("src/lib/tui.zig") });
    const user = b.addModule("user", .{ .root_source_file = b.path("src/user/shell.zig") });

    lib.addImport("drivers", drivers);
    user.addImport("drivers", drivers);
    user.addImport("lib", lib);

    const kernel = b.addExecutable(.{
        .name = "bali.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/kernel/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    kernel.root_module.addImport("drivers", drivers);
    kernel.root_module.addImport("lib", lib);
    kernel.root_module.addImport("user", user);

    kernel.root_module.addAssemblyFile(b.path("src/arch/riscv32/boot.S"));
    kernel.root_module.addAssemblyFile(b.path("src/arch/riscv32/trap.S"));
    kernel.setLinkerScript(b.path("src/linker.ld"));

    b.installArtifact(kernel);
}
