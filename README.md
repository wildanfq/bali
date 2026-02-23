**NusaOS** adalah proyek sistem operasi *open-source* berbasis **Microkernel** yang dibangun dari nol menggunakan bahasa pemrograman **Zig (v0.16.0)**. NusaOS dirancang sebagai solusi *bare-metal* yang sangat ringan, cepat, dan efisien, khusus dioptimalkan untuk perangkat IoT modern yang berbasis arsitektur **RISC-V (32-bit & 64-bit)**.

Visi kami adalah menyediakan sistem operasi minimalis yang memberikan kendali penuh atas perangkat keras tanpa beban *library* yang berat, menjadikannya pilihan ideal untuk sistem kontrol industri, perangkat sensor cerdas, dan eksperimen sistem tertanam (*embedded systems*).

---

## **Dukungan Emulator**

NusaOS dapat dijalankan dan diuji menggunakan emulator RISC-V terkemuka berikut:

* **QEMU (Quick Emulator):** Emulator *open-source* dan virtualizer yang sangat cepat, sering digunakan untuk emulasi sistem secara *full-system*.
* Situs Resmi: [https://www.qemu.org/](https://www.qemu.org/)


* **Renode:** *Framework* pengembangan sistem tertanam yang memungkinkan simulasi jaringan perangkat keras dan *debugging* yang presisi.
* Situs Resmi: [https://renode.io/](https://renode.io/)

---

## **Struktur Proyek**

Arsitektur NusaOS menggunakan prinsip modularitas yang ketat untuk memudahkan pengembang dalam melakukan *porting* ke berbagai perangkat keras.

```text
nusa_os/
├── build.zig             # Pusat konfigurasi kompilasi modul
├── run.sh                # Skrip otomatis Build & Run (QEMU/Renode)
├── nusa.resc             # Konfigurasi emulator Renode
├── tools/                # Folder dependensi emulator
├── src/
│   ├── linker.ld         # Peta alokasi memori sistem
│   ├── arch/             # Spesifik CPU (Assembly)
│   ├── hal/              # Hardware Abstraction Layer (Drivers)
│   ├── kernel/           # Logika Utama (Microkernel Core)
│   └── lib/              # User-space Libraries

```

---

## **Penggunaan**

### Persyaratan

* **Zig Compiler v0.16.0**
* **QEMU System RISC-V**
* **Renode (Portable/Installed)**

### Perintah Build & Run

NusaOS menyediakan skrip otomatis `./run.sh` untuk mempercepat alur kerja:

* **Jalankan via QEMU (Normal):**
```bash
./run.sh

```

* **Jalankan via QEMU (Debug Mode):**
```bash
./run.sh --debug

```

* **Jalankan via Renode (Emulator):**
```bash
./run.sh --renode

```

---

## **Cara Kerja "Di Balik Layar"**

1. **Bootstrapping**: CPU menjalankan instruksi di `boot.S`, menyiapkan *Stack Pointer* agar fungsi-fungsi Zig dapat berjalan di memori RAM.
2. **Kernel Initialization**: Kernel mengambil alih kendali di `kmain()`, mendaftarkan `trap_vector` ke CPU untuk keamanan sistem.
3. **Shell Ready**: Kendali diberikan ke `shell.run()`, di mana sistem melakukan *polling* pada port UART secara *real-time*.
4. **Interaction Loop**: Input dikumpulkan di `buf`, dan tombol `Enter` memicu `execute()` untuk menjalankan perintah.
5. **Fault Handling**: Sistem dilengkapi dengan *Trap Handler*. Jika terjadi kesalahan (misal: *divide by zero*), sistem akan menghentikan eksekusi dan mencetak error, menjaga agar tidak terjadi *undefined behavior*.

---

*Dibuat dengan semangat open-source untuk kemandirian teknologi IoT berbasis RISC-V.*

---