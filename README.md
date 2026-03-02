**BALI** adalah proyek sistem operasi eksperimental berbasis **Microkernel** yang dibangun dari nol (*from scratch*) menggunakan bahasa pemrograman **Zig (v0.16.0)**. Proyek ini dirancang khusus sebagai materi penelitian dan pendidikan bagi pengembang yang ingin memahami mekanisme internal sistem operasi di atas arsitektur **RISC-V (RV32/RV64)** tanpa kompleksitas *legacy* dari sistem operasi besar.

---

## **Tujuan Penelitian & Pendidikan**

NusaOS berfokus pada visualisasi konsep-konsep inti sistem operasi:

1. **Bare-Metal Execution**: Memahami transisi dari *Assembly boot code* ke *High-level language runtime*.
2. **Memory Mapping**: Demonstrasi penggunaan *Linker Script* dalam mengatur tata letak kernel di memori fisik.
3. **Interrupt & Exception Handling**: Implementasi *Trap Vector* untuk menangani instruksi ilegal atau interupsi eksternal.
4. **Hardware Abstraction Layer (HAL)**: Studi kasus komunikasi serial melalui UART (Universal Asynchronous Receiver-Transmitter).
5. **Efficiency over Complexity**: Menunjukkan bagaimana OS fungsional dapat dibangun dengan *binary footprint* yang sangat kecil (<10 KB).

---

## **Arsitektur Sistem**

NusaOS mengadopsi struktur modular untuk memisahkan logika perangkat keras dengan logika aplikasi:

```text
src/
├── arch/riscv/
│   ├── boot.S       # Entry point: Inisialisasi stack & registrasi trap
│   └── trap.S       # Low-level trap handler (konteks save/restore)
├── drivers/
│   └── uart.zig     # Driver komunikasi serial (polling/MMIO)
├── lib/
│   └── tui.zig      # Library visual: ANSI escape codes & pembersihan layar
├── kernel/
│   ├── main.zig     # Kernel entry (kmain): Inisialisasi sistem & delay loop
│   └── panic.zig    # Penanganan kesalahan fatal (Kernel Panic)
└── user/
    ├── shell.zig    # Command Line Interface interaktif
    ├── editor.zig   # Implementasi editor teks berbasis buffer
    └── viewer.zig   # Visualisasi algoritma (Digital Rain/Starfield)

```

---

## **Alur Eksekusi (Boot Sequence)**

Untuk bahan riset, berikut adalah urutan operasi saat daya diberikan ke CPU:

1. **Reset Vector**: CPU memulai eksekusi pada alamat tetap (biasanya `0x80000000`).
2. **Assembly Bootstrap (`boot.S`)**:
* Menonaktifkan interupsi global.
* Menyiapkan *Stack Pointer* (`sp`) untuk setiap *hart* (CPU core).
* Mendaftarkan alamat fungsi `trap_handler` ke register sistem RISC-V (`mtvec`).
* Melompat ke fungsi `kmain` di Zig.


3. **Kernel Initialization (`main.zig`)**:
* Inisialisasi driver UART untuk *output* diagnostik.
* Verifikasi integritas sistem melalui pesan *splash screen*.


4. **Handover**: Kernel menyerahkan kontrol penuh ke `shell.run()` sebagai *user-interface* utama.

---

## **Fitur Penelitian yang Tersedia**

| Fitur | Deskripsi Teknis | File Terkait |
| --- | --- | --- |
| **Trap Handling** | Menangkap instruksi ilegal & mencetak status register. | `trap.S`, `main.zig` |
| **MMIO Driver** | Akses langsung ke register UART pada alamat `0x10000000`. | `drivers/uart.zig` |
| **TUI Engine** | Manipulasi terminal menggunakan *VT100 Escape Sequences*. | `lib/tui.zig` |
| **PRNG Algorithm** | Implementasi Xorshift32 untuk simulasi acak tanpa library standar. | `user/viewer.zig` |
| **Power Mgmt** | Implementasi instruksi `wfi` (Wait For Interrupt) untuk efisiensi daya. | `drivers/uart.zig` |

---

## **Ekosistem Pengembangan**

### **Alat Bantu (Toolchain)**

* **Compiler**: Zig 0.16.0 (Target: `riscv32-freestanding-none`).
* **Linker**: GNU Linker via Zig (Script: `src/linker.ld`).
* **Simulator**:
* **Renode**: Digunakan untuk simulasi periferal yang presisi (seperti sensor).
* **QEMU**: Digunakan untuk pengujian kecepatan instruksi CPU.



### **Cara Menjalankan untuk Eksperimen**

Gunakan skrip kontrol untuk memulai sesi riset:

```bash
./run.sh --renode   # Rekomendasi: Gunakan ini untuk melihat log periferal mendalam

```

---