# Laporan Eksekusi Pengujian Otomatis & Quality Gates Mobile (Cilalutask Mobile)

**Tanggal Eksekusi**: 2026-11-02  
**Target Proyek**: `cilalutask_mobile/`  
**Flutter SDK**: `3.47.2` (Channel stable, revision `d3b14c8769`)  
**Dart SDK**: `3.13.2` (Platform: `windows_x64`)  
**QA Specialist**: Worker 2 (`teamwork_worker_m2`)  
**Mandat Integritas**: 100% data diverifikasi secara empiris melalui eksekusi perintah riil di terminal tanpa data tiruan atau rekayasa.

---

## 1. Ringkasan Eksekutif Quality Gates

| Quality Gate | Perintah / Scope | Total Kasus | Lolos (Pass) | Gagal (Fail) | Durasi | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Gate 1: Format Verifikasi** | `dart format --output=none --set-exit-if-changed .` | 69 berkas Dart | 68 berkas | 1 berkas | 10.36 dtk | ❌ **FAIL** (Ditemukan berkas tidak rapi) |
| **Gate 2: Analisis Statis** | `flutter analyze` | 69 berkas Dart | 0 isu | 0 error / warn | 42.60 dtk | ✅ **PASS** (Zero issues found) |
| **Gate 3: Automated Test Full Suite** | `flutter test` (15 berkas suite) | 96 skenario | 96 skenario | 0 skenario | 1m 40s | ✅ **PASS** (100% lolos) |
| **Gate 3A: Model & Logika Murni** | `test/pure_business_logic_and_models_test.dart` | 8 skenario | 8 skenario | 0 skenario | < 1 dtk | ✅ **PASS** |
| **Gate 3B: State Controllers** | 5 controller test suites | 26 skenario | 26 skenario | 0 skenario | 9.2 dtk | ✅ **PASS** |
| **Gate 3C: Keamanan, Auth & Multi-Tenancy** | 3 security & architecture suites | 18 skenario | 18 skenario | 0 skenario | 9.8 dtk | ✅ **PASS** |
| **Gate 3D: UI/UX, Performa & Offline** | 3 UI/UX & performance suites | 24 skenario | 24 skenario | 0 skenario | 60.1 dtk | ✅ **PASS** |
| **Gate 3E: End-to-End User Flow** | `test/integration_main_user_flow_test.dart` | 1 skenario besar | 1 skenario | 0 skenario | 11.0 dtk | ✅ **PASS** |
| **Gate 3F: Metrik Tugas & Filter UI** | `test/task_metrics_and_functional_fixes_test.dart` | 11 skenario | 11 skenario | 0 skenario | 10.1 dtk | ✅ **PASS** |
| **Gate 3G: Splash, Auth & Local Storage** | `test/splash_auth_database_storage_test.dart` | 8 skenario | 8 skenario | 0 skenario | 7.8 dtk | ✅ **PASS** |

---

## 2. Rincian Eksekusi Quality Gate 1: Format Code (FAIL)

### 2.1 Prosedur & Perintah
- **Perintah**:
  ```powershell
  Set-Location c:\T\Cilalutask\cilalutask_mobile
  dart format --output=none --set-exit-if-changed .
  ```
- **Tujuan**: Memverifikasi kepatuhan seluruh kode Dart terhadap konvensi format resmi Flutter/Dart.
- **Kriteria Penerimaan**: Exit code 0, 0 berkas berubah.

### 2.2 Output Eksekusi Faktual
```text
Changed lib\state\notification_controller.dart
Formatted 69 files (1 changed) in 10.36 seconds.
FORMAT_EXIT_CODE: 1
```

### 2.3 Analisis & Rekomendasi QA
- **Hasil**: ❌ **FAIL** (Exit code: 1).
- **Temuan**: Terdapat 1 berkas yang belum diformat sesuai standar dart format, yaitu `lib\state\notification_controller.dart`.
- **Rekomendasi untuk Tim Pengembang**: Jalankan perintah `dart format lib/state/notification_controller.dart` untuk menstandardisasi indentasi dan wrapping agar Gate 1 lulus di pipeline CI/CD.

---

## 3. Rincian Eksekusi Quality Gate 2: Static Code Analysis (PASS)

### 3.1 Prosedur & Perintah
- **Perintah**:
  ```powershell
  Set-Location c:\T\Cilalutask\cilalutask_mobile
  flutter analyze
  ```
- **Tujuan**: Memeriksa type safety, null safety, dead code, unused imports, dan pelanggaran rule linting `flutter_lints ^6.0.0`.
- **Kriteria Penerimaan**: Exit code 0, "No issues found!".

### 3.2 Output Eksekusi Faktual
```text
Analyzing cilalutask_mobile...                                  
No issues found! (ran in 42.6s)
ANALYZE_EXIT_CODE: 0
```

### 3.3 Analisis QA
- **Hasil**: ✅ **PASS** (Exit code: 0).
- **Evaluasi**: Arsitektur kode Flutter memenuhi standar kepatuhan tinggi: zero lint error, zero warning, dan zero type mismatch pada seluruh 69 berkas sumber daya.

---

## 4. Rincian Eksekusi Quality Gate 3: Automated Test Suites (PASS)

### 4.1 Prosedur & Perintah Keseluruhan
- **Perintah**:
  ```powershell
  Set-Location c:\T\Cilalutask\cilalutask_mobile
  flutter test
  ```
- **Hasil Eksekusi**:
  ```text
  01:40 +96: All tests passed!
  TEST_EXIT_CODE: 0
  ```
- **Total Suite**: 15 berkas uji mandiri.
- **Total Test Cases**: 96 kasus uji.
- **Status Akhir**: 96 Lolos (100%), 0 Gagal, 0 Flaky.

---

### 4.2 Rincian Granular Per Suite Pengujian

#### Suite 3A: Pure Business Logic & Model Security
- **Berkas**: `test/pure_business_logic_and_models_test.dart`
- **Waktu Eksekusi**: < 1.0 detik
- **Status**: ✅ **PASS (8/8 Lolos)**
- **Daftar Uji & Asersi**:
  1. `Company model: serialization preserves attributes and never stores password` (PASS)
  2. `Assignee/Employee model: serialization preserves attributes and never stores password` (PASS)
  3. `Task and Subtask model: serialization and progress rounding bounds` (PASS)
  4. `SOPDocument and ContentSection model: roundtrip preserves sections and fields` (PASS)
  5. `JoinRequest model: validates zero password and status mappings` (PASS)
  6. `Calculates overall task statistics accurately with boundary conditions` (PASS)
  7. `Filters tasks by combined criteria: query + status + division + priority` (PASS)
  8. `Role permission checks distinguish Admin vs Regular User capabilities` (PASS)

---

#### Suite 3B: Domain State Controllers
- **Berkas**:
  - `test/task_controller_test.dart` (6 uji)
  - `test/company_controller_test.dart` (5 uji)
  - `test/sop_controller_test.dart` (4 uji)
  - `test/chat_controller_test.dart` (6 uji)
  - `test/notification_controller_test.dart` (5 uji)
- **Waktu Eksekusi**: 9.2 detik
- **Status**: ✅ **PASS (26/26 Lolos)**
- **Daftar Uji & Asersi**:
  - **TaskController**:
    1. `Initializes with default tasks`: Memverifikasi task default (8 tugas) dimuat ke memori.
    2. `createTask adds task and triggers onTaskCreated`: Menambahkan task baru dan memicu callback notifikasi.
    3. `deleteTask removes task from memory and repository`: Menghapus task secara konsisten.
    4. `saveProgress updates subtasks and completion status`: Menghitung progres persentase otomatis dari checklist subtask (0-100%).
    5. `approveTask marks task completed and needsReview false`: Alur approval manajerial selesai.
    6. `clear resets task list`: Mengosongkan daftar tugas saat logout.
  - **CompanyController**:
    7. `Initializes with default company and employees`: Memuat PT Cilalu Sentosa (`CILALU-88`) & 6 karyawan.
    8. `registerCompany creates company in blank mode`: Pendaftaran perusahaan baru berstatus Blank Mode (0 task, 0 SOP, 1 admin).
    9. `submitJoinRequest adds pending request`: Pengajuan gabung tim oleh karyawan baru.
    10. `acceptJoinRequest promotes user to employee`: Promosi pemohon menjadi karyawan resmi secara atomik.
    11. `rejectJoinRequest updates status to rejected`: Penolakan join request oleh admin.
  - **SopController**:
    12. `Initializes with default SOPs and loads correctly`: Memuat 5 dokumen SOP bawaan.
    13. `Add and delete SOP updates state and notifies`: Penambahan & penghapusan dokumen SOP.
    14. `Confirm read and toggle bookmark update state properly`: Verifikasi baca digital dan bookmarking SOP.
    15. `Clear resets SOP list and error state`: Pembersihan state SOP saat session berakhir.
  - **ChatController**:
    16. `Initializes with default channels and messages`: Memuat 5 kanal default (`#umum`, `#operasional-gudang`, `#it-tech-core`, `#pemasaran-kreatif`, `#finance-akuntansi`).
    17. `Filter messages by channel and direct messages`: Pemisahan pesan kanal publik vs chat langsung 1-on-1.
    18. `sendChatMessage adds message and updates channel lastMessage`: Pengiriman pesan real-time.
    19. `deleteChatMessage removes message correctly`: Penghapusan pesan chat.
    20. `addChannel adds channel to list`: Pembuatan kanal obrolan baru.
    21. `clear resets channels and messages`: Pembersihan percakapan chat.
  - **NotificationController**:
    22: `Initializes with default notifications`: Memuat 3 notifikasi operasional bawaan.
    23: `pushNotification adds item and sets active banner`: Menampilkan banner heads-up di bagian atas layar.
    24: `markNotificationAsRead and markAllNotificationsAsRead update unread status`: Menandai status baca dinamis.
    25: `deleteNotification and clearAllNotifications update state`: Pembersihan riwayat notifikasi.
    26: `clear resets state completely`: Reset state notifikasi.

---

#### Suite 3C: Security, Auth & Multi-Tenancy Architecture
- **Berkas**:
  - `test/security_and_auth_test.dart` (7 uji)
  - `test/repository_test_doubles_test.dart` (5 uji)
  - `test/data_architecture_test.dart` (6 uji)
- **Waktu Eksekusi**: 9.8 detik
- **Status**: ✅ **PASS (18/18 Lolos)**
- **Daftar Uji & Asersi**:
  1. `Assignee model strictly excludes password from toMap and fromMap` (Zero Password in JSON).
  2. `Company model strictly excludes password and uses adminUid`.
  3. `JoinRequest model strictly stores userId (Firebase Auth UID) and no password`.
  4. `Cross-company access is strictly rejected`: Isolasi multi-tenant antar `companyCode`.
  5. `Non-admin member cannot create tasks or elevate role`: Role-Based Access Control (RBAC).
  6. `Logout clears all sensitive state and prevents data leaks`: Sanitasi token sesi lokal.
  7. `AuthService provides safe error messages without internal leak`: Pencegahan kebocoran stack trace error backend.
  8. `Remote sync succeeds and updates local disk cache`: Model write-through caching Firestore & disk.
  9. `Permission denied from security rules rethrows and stops unauthorized access`.
  10. `Deletion propagation: Deleting task removes from both cloud and local cache`.
  11. `Multi-tenant partitioning: Company A data is completely isolated from Company B`.
  12. `Company A and Company B data isolation on switch`.
  13. `Deleted tasks do NOT resurrect after restart or re-sync`: Pencegahan kebangkitan data hantu (ghost data).
  14. `SOP and Chat deletion propagate to local cache correctly`.
  15. `Logout clears cache and state; prevents lingering data`.
  16. `Atomic Join Request acceptance creates employee and notification atomically`.
  17. `DataException handles and surfaces error classifications explicitly`.
  18. `LocalStorageService persists and clears auth session securely`.

---

#### Suite 3D: Performance, Offline Resilience & UI Responsiveness
- **Berkas**:
  - `test/performance_and_offline_test.dart` (7 uji)
  - `test/ui_ux_quality_test.dart` (10 uji)
  - `test/widget_test.dart` (7 uji)
- **Waktu Eksekusi**: 60.1 detik
- **Status**: ✅ **PASS (24/24 Lolos)**
- **Daftar Uji & Asersi**:
  1. `loadTasks respects limit parameter and prevents unbounded downloads`: Pembatasan batch data memori.
  2. `loadMessages limits message history to avoid high memory spikes`: Pembatasan chat history.
  3. `Offline write: queues pending task in LocalStorage without throwing`: Antrian mutasi offline.
  4. `Reconnect reconciliation: syncs pending writes to Cloud and clears queue`: Rekonsiliasi sinkronisasi otomatis pasca online.
  5. `Multi-tenant isolation: pending writes for Company A do not sync to Company B`.
  6. `Search debounce timer batches rapid inputs into a single evaluation`: Debounce pencarian 250ms.
  7. `AppStateController clean session wipe clears memory on logout`.
  8. `AppEmptyState renders icon, title, description, and semantics`: Aksesibilitas widget kosong.
  9. `AppConfirmDialog cancel returns false`: Dialog konfirmasi destruktif (batal vs hapus).
  10. `LoginScreen validates email and password before submitting`: Validasi form kredensial.
  11. `CreateTaskBottomSheet safeguards empty employees list without crash`: Safeguard pembuatan tugas di blank mode.
  12. `Admin can delete task with confirmation dialog; Cancel preserves task`.
  13. `Admin can delete SOP with confirmation dialog; Cancel preserves SOP`.
  14. `Non-admin Karyawan does NOT see admin destructive delete buttons`: Sembunyikan aksi destruktif untuk role regular.
  15. `Small Viewport & Overflow Resilience: Renders properly without overflow on small mobile screen (320x480)`: Uji bebas render overflow (`A RenderFlex overflowed`) pada layar 320x480 dp.
  16. `Cilalutask initial launch shows LoginScreen with 3 tabs` (Masuk, Daftar PT, Gabung Tim).
  17. `Logging in as Admin shows 6 navigation tabs including Chat`.
  18. `Logging in as User/Karyawan has user role permissions`.
  19. `Real-time notification engine triggers heads-up banner`.
  20. `Local Persistence restores registered company, chat messages, and tasks across restarts`.

---

#### Suite 3E: End-to-End User Flow
- **Berkas**: `test/integration_main_user_flow_test.dart`
- **Waktu Eksekusi**: 11.0 detik
- **Status**: ✅ **PASS (1/1 Lolos)**
- **Skenario End-to-End yang Terverifikasi**:
  1. Aplikasi start dengan `SplashScreen` animasi logo Cilalutask.
  2. Navigasi otomatis ke `LoginScreen`.
  3. Login sebagai Admin PT Cilalu Sentosa (`CILALU-88`).
  4. Memuat dataset operasional di dashboard `HomeScreen`.
  5. Navigasi ke `TasksScreen`, membuka filter modal.
  6. Membuka `CreateTaskBottomSheet` dan membuat tugas baru: *"Audit Keamanan Server Tahunan"*.
  7. Menemukan task yang baru dibuat dan membuka `UpdateProgressBottomSheet`.
  8. Menandai checkbox subtask hingga progres bertambah.
  9. Menghapus task melalui modal konfirmasi `AppConfirmDialog`.
  10. Membuka `ProfileBottomSheet` dan melakukan registrasi perusahaan baru (Blank Mode).
  11. Verifikasi dashboard kosong yang bersih tanpa residual data perusahaan lama.
  12. Logout kembali ke `LoginScreen`.

---

#### Suite 3F: Task Metrics Calculator & Widget Filter Controls
- **Berkas**: `test/task_metrics_and_functional_fixes_test.dart`
- **Waktu Eksekusi**: 10.1 detik
- **Status**: ✅ **PASS (11/11 Lolos)**
- **Daftar Uji & Asersi**:
  1. `Empty dataset does not divide by zero and returns clean zero metrics`: Pencegahan error `NaN` / divide by zero.
  2. `Computes completion rate, status distribution, and on-time rate accurately`.
  3. `Task metrics with zero division does not crash division productivity`.
  4. `Indonesian period label formatting (Bulan Ini, Minggu Ini, Kuartal, Tahun Ini)`.
  5. `Status filtering: null status returns all, specific status limits accurately`.
  6. `Search query matches title, description, assignee name, and division`.
  7. `Filter combinations: division + priority + urgentOnly`.
  8. `Sorting options: progressHighest, progressLowest, priorityHighest, newest`.
  9. `TaskFilterBottomSheet renders and returns selected filters`.
  10. `SopFilterBottomSheet renders and returns sorting & toggle options`.
  11. `TasksScreen starts with "Semua" tab and displays all tasks without hiding`.

---

#### Suite 3G: Splash, Authentication & Storage Integrity
- **Berkas**: `test/splash_auth_database_storage_test.dart`
- **Waktu Eksekusi**: 7.8 detik
- **Status**: ✅ **PASS (8/8 Lolos)**
- **Daftar Uji & Asersi**:
  1. `SplashScreen renders cilalutask_logo.png on white background and transitions`.
  2. `CilalutaskApp launches with SplashScreen and automatically transitions to LoginScreen or MainNavigationScreen`.
  3. `Admin and Employee loginWithCredentials authenticate and authorize roles accurately`.
  4. `loginWithCredentials rejects unregistered employee and unauthorized admin email`.
  5. `LocalStorageService persists and clears auth session, company data, and pending offline tasks`.
  6. `Offline task creation queues write locally and reconciles to cloud database when back online`.
  7. `Disk cache invalidation on logout`.
  8. `Session restoration on app relaunch`.

---

## 5. Audit Rekonsiliasi Data, Multi-Tenancy & Integritas Bisnis

Berdasarkan instruksi khusus pengguna: *"Periksa secara teliti perbedaan antara angka metrik/ringkasan dengan data riil pada list/database... Pastikan seluruh penghitungan metrik cocok persis dengan data aktual. Jika ada ketidakcocokan, catat sebagai temuan cacat (FAIL) di QA_Report.md"*, berikut hasil audit mendalam pada aplikasi mobile:

### 5.1 Matriks Audit Rekonsiliasi Metrik Mobile

| ID Audit | Komponen / Tampilan | Data Riil (List / State / DB) | Angka pada Ringkasan / UI | Status Verifikasi | Temuan & Analisis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **M-REC-01** | `HomeScreen` Card Tugas Aktif | 5 tugas berstatus `inProgress` (`tsk-001`, `tsk-002`, `tsk-003`, `tsk-004`, `tsk-005`) | Angka utama: `5` (Cocok), Subteks: `"4 tugas baru"` (Tidak Cocok) | ❌ **FAIL (Cacat Ringkasan Statis)** | Angka utama `5` dihitung dinamis dari `TaskMetricsCalculator.computeMetrics(tasks).inProgress`. Namun, subteks kartu di-hardcode string `"4 tugas baru"` (`home_screen.dart:458`), bahkan saat aplikasi dalam mode Blank Mode (0 tugas aktif). |
| **M-REC-02** | `HomeScreen` Card Selesai | 2 tugas berstatus `completed` (`tsk-006`, `tsk-007`) dari total 8 tugas | Angka utama: `2`, Subteks: `"25.0% selesai"` | ✅ **PASS (Cocok Dinamis)** | Sesuai persis dengan data aktual (2 tugas = 25.0% dari 8 tugas). Dalam mode kosong (0 tugas), otomatis menampilkan `"0 tugas"` tanpa pembagian nol (`NaN`). |
| **M-REC-03** | `HomeScreen` Card Menunggu Review | 2 tugas dengan flag `needsReview: true` (`tsk-001`, `tsk-004`) | Angka utama: `2`, Subteks: `"Butuh persetujuan"` | ✅ **PASS (Cocok Dinamis)** | Sesuai persis dengan jumlah tugas yang membutuhkan review admin (`metrics.needsReview = 2`). |
| **M-REC-04** | `HomeScreen` Card Mendekati Batas | 3 tugas `isUrgentDeadline` (`tsk-003`, `tsk-004`, `tsk-005`) | Angka utama: `3`, Subteks: `"Tindakan segera"` | ✅ **PASS (Cocok Dinamis)** | Sesuai persis dengan jumlah tugas ber-urgensi tinggi yang belum selesai. |
| **M-REC-05** | `HomeScreen` Hero Card Efisiensi Tim | Tingkat penyelesaian tugas riil = 25.0% (2 / 8 tugas) | Tertulis: `"Efisiensi Tim: 94%"` | ❌ **FAIL (Cacat Nilai Hardcoded)** | String `"Efisiensi Tim: 94%"` diambil dari mock profile `CurrentUser.teamEfficiencyPercent: 94` (`mock_data.dart:17`), bukan dihitung dari rasio performa aktual atau SLA penyelesaian tugas. |
| **M-REC-06** | `TeamScreen` Header Daftar Karyawan | 6 karyawan di `CompanyController.employees` | Tertulis: `"Daftar Karyawan (6)"` | ✅ **PASS (Cocok Dinamis)** | Judul daftar karyawan mengambil string interpolasi `Daftar Karyawan (${employees.length})` (`team_screen.dart:86`), mencerminkan data aktual 100%. |
| **M-REC-07** | `MainNavigationScreen` & `NotificationCenter` Unread Badge | 3 notifikasi berstatus `unread: true` (`notif-1`, `notif-2`, `notif-3`) | Badge merah muncul; tombol bertuliskan `"Tandai Baca (3)"` | ✅ **PASS (Cocok Dinamis)** | Badge dan hitungan unread menggunakan `NotificationController.unreadNotificationsCount` (`main_navigation_screen.dart:84`). Begitu ditandai baca, unread berkurang menjadi 0 dan badge merah hilang secara reaktif. |
| **M-REC-08** | Dokumen SOP: Rasio Pembaca Tim | 6 orang karyawan resmi di database perusahaan | Dokumen `SOP-CC-012` tertulis `"32/34 Tim"`; Modal Upload SOP default `"0/34 Tim"` | ❌ **FAIL (Cacat Denominator Tim)** | Denominator `"34 Tim"` pada `mock_data.dart:421` dan `upload_sop_bottom_sheet.dart:87` adalah data statis sisa template. Padahal database anggota perusahaan hanya memiliki 6 orang. |
| **M-REC-09** | Isolasi Data Multi-Tenant (Perusahaan A vs B) | Switch antara `CILALU-88` dan `NEW-CORP` | Seluruh data tugas, SOP, chat, dan anggota perusahaan lama hilang total | ✅ **PASS (Terisolasi 100%)** | Terverifikasi di `data_architecture_test.dart` dan `repository_test_doubles_test.dart`. Tidak ada satu pun record milik Perusahaan A yang bocor ke Perusahaan B. |
| **M-REC-10** | Propagasi Penghapusan (Cache Invalidation) | Hapus Tugas/SOP pada repository lokal & cloud | Tugas terhapus permanen; tidak bangkit kembali pasca restart | ✅ **PASS (Bersih)** | Terverifikasi di `data_architecture_test.dart:2`. Kunci cache pada SharedPreferences dan Firestore langsung di-invalir saat operasi `deleteTask` dipanggil. |

---

## 6. Tindak Lanjut untuk Tim Dev & Tim Data Master

Berdasarkan temuan pengujian di atas, berikut item tindakan wajib yang diserahkan untuk perbaikan:

1. **Untuk Tim Dev Mobile (Frontend / State)**:
   - **Fix Gate 1 (Code Formatting)**:
     Format berkas `lib/state/notification_controller.dart` menggunakan `dart format` agar lolos pipeline CI Gate 1.
   - **Fix M-REC-01 (`home_screen.dart:458`)**:
     Ubah subteks hardcoded `'4 tugas baru'` pada kartu `Tugas Aktif` menjadi dinamis, misalnya menghitung tugas yang dibuat dalam 7 hari terakhir:
     ```dart
     subtext: '${tasks.where((t) => t.isNew).length} tugas baru'
     ```
   - **Fix M-REC-05 (`home_screen.dart:180`)**:
     Ubah persentase efisiensi tim dari nilai statis profil menjadi perhitungan dinamis berbasis metrik tugas aktual (`metrics.completionRate`).
   - **Fix M-REC-08 (`upload_sop_bottom_sheet.dart:87`)**:
     Ubah inisialisasi SOP baru dari hardcoded `'0/34 Tim'` menjadi dinamis sesuai jumlah karyawan aktual perusahaan:
     ```dart
     readTeamCount: '0/${state.employees.length} Tim'
     ```

2. **Untuk Tim Data Master**:
   - **Fix Data Mock SOP (`mock_data.dart:421`)**:
     Sesuaikan data pembaca SOP pada `sop-002` dari `'32/34 Tim'` dan `'94%'` menjadi proporsional terhadap 6 karyawan perusahaan, contohnya `'5/6 Tim'` (83.3%).
   - **Pembersihan Dead Mock Code (`mock_data.dart:540-609`)**:
     Dataset `kEmployeePerformance` (yang menyebutkan Ahmad Fauzi menyelesaikan 28 tugas) dan `kDivisionProductivity` adalah data tiruan statis yang tidak lagi dikonsumsi oleh aplikasi mobile karena layar `ReportsScreen` telah mengkalkulasi metrik secara dinamis dari objek tugas. Hapus atau sesuaikan dataset ini untuk menjaga integritas database referensi.
