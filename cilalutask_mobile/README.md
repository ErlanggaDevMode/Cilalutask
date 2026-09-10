# CILULATAKS Mobile (Dart & Flutter)

Aplikasi mobile korporat **CILULATAKS** untuk manajemen tugas operasional, verifikasi kepatuhan Standard Operating Procedure (SOP), pelaporan efisiensi tim, dan kolaborasi terpadu.

Dibangun dengan arsitektur **Feature-First / Clean Architecture**, Flutter 3.x, dan Dart 3.x modern.

---

## 📱 Fitur Utama

1. **Beranda (Home)**:
   - Kartu sapaan personal Manager dengan progress target kuartal (88%) dan efisiensi tim (94%).
   - Bar Aksi Cepat (Buat Tugas Baru, Unggah SOP, Kirim Pengumuman Tim).
   - Ringkasan Beban Kerja 2x2 Grid (Tugas Aktif, Selesai, Menunggu Review, Mendekati Batas).
   - Daftar tugas mendekati batas waktu dengan progress bar real-time.
   - Feed aktivitas tim terkini.

2. **Manajemen Tugas (Tasks)**:
   - Pencarian real-time (judul, deskripsi, nama PIC).
   - Filter divisi (Semua, Operasional, IT & Tech, Pemasaran, Finance).
   - Filter karyawan/PIC dengan avatar.
   - Segmented status tab: Belum Dimulai, Dalam Proses, Selesai.
   - Kartu tugas interaktif dengan checklist progress bar.
   - Tombol aksi: Update Progres & Review Persetujuan.
   - Floating Action Button (+ Tugas).

3. **Pusat SOP (Knowledge Base)**:
   - Pencarian SOP dan filter kategori departemen.
   - Banner Kelola Dokumen untuk Manager.
   - Kartu peringatan merah untuk SOP darurat yang wajib dibaca & dikonfirmasi.
   - Direktori dokumen lengkap dengan toggle bookmark, rasio kepatuhan tim, dan pembaca dokumen interaktif.

4. **Kinerja & Analisis (Reports)**:
   - Selector periode (Bulan Ini, Minggu Ini, Kuartal 1, Tahun Ini).
   - Hero metric card: Tingkat Penyelesaian 92.4% (+4.2%).
   - Sub-metrik: Ketepatan waktu (88% on-time) dan rata-rata durasi (1.8 hari).
   - Visualisasi produktivitas divisi (Operasional, Finance, IT, Pemasaran).
   - Leaderboard kinerja karyawan (#1 sampai #4) dengan status tag dan skor.
   - Rekomendasi beban kerja otomatis (AI note) dengan aksi penyeimbangan tugas.

5. **Tim & Notifikasi (Team)**:
   - Sub-tab switcher: Anggota & Notifikasi.
   - Profil manager highlight.
   - Daftar seluruh anggota tim dengan tombol aksi langsung "Beri Tugas".
   - Notifikasi riwayat terintegrasi dengan penanda belum dibaca dan fitur "Tandai Semua Dibaca".

6. **Interactive Bottom Sheets & Modals**:
   - `CreateTaskBottomSheet`: Form pembuatan tugas baru + checklist subtask dinamis.
   - `UpdateProgressBottomSheet`: Checklist subtask interaktif dengan auto-recalculated percentage.
   - `ReviewTaskBottomSheet`: Rincian tugas untuk persetujuan manajerial.
   - `SopDetailBottomSheet`: Reader SOP berstruktur dengan tombol verifikasi kepatuhan digital.
   - `UploadSopBottomSheet`: Form pengunggahan dan penerbitan SOP baru.
   - `ExportReportBottomSheet`: Pilihan format ekspor (PDF Eksekutif, Excel XLSX, CSV).
   - `BroadcastBottomSheet`: Siaran pengumuman per divisi dengan log instan ke feed aktivitas.
   - `ProfileBottomSheet`: Profil pengguna & metrik efisiensi.

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
