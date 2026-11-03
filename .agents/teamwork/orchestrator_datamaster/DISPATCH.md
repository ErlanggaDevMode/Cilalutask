## 2026-11-02T18:51:10Z

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

***
Metadata & Directives:
- Your working directory: c:\T\Cilalutask\.agents\teamwork\orchestrator_datamaster\
- Original Request path: c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md
- Workspace root: c:\T\Cilalutask
- QA Report path: c:\T\Cilalutask\QA_Report.md
- When all tasks and acceptance criteria are completed, write your handoff and report victory back to me (conversation ID: 052e553e-a6a9-4310-95a1-494b684df705).


## 2026-11-03T01:58:55Z

Quota API telah reset dan sistem telah pulih. Lanjutkan eksekusi proyek Data Master: periksa status subagent/worker (dm_worker_1), tuntaskan rekonsiliasi data, eksekusi test verifikasi integritas data (scripts/verify_data_integrity.ts dan unit test Dart), serta jalankan siklus review/challenger/auditor hingga kemenangan dan serahkan handoff.md ke Sentinel.
