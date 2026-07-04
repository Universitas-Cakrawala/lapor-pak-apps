# 📢 Lapor Pak! - Aplikasi Pelaporan Warga

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-State_Management-blue?style=for-the-badge)

**Lapor Pak** adalah aplikasi mobile berbasis Android yang memudahkan warga untuk melaporkan kerusakan fasilitas umum (terutama infrastruktur jalan) secara langsung kepada pihak berwenang. Dibangun dengan antarmuka yang modern, responsif, dan mudah digunakan.

Aplikasi ini merupakan bagian *front-end* dari ekosistem "Lapor Pak", yang terintegrasi penuh dengan sistem *backend* berbasis NestJS, PostgreSQL, dan penyimpanan media MinIO.

## ✨ Fitur Utama

*   **Autentikasi & Otorisasi:** Sistem Login dan Registrasi berbasis *Role* (Warga & Admin).
*   **Pelaporan Cepat:** Buat laporan kerusakan jalan beserta lampiran bukti foto (maks 5) dan video kejadian.
*   **Geolokasi Interaktif:** Penentuan titik lokasi otomatis dengan visualisasi peta interaktif (`flutter_map`).
*   **Pelacakan Status:** Warga dapat memantau riwayat linimasa status laporannya (Menunggu, Diproses, Selesai) secara *real-time*.
*   **Dashboard Admin:** Admin memiliki akses ke dasbor khusus untuk melihat metrik statistik, grafik laporan mingguan, serta mengubah status laporan.
*   **Desain Modern:** Mengutamakan pengalaman pengguna yang *fluid* dengan komponen Material 3 yang disesuaikan.

## 🛠️ Teknologi yang Digunakan

Aplikasi ini mengadopsi standar industri modern untuk pengembangan Flutter:

*   **Framework:** Flutter (Dioptimasi untuk Android)
*   **State Management:** `flutter_bloc` (Cubit Pattern untuk pemisahan *logic* & UI)
*   **Routing:** `go_router` (Navigasi deklaratif)
*   **Networking:** `dio` (Manajemen HTTP API Request dengan Interceptor Token)
*   **Pemetaan:** `flutter_map` dengan *tiles* OpenStreetMap
*   **Media & Penyimpanan:** `image_picker`, `flutter_image_compress`, `video_player`, dan `flutter_secure_storage`

## 🚀 Cara Menjalankan (Getting Started)

### Prasyarat
1. Flutter SDK versi terbaru (disarankan >= 3.x).
2. Android Studio atau VS Code dengan ekstensi Flutter terpasang.
3. *Backend* "Lapor Pak" (NestJS) yang sudah menyala dan dapat diakses melalui jaringan lokal.

### Langkah Instalasi
1. *Clone* repositori ini ke komputer Anda:
   ```bash
   git clone https://github.com/Universitas-Cakrawala/lapor-pak-apps.git
   ```
2. Pindah ke dalam direktori proyek:
   ```bash
   cd lapor-pak-apps
   ```
3. Unduh semua dependensi paket Flutter:
   ```bash
   flutter pub get
   ```
4. Sesuaikan variabel *environment* dan Base URL API Anda di dalam file `.env` (salin dari `.env.example`).
   > **Catatan:** Base URL *default* untuk mengakses *localhost* di Android Emulator adalah `http://10.0.2.2:3000/api`.
5. Jalankan aplikasi di emulator atau perangkat nyata Anda:
   ```bash
   flutter run
   ```

## 📂 Struktur Direktori Utama

Proyek ini dikembangkan dengan arsitektur **Feature-First** untuk kemudahan skalabilitas:

```text
lib/
├── core/         # Konfigurasi global aplikasi, Tema (Colors & TextStyles), dan Dependency Injection (GetIt)
├── features/     # Modul-modul bisnis aplikasi yang saling terisolasi
│   ├── auth/     # - Autentikasi (Login & Register)
│   ├── media/    # - Manajemen unggahan foto dan video
│   ├── reports/  # - Dasbor Admin, Riwayat Laporan, Detail, Form Buat Laporan
│   └── users/    # - Profil Pengguna dan Pengaturan
├── shared/       # Widget umum, Data Models, dan fungsi Utils yang dipakai lintas fitur
└── main.dart     # Entry point aplikasi
```

Setiap fitur memiliki struktur spesifik dengan pemisahan *layer* fungsional: `data/` (Repositories & Models) dan `presentation/` (BLoC/Cubits, Pages, Widgets).

## 🤝 Kontribusi & Lisensi

Aplikasi ini dikembangkan dan dirancang khusus sebagai bentuk pemenuhan Tugas Akhir Proyek mata kuliah Mobile Computing, Universitas Cakrawala (Kelompok 5). Segala bentuk fitur telah disesuaikan dengan *Product Requirements Document* (PRD).

---
*Dibuat dengan ❤️ oleh Kelompok 5*
