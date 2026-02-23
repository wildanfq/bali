#!/bin/bash

# Script: run.sh
# Gunakan path absolut agar tidak bergantung pada $PATH yang terbatas
QEMU="/usr/bin/qemu-system-riscv32"

rm -rf .zig-cache zig-out
zig build

if [ "$1" == "--debug" ]; then
    $QEMU -nographic -machine virt -bios none -kernel zig-out/bin/nusa-os.elf -d int,cpu -D log.txt
else
    $QEMU -nographic -machine virt -bios none -kernel zig-out/bin/nusa-os.elf
fi