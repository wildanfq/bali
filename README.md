
# Nusa OS

NusaOS adalah proyek sistem operasi berbasis **Microkernel** yang dibangun dari nol menggunakan bahasa pemrograman **Zig (v0.16.0)**. Proyek ini dirancang khusus untuk perangkat IoT dengan arsitektur **RISC-V (32-bit & 64-bit)**.

Tujuan utama NusaOS adalah memberikan pondasi *bare-metal* yang ringan, modular, dan efisien untuk perangkat cerdas masa depan.

---

## Struktur Proyek

```text
nusa_os/
├── build.zig             # Konfigurasi kompilasi (Pusat modul)
├── run.sh                # Skrip otomatis Build & Run (QEMU)
├── src/
│   ├── linker.ld         # Peta memori sistem
│   ├── arch/             # Kode spesifik CPU (Assembly)
│   │   ├── boot.S        # Entry point: Menyiapkan Stack & kmain
│   │   └── trap.S        # Penangan interupsi tingkat rendah
│   ├── hal/              # Hardware Abstraction Layer
│   │   └── uart.zig      # Driver UART untuk komunikasi teks
│   ├── kernel/           # Logika Utama
│   │   ├── main.zig      # Inisialisasi kernel (kmain)
│   │   └── trap.zig      # Handler interupsi tingkat tinggi
│   └── lib/              # Pustaka User-space
│       └── shell.zig     # Shell interaktif untuk pengguna

```

---

## Penjelasan

1. **`boot.S`**: Menjadi saksi pertama saat CPU menyala. Ia mengatur `Stack Pointer` agar fungsi-fungsi Zig bisa bekerja, lalu melakukan lompatan ke `kmain`.
2. **`hal/uart.zig`**: Bertindak sebagai penerjemah. Kernel tidak perlu tahu detail register hardware `0x10000000`; ia cukup memanggil `uart.write()`.
3. **`kernel/main.zig`**: Otak sistem. Ia menyiapkan *Trap Vector* agar jika terjadi error, sistem tidak mati total, melainkan melompat ke `trap_handler`.
4. **`lib/shell.zig`**: Antarmuka pengguna. Menggunakan metode *polling* untuk menangkap input keyboard dan mengeksekusi perintah.
5. **`build.zig`**: Menyatukan semua file assembly dan kode Zig menjadi satu *file executable* (`.elf`) yang siap dijalankan oleh QEMU.

---

## Cara Kerja "Di Balik Layar"

Saat Anda menjalankan `./run.sh`, berikut adalah langkah-langkah yang terjadi di dalam sistem:

1. **Power On**: CPU RISC-V mulai mengeksekusi instruksi di `boot.S`. Stack diatur agar program memiliki memori untuk bekerja.
2. **Kernel Kick-off**: Eksekusi berpindah ke `kmain()` di `main.zig`. Di sini, kernel mendaftarkan `trap_vector` ke register `mtvec` CPU.
3. **Shell Ready**: Kernel menyerahkan kendali ke `shell.run()`. Sistem menunggu input di buffer `buf`.
4. **Interaction Loop**:
* Jika pengguna mengetik sesuatu, `uart.readByte()` mengambilnya dari register UART.
* Jika tombol `Enter` ditekan, fungsi `execute()` memeriksa teks di buffer.
* Jika perintah sesuai (misal: "info"), sistem mengirimkan teks balik ke terminal via `uart.write()`.


5. **Fault Handling**: Jika terjadi instruksi ilegal, CPU otomatis melakukan lompatan ke `trap_vector` dan menjalankan `trap_handler` untuk mencetak pesan error.

---

## Penggunaan

### Persyaratan

* Zig Compiler v0.16.0
* QEMU (untuk RISC-V)

### Perintah Build & Run

Gunakan skrip otomatis yang tersedia di root direktori:

* **Jalankan Normal:**
```bash
./run.sh

```

* **Jalankan dengan Debugging (Log ke `log.txt`):**
```bash
./run.sh --debug

```

---

## 📈 Status Pengembangan

* [x] Bootstrapping (Assembly)
* [x] Driver UART (HAL)
* [x] Trap Vector & Handler
* [x] Shell Interaktif
* [ ] Memory Management (Allocator)
* [ ] Multitasking Scheduler

---

*Dibuat untuk masa depan IoT berbasis RISC-V.*