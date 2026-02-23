**NusaOS** adalah proyek sistem operasi *open-source* berbasis **Microkernel** yang dibangun dari nol menggunakan bahasa pemrograman **Zig (v0.16.0)**. NusaOS dirancang sebagai solusi *bare-metal* yang sangat ringan, cepat, dan efisien, khusus dioptimalkan untuk perangkat IoT modern yang berbasis arsitektur **RISC-V (32-bit & 64-bit)**.

Visi kami adalah menyediakan sistem operasi minimalis yang memberikan kendali penuh atas perangkat keras tanpa beban *library* yang berat, menjadikannya pilihan ideal untuk sistem kontrol industri, perangkat sensor cerdas, dan eksperimen sistem tertanam (*embedded systems*).

---

## Struktur Proyek

Arsitektur NusaOS menggunakan prinsip modularitas yang ketat untuk memudahkan pengembang dalam melakukan *porting* ke berbagai perangkat keras.

```text
nusa_os/
├── build.zig             # Pusat konfigurasi kompilasi modul
├── run.sh                # Skrip otomatis Build & Run (QEMU/Hardware)
├── src/
│   ├── linker.ld         # Peta alokasi memori sistem
│   ├── arch/             # Spesifik CPU (Assembly)
│   │   ├── boot.S        # Entry point: Inisialisasi Stack & kmain
│   │   └── trap.S        # Penangan interupsi tingkat rendah
│   ├── hal/              # Hardware Abstraction Layer (Drivers)
│   │   └── uart.zig      # Driver komunikasi serial (I/O)
│   ├── kernel/           # Logika Utama (Microkernel Core)
│   │   ├── main.zig      # Inisialisasi kernel (kmain)
│   │   └── trap.zig      # Handler interupsi tingkat tinggi
│   └── lib/              # User-space Libraries
│       └── shell.zig     # Antarmuka CLI interaktif

```

---

## Penjelasan Komponen

* **`arch/`**: Berisi kode *low-level* yang menjadi jembatan antara instruksi mesin RISC-V dan logika kernel.
* **`hal/`**: *Hardware Abstraction Layer*. Mengisolasi detail register perangkat keras agar logika kernel tetap bersih dan portabel.
* **`kernel/`**: Otak sistem yang mengelola siklus hidup OS dan penanganan *fault* via *Trap Vector*.
* **`lib/`**: Lapisan atas yang menyediakan antarmuka bagi pengguna untuk berinteraksi dengan sistem.
* **`build.zig`**: Memanfaatkan *Zig Build System* untuk kompilasi lintas platform yang presisi.

---

## Cara Kerja "Di Balik Layar"

NusaOS beroperasi melalui siklus eksekusi yang efisien:

1. **Bootstrapping**: CPU menyalakan instruksi di `boot.S`, menyiapkan *Stack Pointer* agar fungsi-fungsi Zig dapat berjalan di memori RAM.
2. **Kernel Initialization**: Kernel mengambil alih kendali di `kmain()`, mendaftarkan `trap_vector` ke CPU untuk keamanan sistem.
3. **Shell Ready**: Kendali diberikan ke `shell.run()`, di mana sistem melakukan *polling* pada port UART secara *real-time*.
4. **Interaction Loop**:
* Input dikumpulkan di `buf`.
* Tombol `Enter` memicu `execute()`, yang mencocokkan input pengguna dengan perintah yang tersedia.
5. **Fault Handling**: Sistem dilengkapi dengan *Trap Handler*. Jika terjadi kesalahan (misal: *divide by zero*), sistem akan menghentikan eksekusi dan mencetak error, menjaga agar tidak terjadi *undefined behavior* yang fatal.

---

## Penggunaan

### Persyaratan

* **Zig Compiler v0.16.0**
* **QEMU** (Emulator sistem RISC-V)

### Perintah Build & Run

NusaOS menyediakan skrip otomatis untuk mempercepat alur kerja pengembangan:

* **Jalankan Normal:**
```bash
./run.sh

```

* **Jalankan dengan Mode Debug (Log ke `log.txt`):**
```bash
./run.sh --debug

```

---

*Dibuat dengan semangat open-source untuk kemandirian teknologi IoT berbasis RISC-V.*