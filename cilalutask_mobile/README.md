# CILULATAKS Mobile (Dart & Flutter)

Aplikasi mobile korporat **CILULATAKS** untuk manajemen tugas operasional, verifikasi kepatuhan Standard Operating Procedure (SOP), pelaporan efisiensi tim, dan kolaborasi terpadu.

Dibangun dengan arsitektur **Feature-First / Clean Architecture**, Flutter 3.x, dan Dart 3.x modern.

---

## 📱 Fitur Utama & Otoritas Akses (RBAC)

### 🔐 1. Halaman Masuk Multi-Peran (Login Screen)
- **Pemilihan Peran Interaktif**: Pilihan masuk sebagai **Admin (Manager)** atau **User (Karyawan)**.
- **Dukungan Karyawan Lengkap**: Dapat memilih akun karyawan spesifik (Kevin Maulana, Budi Santoso, Nadia Salsabila, Rina Wulandari).
- **Tombol Demo 1-Klik**: Masuk instan untuk pengujian demo cepat (`Demo Admin`, `Demo User IT`, `Demo User Ops`).
- **Ganti Akun & Keluar**: Akses ganti akun kapan saja melalui avatar profil di App Bar.

### 🛡️ 2. Aturan Hak Akses (Role-Based Access Control)
- **User (Karyawan)**:
  - **Hanya User** yang dapat memperbarui progres tugas (`Update Progres`), mencentang subtask checklist, dan mengajukan review tugas.
  - Membaca dan mengonfirmasi kepatuhan SOP digital.
  - Berkomunikasi via Saluran Chat Tim dan Pesan Langsung (DM).
  - *Dibatasi*: Tidak dapat memberikan/membuat tugas baru dan tidak dapat mereview/menyetujui tugas.
- **Admin (Manager)**:
  - **Hanya Admin** yang dapat mereview dan memberikan persetujuan tugas (`Review & Persetujuan`).
  - **Hanya Admin** yang dapat membuat tugas baru (`Buat Tugas Baru` / `+ Tugas`) dan mendelegasikannya kepada karyawan.
  - Mengunggah & memperbarui dokumen SOP baru.
  - Mengirimkan siaran pengumuman (Broadcast) ke seluruh divisi.

### 📑 3. Navigasi 6 Tab Terpadu
1. **Beranda (Home)**: Metrik efisiensi tim, aksi cepat adaptif peran, dan daftar tugas mendesak.
2. **Tugas (Tasks)**: Manajemen tugas dengan filter divisi, status, dan aksi terpisah sesuai peran (User: Update Progres, Admin: Review & + Tugas).
3. **Pusat SOP (Knowledge Base)**: Direktori dokumen SOP, filter kepatuhan, dan pembaca dokumen interaktif.
4. **Kinerja & Analisis (Reports)**: Laporan analitik, leaderboard karyawan, dan rekomendasi produktivitas.
5. **💬 Tab Chat (Kolaborasi Tim)** *(Tab Baru di antara Laporan & Tim)*:
   - **Saluran Tim (Channels)**: `#umum`, `#operasional-gudang`, `#it-tech-core`, `#pemasaran-kreatif`, `#keuangan-pajak`.
   - **Pesan Langsung (Direct Messages)**: Chat 1-on-1 dengan seluruh karyawan.
   - **Fitur Chat**: Bubble obrolan modern, avatar, role badge, timestamp, indikator belum dibaca, dan input pesan responsif.
6. **Tim & Notifikasi (Team)**: Daftar anggota divisi dengan aksi kontak/chat dan riwayat notifikasi real-time.

### 🔔 4. Sistem Notifikasi Mobile Lancar & Real-time
- **In-App Heads-Up Banner**: Banner mengambang meluncur dari atas dengan animasi halus (`SlideTransition` + `FadeTransition`), feedback getaran haptik, geser ke atas untuk tutup, dan ketuk untuk langsung membuka tugas/chat terkait.
- **Pusat Notifikasi Instan (Sheet)**: Mengetuk lonceng di App Bar langsung memunculkan sheet notifikasi live dengan filter kategori dan indikator real-time.
- **Event Dispatcher Real-time**: Otomatis memicu notifikasi saat tugas diterbitkan, progres subtask diperbarui, tugas disetujui, SOP diunggah, atau pesan chat dikirim.
- **Simulasi Interaktif Rekan Tim**: Tombol uji coba instan `Uji Real-time (+)` untuk menguji kelancaran notifikasi secara langsung.

### 🗂️ 5. Interactive Bottom Sheets & Modals
- `InAppNotificationBanner`: Banner melayang heads-up dengan auto-dismiss 4 detik.
- `NotificationCenterBottomSheet`: Pusat kontrol notifikasi cepat dengan filter kategori.
- `CreateTaskBottomSheet`: Form pembuatan tugas baru + checklist subtask dinamis.
- `UpdateProgressBottomSheet`: Checklist subtask interaktif dengan auto-recalculated percentage.
- `ReviewTaskBottomSheet`: Rincian tugas untuk persetujuan manajerial.
- `SopDetailBottomSheet`: Reader SOP berstruktur dengan tombol verifikasi kepatuhan digital.
- `UploadSopBottomSheet`: Form pengunggahan dan penerbitan SOP baru.
- `ExportReportBottomSheet`: Pilihan format ekspor (PDF Eksekutif, Excel XLSX, CSV).
- `BroadcastBottomSheet`: Siaran pengumuman per divisi dengan log instan ke feed aktivitas.
- `ProfileBottomSheet`: Profil pengguna, otoritas akun, & tombol keluar/ganti akun.

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Masuk ke direktori mobile
```bash
cd cilalutask_mobile
```

### 2. Unduh dependensi (jika baru di-clone)
```bash
flutter pub get
```

### 3. Analisis kode & verifikasi
```bash
flutter analyze
flutter test
```

### 4. Jalankan pada emulator / device / Chrome
```bash
flutter run
```
Untuk memilih device tertentu:
```bash
flutter devices
flutter run -d <device-id>
```
Atau di web browser untuk preview instan:
```bash
flutter run -d chrome
```

---

## 🏛️ Struktur Arsitektur Codebase

```
cilalutask_mobile/
├── lib/
│   ├── main.dart                          # Entry point aplikasi
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # Token warna korporat
│   │   │   └── app_theme.dart             # ThemeData & komponen style
│   │   └── widgets/
│   │       ├── custom_avatar.dart         # Avatar dengan network fallback
│   │       └── custom_badge.dart          # Badge prioritas & divisi
│   ├── models/
│   │   ├── task.dart                      # Model Tugas & Subtask
│   │   ├── sop.dart                       # Model Dokumen SOP
│   │   ├── employee.dart                  # Model Assignee & Performa
│   │   ├── activity.dart                  # Model Aktivitas Tim
│   │   └── notification_item.dart         # Model Notifikasi
│   ├── data/
│   │   └── mock_data.dart                 # Data awal aplikasi
│   ├── state/
│   │   ├── app_state_controller.dart      # Business logic & reactive state
│   │   └── app_state_scope.dart           # InheritedNotifier provider
│   ├── screens/
│   │   ├── main_navigation_screen.dart    # App Bar + BottomNav + Tab Switcher
│   │   ├── home/home_screen.dart          # Tab Beranda
│   │   ├── tasks/tasks_screen.dart        # Tab Tugas
│   │   ├── sop/sop_screen.dart            # Tab SOP
│   │   ├── reports/reports_screen.dart    # Tab Laporan & Kinerja
│   │   └── team/team_screen.dart          # Tab Tim & Notifikasi
│   └── widgets/modals/
│       ├── create_task_bottom_sheet.dart
│       ├── update_progress_bottom_sheet.dart
│       ├── review_task_bottom_sheet.dart
│       ├── sop_detail_bottom_sheet.dart
│       ├── upload_sop_bottom_sheet.dart
│       ├── export_report_bottom_sheet.dart
│       ├── broadcast_bottom_sheet.dart
│       └── profile_bottom_sheet.dart
└── test/
    └── widget_test.dart                   # Smoke test verifikasi
```
