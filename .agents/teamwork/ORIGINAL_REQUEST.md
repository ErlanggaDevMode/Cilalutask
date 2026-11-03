# Original User Request

## Initial Request — 2026-11-02T18:50:23Z

Sebagai developer, perbaiki defek dan ketidaksesuaian data pada aplikasi web dan mobile Cilalutask yang tercatat di QA_Report.md, serta pastikan seluruh quality gates dan verifikasi lolos.

Working directory: c:\T\Cilalutask
Integrity mode: development

Referensi: c:\T\Cilalutask\QA_Report.md

## Requirements

### R1. Perbaikan Defek Aplikasi Web (DEF-01 s/d DEF-13)
Perbaiki seluruh defek yang terdaftar pada Bagian 5.1 QA_Report.md di aplikasi web (`src/`), meliputi rekonsiliasi data hardcoded (DEF-02, DEF-03, DEF-04, DEF-07), inkonsistensi divisi & leaderboard (DEF-01, DEF-08, DEF-09), sinkronisasi notifikasi & SOP (DEF-05, DEF-06, DEF-11), tombol interaktif & filter laporan (DEF-12), serta mitigasi isolasi multi-tenant (DEF-13).

### R2. Perbaikan & Pemeliharaan Defek Mobile (M-DEF-01 s/d M-DEF-05)
Pastikan seluruh defek mobile pada Bagian 5.2 QA_Report.md terselesaikan pada `cilalutask_mobile/`, termasuk kepatuhan format Dart (M-DEF-01 pada `notification_controller.dart`), subteks dinamis (M-DEF-02), efisiensi profil dinamis (M-DEF-03), denominator pembaca SOP dinamis (M-DEF-04), dan isolasi ketat pesan langsung agar tidak muncul di Pusat Notifikasi (M-DEF-05).

### R3. Verifikasi Quality Gates dan Status Laporan QA
Jalankan verifikasi untuk setiap perbaikan menggunakan skrip/test suite terkait (`npm run lint`, `npm run build`, `flutter test`, `flutter analyze`, `dart format`) serta verifikasi manual langkah reproduksi yang terdokumentasi di QA_Report.md. Perbarui status checklist pada `QA_Report.md` untuk setiap item yang telah berhasil diperbaiki (dari FAIL menjadi PASS/Resolved).

## Acceptance Criteria

### Web Defect Resolution
- [ ] Defek rekonsiliasi metrik Beranda dan status tugas (DEF-02, DEF-03, DEF-04, DEF-07) diperbaiki sehingga menampilkan nilai aktual tanpa pemalsuan data atau nilai hardcoded.
- [ ] Inkonsistensi divisi, leaderboard, dan data master (DEF-01, DEF-08, DEF-09) diselaraskan sesuai data aktual.
- [ ] Sinkronisasi state notifikasi header (DEF-05), banner SOP urgent (DEF-06), tombol interaktif (DEF-10, DEF-11), dan filter laporan (DEF-12) berfungsi sebagaimana mestinya.
- [ ] Pipeline web (`npm run lint` dan `npm run build`) berhasil dieksekusi dengan exit code 0 tanpa error.

### Mobile Defect Resolution & Quality Gates
- [ ] Kepatuhan format kode Dart pada `cilalutask_mobile/lib/state/notification_controller.dart` (M-DEF-01) lulus `dart format --set-exit-if-changed`.
- [ ] Subteks tugas aktif (M-DEF-02), efisiensi tim (M-DEF-03), dan denominator pembaca SOP (M-DEF-04) terikat secara dinamis ke data riil.
- [ ] Pesan langsung (Direct Message) terisolasi secara ketat dan tidak muncul di modal Pusat Notifikasi (M-DEF-05).
- [ ] `flutter analyze` menghasilkan zero issues dan seluruh test suite `flutter test` (96+ test) lulus 100%.

### QA Report Status Update
- [ ] Checklist hasil pengujian pada `c:\T\Cilalutask\QA_Report.md` diperbarui mencerminkan perbaikan yang telah diverifikasi.


## Follow-up — 2026-11-03T01:56:57Z

Bangun dan lanjutkan pekerjaan: Lanjutkan fase finalisasi dan victory audit untuk QA_Report.md pada repositori Cilalutask. Quota API telah reset.


## Follow-up — 2026-11-03T01:57:02Z

Bangun dan lanjutkan pekerjaan: Lanjutkan perbaikan defek web (DEF-01 s/d DEF-13) dan mobile (M-DEF-01 s/d M-DEF-05) mengacu pada QA_Report.md. Quota API telah reset.


## Follow-up (Data Master) — 2026-11-03T01:57:07Z

Sebagai Data Master, bentuk tim untuk kelola data dan database (Firebase Firestore dan LocalStorage) pada repositori Cilalutask (web di src/ dan mobile di cilalutask_mobile/) untuk laporan dan perbaikan data berkolaborasi dengan tim dev, dengan fokus rekonsiliasi data, sinkronisasi skema multi-tenant, dan pembersihan mock data mengacu pada QA_Report.md.

Working directory: c:\T\Cilalutask
Integrity mode: development

Referensi: c:\T\Cilalutask\QA_Report.md (Bagian 4.4 Audit Rekonsiliasi dan Bagian 5 Dokumentasi Cacat Data)

## Requirements

### R1. Rekonsiliasi Data dan Denominator SOP
Lakukan rekonsiliasi nilai data dan denominator pada dokumen SOP serta komponen terkait di aplikasi web (`src/data/mockData.ts`) dan mobile (`cilalutask_mobile/lib/data/mock_data.dart` dan modal terkait) agar perhitungan jumlah tim/anggota bersifat dinamis dan selaras dengan jumlah anggota riil perusahaan (misalnya 6 karyawan pada CILALU-88 atau 1 pada tenant baru), menghilangkan nilai statis (seperti `32/34 Tim` atau default `0/34 Tim`).

### R2. Sinkronisasi Skema Data Multi-Tenant (Firestore & Web/Mobile State)
Sinkronkan skema data dan pemisahan tenant antara Cloud Firestore dan state manajemen pada aplikasi web (`src/`) dan mobile (`cilalutask_mobile/`), memastikan struktur data, tipe entitas, dan isolasi kode perusahaan (`companyCode`) konsisten lintas platform tanpa kebocoran data antar tenant.

### R3. Pembersihan Dead Mock Data dan Standardisasi Data Master
Bersihkan *dead mock data* atau entri data usang yang tidak terpakai pada `mock_data.dart` dan `mockData.ts`. Standardisasi penamaan divisi (menyeragamkan `IT & Development` menjadi `IT & Tech` sesuai kontrak tipe data) dan konsolidasi data leaderboard/performa agar selaras dengan data riil tugas.

### R4. Kolaborasi dengan Tim Dev dan Pelaporan Status Data
Susun laporan audit data yang mendokumentasikan hasil rekonsiliasi, pemetaan skema Firestore, dan daftar perbaikan data yang telah diselesaikan untuk berkolaborasi dengan tim pengembang web dan mobile.

### R5. Pembuatan dan Eksekusi Verifikasi Otomatis
Sediakan dan jalankan script verifikasi atau test suite otomatis untuk memvalidasi integritas data, konsistensi skema multi-tenant, dan kesesuaian angka metrik tanpa error.

## Acceptance Criteria

### Rekonsiliasi & Konsistensi Data
- [ ] Denominator dan counter pembaca SOP pada data master web dan mobile tidak lagi memuat angka statis ('34 Tim') dan mencerminkan jumlah anggota riil perusahaan secara dinamis.
- [ ] Penamaan divisi dan entitas data master konsisten antara kontrak tipe (`types.ts`), data karyawan, dan modul laporan/leaderboard.
- [ ] Seluruh *dead mock data* yang tidak terpakai telah dibersihkan dari `mock_data.dart` dan `mockData.ts`.

### Skema Multi-Tenant & Database
- [ ] Skema data entitas (Company, Task, SOP, User) tersinkronisasi antara Firestore dan model state web/mobile dengan isolasi multi-tenant berbasis `companyCode`.
- [ ] Pengujian atau operasi database dijalankan menggunakan konfigurasi instance Firebase aktif yang tersedia di repositori.

### Pelaporan & Verifikasi
- [ ] Laporan status rekonsiliasi data dan perbaikan database terdokumentasi dengan jelas.
- [ ] Script atau test suite verifikasi integritas data tersedia dan lulus pengujian (exit code 0) pada lingkungan pengujian repositori.

## Follow-up — 2026-11-03T01:57:07Z

Bangun dan lanjutkan pekerjaan: Lanjutkan rekonsiliasi data master, eksekusi test verifikasi integritas data, dan audit skema Firestore multi-tenant mengacu pada QA_Report.md. Quota API telah reset.

