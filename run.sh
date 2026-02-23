#!/bin/bash
QEMU="/usr/bin/qemu-system-riscv32"
RENODE="./tools/renode_1.16.1-dotnet_portable/renode"
RESC_FILE="nusa.resc"

rm -rf .zig-cache zig-out
zig build

# Pilihan Emulator
case "$1" in
    --debug)
        echo "Menjalankan QEMU Debug..."
        $QEMU -nographic -machine virt -bios none -kernel zig-out/bin/nusa-os.elf -d int,cpu -D log.txt
        ;;
    --renode)
        echo "Menjalankan Renode..."
        $RENODE $RESC_FILE
        ;;
    *)
        echo "Menjalankan QEMU Normal..."
        $QEMU -nographic -machine virt -bios none -kernel zig-out/bin/nusa-os.elf
        ;;
esac