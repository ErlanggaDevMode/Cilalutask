Sebagai developer, perbaiki defek dan ketidaksesuaian data pada aplikasi web dan mobile Cilalutask yang tercatat di QA_Report.md, serta pastikan seluruh quality gates dan verifikasi lolos.

Working directory: c:\T\Cilalutask
Integrity mode: development

Referensi: c:\T\Cilalutask\QA_Report.md

## Requirements

### R1. Perbaikan Defek Aplikasi Web (DEF-01 s/d DEF-13)
Perbaiki seluruh defek yang terdaftar pada Bagian 5.1 QA_Report.md di aplikasi web (`src/`), meliputi rekonsiliasi data hardcoded (DEF-02, DEF-03, DEF-04, DEF-07), inkonsistensi divisi & leaderboard (DEF-01, DEF-08, DEF-09), sinkronisasi notifikasi & SOP (DEF-05, DEF-06, DEF-11), tombol interaktif & filter laporan (DEF-10, DEF-12), serta mitigasi isolasi multi-tenant (DEF-13).

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
