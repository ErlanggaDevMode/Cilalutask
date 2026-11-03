# Laporan Investigasi Data Layer & Rekonsiliasi Mobile (dm_explorer_2)

**Peneliti**: dm_explorer_2 (Mobile Data Explorer)  
**Parent**: orchestrator_datamaster (Conv ID: `1d912ce8-fd6e-4794-86ba-c3cd76af91eb`)  
**Lingkup Kerja**: `c:\T\Cilalutask\cilalutask_mobile\`  
**Tanggal**: 2026-11-02  
**Status**: SELESAI (COMPLETED)  

---

## 1. OBSERVATION

Berdasarkan pemeriksaan langsung terhadap seluruh berkas data layer, state management, modal, dan layar antarmuka di `cilalutask_mobile/`, berikut adalah fakta empiris dan kutipan baris kode verbatim:

### 1.1 Struktur dan Audit Mock Data (`cilalutask_mobile/lib/data/mock_data.dart`)

1. **`kCurrentUser` (Baris 10–18)**:
   ```dart
   final CurrentUser kCurrentUser = CurrentUser(
     name: 'Sarah Pratama',
     role: 'Admin / Manager',
     email: 'sarah.pratama@cilulataks.id',
     avatar: '',
     division: 'Operations & Strategy',
     targetQuarterPercent: 88,
     teamEfficiencyPercent: 94, // Nilai statis 94% yang sebelumnya memicu REC-MOB-05 / M-DEF-03
   );
   ```
   - Properti `teamEfficiencyPercent` dan `targetQuarterPercent` hanya dideklarasikan pada model `CurrentUser` (`lib/models/employee.dart:124-125`) dan tidak dikonsumsi secara dinamis oleh UI setelah perbaikan kalkulator metrik.

2. **`kEmployees` (Baris 20–77)**:
   - Terdiri dari tepat 6 karyawan aktif pada tenant default (`CILALU-88`):
     - `emp-1`: Kevin Maulana (`division: 'IT & Tech'`, `role: 'Lead Cloud Engineer'`)
     - `emp-2`: Nadia Salsabila (`division: 'Pemasaran'`, `role: 'Senior Content Strategist'`)
     - `emp-3`: Budi Santoso (`division: 'Operasional'`, `role: 'Supervisor Gudang'`)
     - `emp-4`: Rian Dermawan (`division: 'Finance & Akuntansi'`, `role: 'Tax & Compliance Officer'`)
     - `emp-5`: Ahmad Fauzi (`division: 'Operasional'`, `role: 'Quality & Inbound Lead'`)
     - `emp-6`: Dina Putri (`division: 'Pemasaran'`, `role: 'Visual Designer'`)
   - Seluruh karyawan menggunakan nama divisi resmi (`IT & Tech`, `Pemasaran`, `Operasional`, `Finance & Akuntansi`).

3. **`kInitialTasks` (Baris 79–378)**:
   - Memuat 8 tugas awal:
     - 5 tugas status `TaskStatus.inProgress` (`tsk-001` s/d `tsk-005`)
     - 2 tugas status `TaskStatus.completed` (`tsk-006`, `tsk-007`)
     - 1 tugas status `TaskStatus.notStarted` (`tsk-008`)
     - `needsReview: true` pada 2 tugas (`tsk-001`, `tsk-004`)
     - `isUrgentDeadline: true` pada 3 tugas (`tsk-003`, `tsk-004`, `tsk-005`)
   - Rasio penyelesaian aktual database: **2 / 8 = 25.0%**.

4. **`kInitialSops` (Baris 380–504)**:
   - Terdiri dari 5 dokumen (`sop-001` s/d `sop-005`).
   - Pada `sop-002` (`SOP-CC-012`, baris 421):
     ```dart
     readProgressPercent: 83,
     complianceRatioText: '83% Karyawan sudah membaca & menyetujui',
     readTeamCount: '5/6 Tim',
     ```
     *(Catatan: Nilai lama `'32/34 Tim'` telah diselaraskan pada mock_data menjadi `'5/6 Tim'`)*.
   - Pada `sop-003` (`SOP-FIN-008`, baris 445):
     ```dart
     readProgressPercent: 100,
     complianceRatioText: 'Status: 100% Karyawan terverifikasi',
     readTeamCount: 'Lengkap',
     ```

5. **`kEmployeePerformance` (Baris 540–586) — [DEAD MOCK DATA & INKONSISTENSI DATA]**:
   - Dideklarasikan namun **TIDAK PERNAH DIIMPOR ATAU DIGUNAKAN DI MANAPUN** dalam seluruh aplikasi `cilalutask_mobile`:
     ```dart
     final List<EmployeePerformance> kEmployeePerformance = [
       const EmployeePerformance(
         id: 'perf-1', rank: 1, name: 'Ahmad Fauzi', division: 'Operasional', completedTasks: 28, ...
       ),
       const EmployeePerformance(
         id: 'perf-2', rank: 2, name: 'Rian Dermawan', division: 'Finance & Akuntansi', completedTasks: 22, ...
       ),
       const EmployeePerformance(
         id: 'perf-3', rank: 3, name: 'Nadia Salsabila', division: 'Pemasaran', completedTasks: 24, ...
       ),
       const EmployeePerformance(
         id: 'perf-4', rank: 4, name: 'Kevin Maulana',
         division: 'IT & Development', // Inkonsistensi nama divisi!
         completedTasks: 19, ...
       ),
     ];
     ```
   - **Cacat 1**: Memuat total akumulasi 93 tugas selesai (28 + 22 + 24 + 19), yang menggelembungkan data riil (hanya 2 tugas selesai di `kInitialTasks`).
   - **Cacat 2**: Baris 580 menggunakan `'IT & Development'` (kontras dengan `'IT & Tech'` di `kEmployees[0]`).
   - **Cacat 3**: Layar Laporan (`reports_screen.dart:38`) sudah menggunakan perhitungan dinamis murni `TaskMetricsCalculator.computeEmployeePerformance(state.tasks, state.employees)`, sehingga list `kEmployeePerformance` ini 100% dead code.

6. **`kDivisionProductivity` (Baris 588–609) — [DEAD MOCK DATA & INKONSISTENSI DIVISI]**:
   - Dideklarasikan namun **TIDAK PERNAH DIIMPOR ATAU DIGUNAKAN DI MANAPUN**:
     ```dart
     final List<DivisionProductivity> kDivisionProductivity = [
       const DivisionProductivity(name: 'Operasional', percent: 95, ...),
       const DivisionProductivity(name: 'Finance & Akuntansi', percent: 94, ...),
       const DivisionProductivity(name: 'IT & Development', percent: 91, ...), // Inkonsistensi nama divisi!
       const DivisionProductivity(name: 'Pemasaran', percent: 89, ...),
     ];
     ```
   - Baris 600 menggunakan nama `'IT & Development'`.
   - Layar Laporan (`reports_screen.dart:35`) menghitung produktivitas secara dinamis via `TaskMetricsCalculator.computeDivisionProductivity(state.tasks)`.

7. **`kInitialActivities` (Baris 506–538) & `kNotificationsData` (Baris 611–636)**:
   - Digunakan oleh `AppStateController._activities` dan `NotificationController._notifications`.

---

### 1.2 Denominator Pembaca SOP & Interaksi Modal SOP

1. **Modal Unggah SOP (`upload_sop_bottom_sheet.dart:87`)**:
   ```dart
   readProgressPercent: 0,
   readTeamCount: '0/${state.employees.length} Tim',
   complianceRatioText: '0% Karyawan terverifikasi',
   ```
   - Denominator telah terikat secara dinamis ke `${state.employees.length} Tim` (sebelumnya `'0/34 Tim'`).
   - Jika `state.employees` berjumlah 6, hasilnya adalah `'0/6 Tim'`. Jika tenant baru kosong (0 karyawan), menghasilkan `'0/0 Tim'`.

2. **Modal SOP Detail (`sop_detail_bottom_sheet.dart:427–447`)**:
   - Menampilkan instruksi operasional, bagian konten, dan tombol aksi "Saya Sudah Baca & Setuju" / "Sudah Disetujui".
   - Mengirim callback `onConfirmRead(sop.id)` ke `AppStateController.confirmReadSop(sop.id)`.

3. **Logika Konfirmasi Baca di Controller (`sop_controller.dart:106–129`)**:
   ```dart
   Future<void> confirmReadSop(String companyCode, String sopId) async {
     SOPDocument? target;
     _sops = _sops.map((s) {
       if (s.id == sopId) {
         target = s.copyWith(isReadByMe: true);
         return target!;
       }
       return s;
     }).toList();
     ...
   }
   ```
   - Operasi ini hanya memutasi `isReadByMe: true`. Properti string `readTeamCount` dan integer `readProgressPercent` tidak dihitung ulang secara dinamis saat seorang anggota membaca dokumen.

---

### 1.3 Perhitungan Anggota Tim Perusahaan & Isolasi Multi-Tenant

1. **State Management Karyawan (`company_controller.dart`)**:
   - `_employees` diinisialisasi dengan `List.from(kEmployees)` (6 orang untuk `CILALU-88`).
   - Saat mendaftarkan perusahaan baru via `registerCompany(...)` (baris 232-234):
     ```dart
     _isBlankMode = true;
     _employees = [];
     _joinRequests = [];
     ```
   - Saat permintaan gabung diterima (`acceptJoinRequest`, baris 366):
     ```dart
     _employees = [..._employees, newEmp];
     ```
     Anggota tim bertambah secara dinamis.

2. **Layar Tim (`team_screen.dart:86`)**:
   ```dart
   'Daftar Karyawan (${employees.length})'
   ```
   - Jumlah karyawan pada judul tab dan daftar kartu terikat 100% dinamis ke `state.employees.length`.

---

### 1.4 Temuan Kritis: Inflasi Matematika Efisiensi Tim di Beranda (`home_screen.dart:180`)

Pada pemeriksaan Beranda (`cilalutask_mobile/lib/screens/home/home_screen.dart`, baris 180):
```dart
Text(
  'Efisiensi Tim: ${metrics.total > 0 ? (metrics.completionRate * 100).round() : 100}%',
  style: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.successDark,
  ),
),
```
- **Akar Masalah**: Pengembang mengira `metrics.completionRate` bernilai desimal `0.25`, sehingga mengalikannya dengan 100 (`metrics.completionRate * 100`).
- **Fakta pada `task_metrics_calculator.dart:195-197`**:
  ```dart
  final completionRate = double.parse(
    ((completed / total) * 100).toStringAsFixed(1),
  );
  ```
  `metrics.completionRate` SUDAH BERUPA PERSENTASE (misal `25.0` untuk 2/8 tugas, terverifikasi di unit test `task_metrics_and_functional_fixes_test.dart:137`).
- **Dampak Nyata**: UI Beranda merender `'Efisiensi Tim: 2500%'` alih-alih `'Efisiensi Tim: 25%'`!
- **Solusi yang Harus Diterapkan**:
  ```dart
  'Efisiensi Tim: ${metrics.total > 0 ? metrics.completionRate.round() : 100}%'
  ```

---

### 1.5 Temuan Kritis: Quality Gate 2 Warning pada `home_screen.dart:19`

Pada eksekusi `flutter analyze`:
```text
warning - The value of the local variable 'user' isn't used. Try removing the variable or using it - lib\screens\home\home_screen.dart:19:11 - unused_local_variable
1 issue found. (ran in 112.7s)
ANALYZE_EXIT_CODE: 1
```
- **Akar Masalah**: Pada `home_screen.dart` baris 19 terdapat deklarasi:
  ```dart
  final user = state.currentUser;
  ```
  Karena baris 180 sebelumnya menggunakan `user.teamEfficiencyPercent` lalu diubah ke `metrics.completionRate`, variabel `user` tidak pernah digunakan lagi di manapun dalam `home_screen.dart`.
- **Rekomendasi Perbaikan**: Hapus baris 19 (`final user = state.currentUser;`) agar `flutter analyze` kembali ke status exit code 0 (zero issues).

---

### 1.6 Status Quality Gates Mobile (Hasil Eksekusi Terminal)

1. **Quality Gate 1 (Format Dart)**:
   - Perintah: `dart format --output=none --set-exit-if-changed .`
   - Output: `Formatted 69 files (0 changed) in 29.75 seconds.`
   - Status: ✅ **PASS (Exit Code 0)** — Seluruh 69 berkas termasuk `notification_controller.dart` sudah patuh standar format Dart.

2. **Quality Gate 2 (Static Analysis)**:
   - Perintah: `flutter analyze`
   - Output: 1 warning (`unused_local_variable` pada `home_screen.dart:19:11`)
   - Status: ⚠️ **FAIL (Exit Code 1)** akibat variabel tak terpakai pasca refactoring metrik.

---

## 2. LOGIC CHAIN

1. **Premis 1 (Sumber Data Tunggal)**: Seluruh metrik agregat di aplikasi mobile dihitung secara dinamis oleh `TaskMetricsCalculator` (`computeMetrics`, `computeDivisionProductivity`, `computeEmployeePerformance`).
2. **Premis 2 (Dead Code & Inkonsistensi)**: Variabel `kEmployeePerformance` dan `kDivisionProductivity` di `mock_data.dart` tidak pernah dikonsumsi oleh widget apapun. Keberadaannya hanya memuat data basi: 93 tugas selesai (kontras dengan 2 tugas riil) dan nama divisi non-standar `'IT & Development'` (kontras dengan kontrak `'IT & Tech'`).
3. **Premis 3 (Denominator SOP Dinamis)**: Denominator `'0/${state.employees.length} Tim'` di `upload_sop_bottom_sheet.dart:87` dan `'5/6 Tim'` di `mock_data.dart:421` telah menggantikan nilai statis lama `'34 Tim'`. Namun, fungsi `confirmReadSop` pada `sop_controller.dart` belum memperbarui `readTeamCount` atau persentase kepatuhan secara reaktif saat ada konfirmasi baca baru.
4. **Premis 4 (Multi-Tenant Employee Count)**: `CompanyController` memisahkan data dengan bersih. Perusahaan default `CILALU-88` memiliki 6 karyawan, sedangkan tenant baru memiliki 0 karyawan (Blank Mode). Tampilan `TeamScreen` menampilkan `${employees.length}` secara akurat.
5. **Premis 5 (Bug Efisiensi Beranda & Unused Variable)**:
   - Rumus `(metrics.completionRate * 100).round()` menghasilkan angka yang terdistorsi 100x lipat (2500%), melanggar prinsip rekonsiliasi data REC-MOB-05.
   - Refactor pada baris 180 meninggalkan `final user = state.currentUser;` yang tidak terpakai pada baris 19, sehingga merusak Gate 2 (`flutter analyze`).

---

## 3. CAVEATS

1. **SOP Reader Tracking Granular**: Model `SOPDocument` saat ini menyimpan `readTeamCount` sebagai string statis (`'5/6 Tim'`) dan bukan sebagai relasi daftar ID pembaca (`List<String> readerEmployeeIds`). Untuk sistem multi-user penuh di masa depan, skema Firestore sebaiknya menambahkan sub-koleksi `readers` atau array `readerIds` agar counter dan denominator dihitung otomatis dari `readerIds.length / employees.length`.
2. **Tenant Baru & Denominator 0**: Pada perusahaan baru yang belum memiliki karyawan (`employees.length == 0`), formulasi `'0/${state.employees.length} Tim'` akan menghasilkan `'0/0 Tim'`. Perlu dipastikan apakah admin perusahaan dihitung sebagai karyawan atau dibuat fallback aman `'0/1 Tim'` bila karyawan masih 0.

---

## 4. CONCLUSION

1. **Dead Mock Data Teridentifikasi**: `kEmployeePerformance` (baris 540–586) dan `kDivisionProductivity` (baris 588–609) di `cilalutask_mobile/lib/data/mock_data.dart` adalah dead data yang memuat cacat angka statis (93 tugas) dan divisi usang (`IT & Development`). Keduanya aman untuk dibersihkan atau diselaraskan ke `IT & Tech` dan data riil.
2. **Standardisasi Divisi**: Seluruh referensi divisi operasional mobile harus konsisten menggunakan `IT & Tech`, `Operasional`, `Pemasaran`, dan `Finance & Akuntansi`.
3. **Denominator SOP**: Denominator `'34 Tim'` telah tereliminasi dari kode aktif mobile. Dokumen SOP default menggunakan basis 6 anggota (`5/6 Tim`).
4. **Bug Efisiensi 2500% Teridentifikasi**: Ditemukan cacat logika matematika pada `home_screen.dart:180` yang melipatgandakan nilai persentase menjadi 2500% dan harus segera disederhanakan menjadi `metrics.completionRate.round()`.
5. **Quality Gate 1 Hijau, Gate 2 Butuh 1 Baris Pembersihan**:
   - `dart format` PASS (0 files changed).
   - `flutter analyze` butuh penghapusan baris 19 (`final user = state.currentUser;`) di `home_screen.dart`.

---

## 5. VERIFICATION METHOD

Untuk memverifikasi secara independen temuan-temuan di atas, jalankan instruksi berikut:

1. **Verifikasi Quality Gate 1 (Dart Format)**:
   ```powershell
   Set-Location c:\T\Cilalutask\cilalutask_mobile
   dart format --output=none --set-exit-if-changed .
   ```
   *Ekspektasi*: Exit code 0, 0 files changed.

2. **Verifikasi Quality Gate 2 (Flutter Analyze)**:
   ```powershell
   Set-Location c:\T\Cilalutask\cilalutask_mobile
   flutter analyze
   ```
   *Ekspektasi*: Menampilkan 1 warning `unused_local_variable` di `lib\screens\home\home_screen.dart:19:11`.

3. **Verifikasi Dead Mock Data & Divisi**:
   ```powershell
   # Bukti tidak adanya import kEmployeePerformance di luar mock_data.dart
   Select-String -Path "c:\T\Cilalutask\cilalutask_mobile\lib\*.dart", "c:\T\Cilalutask\cilalutask_mobile\lib\**\*.dart" -Pattern "kEmployeePerformance"
   # Bukti residu 'IT & Development'
   Select-String -Path "c:\T\Cilalutask\cilalutask_mobile\lib\data\mock_data.dart" -Pattern "IT & Development"
   ```

4. **Verifikasi Nilai CompletionRate (Bukan Desimal 0.25 melainkan 25.0)**:
   ```powershell
   Set-Location c:\T\Cilalutask\cilalutask_mobile
   flutter test test/task_metrics_and_functional_fixes_test.dart
   ```
   *Ekspektasi*: 11 tests passed. Baris 137 menegaskan `expect(metrics.completionRate, 50.0);` (bukan 0.5).

5. **Verifikasi Bug Formula Efisiensi**:
   Buka `cilalutask_mobile/lib/screens/home/home_screen.dart` baris 180 dan amati ekspresi `(metrics.completionRate * 100).round()`.
