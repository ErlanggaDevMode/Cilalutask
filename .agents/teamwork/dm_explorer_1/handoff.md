# Laporan Investigasi Lapisan Data Web Cilalutask (`src/`)

**ID Agen**: dm_explorer_1 (Web Data Explorer)  
**Parent**: orchestrator_datamaster (Conv ID: `1d912ce8-fd6e-4794-86ba-c3cd76af91eb`)  
**Tanggal**: 2026-11-02  
**Lingkup Investigasi**: `c:\T\Cilalutask\src\` (Web React SPA Data Layers & UI Metrics)  
**Dokumen Referensi**: `QA_Report.md` (Bagian 4.4, DEF-01, DEF-02, DEF-03, DEF-04, DEF-07, DEF-08, DEF-09, DEF-11, DEF-13)

---

## 1. Observation (Hasil Observasi Langsung)

Berikut adalah kutipan langsung, nomor baris, dan bukti empiris dari berkas-berkas di `c:\T\Cilalutask\src\`:

### 1.1 `src/data/mockData.ts`
1. **Inkonsistensi Nama Divisi (DEF-08)**:
   - Baris 419 (`EMPLOYEE_PERFORMANCE` - Kevin Maulana):
     ```ts
     division: 'IT & Development',
     ```
   - Baris 430 (`DIVISION_PRODUCTIVITY`):
     ```ts
     { name: 'IT & Development', percent: 91, colorClass: 'bg-blue-600', textClass: 'text-blue-600' },
     ```
   - Kontrak tipe di `src/types.ts` baris 3 dan entri `EMPLOYEES` baris 19 menetapkan:
     ```ts
     export type DivisionType = 'Semua' | 'Operasional' | 'IT & Tech' | 'Pemasaran' | 'Finance & Akuntansi';
     ```

2. **Penggelembungan Data Leaderboard / Performa Karyawan (DEF-09)**:
   - Baris 380–425 (`EMPLOYEE_PERFORMANCE`):
     - Ahmad Fauzi: `completedTasks: 28`
     - Rian Dermawan: `completedTasks: 22`
     - Nadia Salsabila: `completedTasks: 24`
     - Kevin Maulana: `completedTasks: 19`
     - **Total Akumulasi Tugas Selesai**: `28 + 22 + 24 + 19 = 93 tugas`.
   - Data riil pada `INITIAL_TASKS` (baris 66–217) hanya memiliki **8 tugas total**:
     - Status `'Dalam Proses'`: 5 tugas (`tsk-001`, `tsk-002`, `tsk-003`, `tsk-004`, `tsk-005`)
     - Status `'Belum Dimulai'`: 1 tugas (`tsk-008`)
     - Status `'Selesai'`: **hanya 2 tugas**, yaitu `tsk-006` (Ahmad Fauzi) dan `tsk-007` (Dina Putri).
   - Kevin Maulana, Nadia Salsabila, dan Rian Dermawan memiliki **0 tugas berstatus 'Selesai'** di `INITIAL_TASKS`.
   - Dina Putri (yang telah menyelesaikan 1 tugas) tidak dimasukkan sama sekali dalam `EMPLOYEE_PERFORMANCE`.

3. **Status Denominator & Counter Pembaca SOP**:
   - Baris 253–275 (`INITIAL_SOPS` - `sop-002`):
     ```ts
     readProgressPercent: 83,
     complianceRatioText: '83% Karyawan sudah membaca & menyetujui',
     readTeamCount: '5/6 Tim',
     ```
   - `sop-003` memiliki `readTeamCount: 'Lengkap'`.
   - `sop-001`, `sop-004`, dan `sop-005` tidak mendefinisikan `readTeamCount` atau `complianceRatioText`.
   - Pada `src/components/modals/UploadSopModal.tsx` baris 49:
     ```ts
     readTeamCount: `0/${EMPLOYEES.length} Tim`,
     complianceRatioText: '0% Karyawan terverifikasi',
     ```
     Meskipun angka `34 Tim` telah digantikan oleh `EMPLOYEES.length` (6), nilai ini bersifat statis terhadap array konstan `EMPLOYEES` (6 karyawan) dan tidak terikat dengan data multi-tenant dinamis (misalnya tenant baru dengan 1 karyawan).

4. **Dead Mock Data & Stale References**:
   - `INITIAL_ACTIVITIES` (baris 345–377):
     - `act-1` (baris 350-351): `actionPrefix: 'menyelesaikan SOP', targetObject: 'Penerimaan Barang Baru.'`. Dokumen SOP "Penerimaan Barang Baru" **tidak pernah ada** dalam `INITIAL_SOPS`.
     - `act-2` (baris 360-362): `targetObject: 'Desain Kemasan'`. Judul tugas aktual pada `tsk-007` adalah `"Desain Banner Promosi & Mockup Kemasan Baru"`.
     - `act-3` (baris 372): `targetObject: 'Rekonsiliasi Pajak Bulanan.'`. Judul tugas aktual pada `tsk-004` adalah `"Rekonsiliasi Pajak Bulanan Divisi Finance"`.
   - `CURRENT_USER` (baris 3–11):
     - Email memiliki salah ketik (typo): `'sarah.pratama@cilulataks.id'` (`cilulataks` alih-alih `cilalutask`).
     - Divisi tercatat `'Operations & Strategy'`, di luar kesepakatan `DivisionType`.
     - Nilai metrik statis: `teamEfficiencyPercent: 94` (padahal rasio penyelesaian tugas aktual adalah 25.0% atau 2 dari 8).
   - `NOTIFICATIONS_DATA` (baris 434–459):
     - Berisi 3 notifikasi yang hanya diimpor oleh `TeamScreen.tsx`. Notifikasi ini terisolasi secara lokal, menyebabkan `App.tsx` memberikan nilai statis `unreadNotifsCount={3}` ke `Header.tsx`.

---

### 1.2 `src/types.ts` dan Ketiadaan Multi-Tenant State
1. **Ketiadaan Model Multi-Tenant / `companyCode` (DEF-13)**:
   - `src/types.ts` sama sekali tidak memiliki interface `Company`, `Tenant`, atau `JoinRequest`.
   - Tidak ada properti `companyCode` pada interface `Task`, `SOPDocument`, `Assignee`, `ActivityItem`, maupun `EmployeePerformance`.
   - Seluruh state di `src/App.tsx` (baris 31–33) disimpan hanya dalam React `useState` lokal di memori:
     ```tsx
     const [tasks, setTasks] = useState<Task[]>(INITIAL_TASKS);
     const [sops, setSops] = useState<SOPDocument[]>(INITIAL_SOPS);
     const [activities, setActivities] = useState<ActivityItem[]>(INITIAL_ACTIVITIES);
     ```
   - Tidak ada React Context (`CompanyContext`, `TaskContext`, atau `AuthContext`), tidak ada modul LocalStorage, dan tidak ada integrasi Firestore seperti pada aplikasi mobile (`cilalutask_mobile/lib/repositories/cilalu_repository.dart`).

2. **Mekanisme Counter Pembaca SOP di State**:
   - Di `src/App.tsx` baris 166–179 (`handleConfirmReadSop`):
     ```tsx
     const handleConfirmReadSop = (sopId: string) => {
       setSops((prev) =>
         prev.map((s) => {
           if (s.id === sopId) {
             return {
               ...s,
               isReadByMe: true,
               readProgressPercent: Math.min(100, (s.readProgressPercent || 94) + 6),
               isUrgentMandatory: false,
             };
           }
           return s;
         })
       );
       ...
     ```
   - Mutasi state hanya menambahkan angka statis `+6%` ke `readProgressPercent`. Properti `readTeamCount` dan `complianceRatioText` **tidak pernah diperbarui secara dinamis** saat pengguna mengonfirmasi telah membaca SOP.

---

### 1.3 Cacat UI Terkait Metrik & Data

1. **`src/components/screens/HomeScreen.tsx`**:
   - **Baris 48 (DEF-03)**:
     ```tsx
     const completedCount = 42; // exactly as shown in screenshot
     ```
     Kartu "Selesai" mencetak statis `42` padahal data riil `INITIAL_TASKS` hanya memiliki 2 tugas selesai.
   - **Baris 158 (DEF-02)**:
     ```tsx
     <span className="text-2xl font-bold tracking-tight text-[#0B1C30]">{activeCount || 24}</span>
     ```
     Jika `activeCount === 0`, nilai dipalsukan menjadi `24`.
   - **Baris 49–50**:
     ```tsx
     const reviewCount = tasks.filter((t) => t.needsReview).length || 7;
     const nearDeadlineCount = tasks.filter((t) => t.isUrgentDeadline).length || 3;
     ```
     Nilai nol dipalsukan menjadi `7` dan `3`.
   - **Baris 162 & 181**: Subteks kartu `"4 tugas baru"` dan `"+18% vs lalu"` berupa string literal konstan yang tidak reaktif.
   - **Baris 309 (DEF-01)**:
     ```tsx
     <span className="text-[11px] px-2 py-0.5 bg-slate-100 text-slate-600 rounded-md font-medium">
       {task.division.includes('Finance') ? 'Div. Finance' : 'Div. IT Core'}
     </span>
     ```
     Logika biner ini menyebabkan tugas divisi Operasional (`tsk-003` - Budi Santoso) dan Pemasaran salah terlabeli sebagai `'Div. IT Core'`.

2. **`src/components/screens/TasksScreen.tsx`**:
   - **Baris 44–46 (DEF-04)**:
     ```tsx
     const notStartedCount = tasks.filter((t) => t.status === 'Belum Dimulai').length || 5;
     const inProgressCount = tasks.filter((t) => t.status === 'Dalam Proses').length || 14;
     const completedCount = tasks.filter((t) => t.status === 'Selesai').length || 28;
     ```
     Penggunaan fallback `||` memalsukan nilai badge status tab jika bernilai 0.
   - **Baris 57**: Filter divisi menggunakan manipulasi string rentan: `!task.division.includes(selectedDivision.replace(' & Tech', ''))`.

3. **`src/components/screens/SopScreen.tsx`**:
   - **Baris 72 (DEF-06)**:
     ```tsx
     const urgentSop = sops.find((s) => s.isUrgentMandatory) || sops[0];
     ```
     Fallback `|| sops[0]` memaksa banner peringatan merah tetap muncul menampilkan `sops[0]` meskipun tidak ada SOP berstatus `isUrgentMandatory: true`.
   - **Baris 240 (DEF-07)**:
     ```tsx
     <span className="px-2 py-0.5 rounded-full bg-blue-100 text-[#0051D5] text-[11px] font-bold">
       14 Aktif
     </span>
     ```
     String literal hardcoded `"14 Aktif"` padahal jumlah dokumen SOP aktual hanya 5.
   - **Baris 101–112 & 356–361 (DEF-10)**:
     Tombol Bookmark header, History revisi, dan Share SOP tidak memiliki event handler `onClick`.

4. **`src/components/screens/ReportsScreen.tsx`**:
   - **Baris 26–33 & 63–80 (DEF-12)**:
     State `selectedTimeRange` berubah saat pengguna mengklik pill waktu, namun seluruh angka metrik (Tingkat Penyelesaian `92.4%`, Ketepatan Waktu `88%`, Rata-rata Durasi `1.8 Hari`) dan grafik produktivitas bersifat statis dan tidak merespons perubahan filter.
   - **Baris 216–218 (DEF-10)**:
     Tombol `"Lihat Semua"` pada Rekap Kinerja Karyawan tidak memiliki event handler `onClick`.
   - **Baris 311**: Teks narasi AI/rekomendasi menyebutkan angka statis `(rata-rata 23 tugas/karyawan)` dan keterlambatan Kevin Maulana yang tidak terikat data dinamis.

5. **`src/components/modals/ReviewTaskModal.tsx`**:
   - **Baris 107–111 (DEF-11)**:
     ```tsx
     <button
       onClick={onClose}
       className="py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
     >
       Minta Revisi
     </button>
     ```
     Tombol "Minta Revisi" hanya memanggil `onClose`, tanpa melakukan mutasi status tugas (misalnya mengubah status atau menghilangkan flag `needsReview`).

6. **`src/App.tsx` & `src/components/Header.tsx`**:
   - **Baris 275 (DEF-05)**:
     `<Header currentTab={currentTab} unreadNotifsCount={3} ... />`
     Memberikan nilai statis `3` ke Header, sehingga badge merah lonceng notifikasi tidak sinkron dengan status baca di `TeamScreen.tsx`.

---

## 2. Logic Chain (Alur Penalaran dari Bukti ke Kesimpulan)

1. **Premis 1 (DEF-03 & DEF-09 Rekonsiliasi 3-Arah)**:
   - Bukti 1A: Di `HomeScreen.tsx:48`, `completedCount` dideklarasikan secara konstan bernilai `42`.
   - Bukti 1B: Di `mockData.ts:380-425`, empat karyawan pada `EMPLOYEE_PERFORMANCE` memiliki total tugas selesai sebanyak `93` (28 + 22 + 24 + 19).
   - Bukti 1C: Di `mockData.ts:66-217` (`INITIAL_TASKS`), hanya ada `2` tugas dengan `status === 'Selesai'`.
   - *Inferensi*: Terjadi diskrepansi data 3-arah yang sangat parah (42 vs 93 vs 2). Angka 42 dan 93 adalah artefak mockup UI prototipe awal yang tidak pernah diintegrasikan dengan model data tugas aktual.

2. **Premis 2 (DEF-01 & DEF-08 Inkonsistensi Divisi)**:
   - Bukti 2A: `types.ts:3` menetapkan union type resmi divisi teknologi adalah `'IT & Tech'`.
   - Bukti 2B: `mockData.ts:419, 430` menggunakan `'IT & Development'` untuk Kevin Maulana dan produktivitas divisi.
   - Bukti 2C: `HomeScreen.tsx:309` menggunakan kondisi biner ternary `task.division.includes('Finance') ? 'Div. Finance' : 'Div. IT Core'`, yang secara keliru melabeli tugas Operasional milik Budi Santoso sebagai `'Div. IT Core'`.
   - *Inferensi*: Developer prototipe menggunakan nama divisi non-standar dan jalan pintas ternary. Akibatnya, filter divisi gagal mencocokkan data dan tampilan antarmuka memperlihatkan nama divisi yang keliru.

3. **Premis 3 (DEF-02 & DEF-04 Pemalsuan Angka Nol)**:
   - Bukti 3A: JavaScript mengevaluasi angka `0` sebagai *falsy*.
   - Bukti 3B: Ekspresi `activeCount || 24` dan `tasks.filter(...).length || 5` mengevaluasi angka 0 menjadi nilai cadangan di sebelah kanan operand.
   - *Inferensi*: Penggunaan operator logical OR (`||`) alih-alih nullish coalescing (`??`) atau evaluasi murni menyebabkan kondisi ketika tugas bernilai 0 dipalsukan menjadi angka non-nol (24, 5, 14, 28).

4. **Premis 4 (Denominator SOP & Multi-Tenancy)**:
   - Bukti 4A: Di mobile, denominator pernah tertulis `34 Tim` (misal `32/34 Tim` dan `0/34 Tim`).
   - Bukti 4B: Di web, `mockData.ts:260` menggunakan `'5/6 Tim'` dan `UploadSopModal.tsx:49` menggunakan `'0/${EMPLOYEES.length} Tim'`.
   - Bukti 4C: `types.ts` tidak memiliki properti `companyCode`, dan `App.tsx` tidak memiliki mekanisme pemisahan organisasi/tenant.
   - *Inferensi*: Web mengadopsi denominator berbasis `EMPLOYEES.length` (6), namun karena array `EMPLOYEES` di-hardcode di level modul, denominator ini tidak adaptif terhadap data multi-tenant (misal perusahaan baru yang hanya memiliki 1 admin). Selain itu, fungsi `handleConfirmReadSop` tidak menghitung ulang rasio pembaca tim secara dinamis.

---

## 3. Caveats (Batasan & Asumsi)

1. **Aplikasi Web Merupakan Client-Side State Prototype**:
   - Seluruh logika state web berada di dalam React `useState` pada komponen `App.tsx` tanpa koneksi backend aktif, REST API, atau Firebase Firestore (berbeda dengan `cilalutask_mobile/` yang telah memiliki lapisan repositori lengkap).
   - Pengujian statis (`npm run lint` / `tsc --noEmit`) saat ini berstatus PASS (exit code 0), sehingga setiap modifikasi tipe harus mempertahankan kepatuhan TypeScript tanpa menimbulkan type errors.

2. **Dua Mode Penyelesaian untuk DEF-09**:
   - *Opsi A*: Menghitung `completedTasks` pada `EMPLOYEE_PERFORMANCE` secara dinamis dari `tasks.filter(t => t.status === 'Selesai' && t.assignee.id === emp.id).length`. Pada dataset awal, Ahmad Fauzi akan bernilai 1, Dina Putri 1, dan lainnya 0.
   - *Opsi B*: Menambahkan entri tugas selesai masa lalu ke dalam `INITIAL_TASKS` agar riwayat tugas riil cocok dengan angka leaderboard.
   - *Rekomendasi*: Opsi A lebih disarankan karena menjamin konsistensi jangka panjang secara reaktif tanpa risiko pemalsuan data.

---

## 4. Conclusion (Kesimpulan & Rekomendasi Solusi Teknis)

Berikut adalah daftar temuan utama dan rancangan solusi teknis terstruktur untuk Tim Pengembang dan Tim Data Master:

| ID Cacat / Temuan | Berkas & Baris | Kondisi Aktual Saat Ini | Solusi Teknis yang Direkomendasikan |
| :--- | :--- | :--- | :--- |
| **DEF-01** | `HomeScreen.tsx:309` | Ternary biner menampilkan `'Div. IT Core'` untuk tugas Operasional | Ganti dengan interpolasi dinamis: `<span>Div. {task.division}</span>` |
| **DEF-02** | `HomeScreen.tsx:158` | `{activeCount \|\| 24}` memalsukan 0 tugas menjadi 24 | Ganti dengan `{activeCount ?? 0}` atau langsung `{activeCount}` |
| **DEF-03** | `HomeScreen.tsx:48` | `const completedCount = 42;` statis hardcoded | Hitung dinamis: `tasks.filter(t => t.status === 'Selesai').length` |
| **DEF-04** | `TasksScreen.tsx:44-46` | Fallback `\|\| 5`, `\|\| 14`, `\|\| 28` | Hapus seluruh fallback statis, gunakan murni hasil `.length` |
| **DEF-05** | `App.tsx:275`, `TeamScreen.tsx:25` | State notifikasi terisolasi di `TeamScreen`, Header hardcoded 3 | Lift state `notifications` ke `App.tsx` dan teruskan `unreadCount` dinamis ke Header |
| **DEF-06** | `SopScreen.tsx:72` | Fallback `\|\| sops[0]` menampilkan banner urgent permanen | Hapus `\|\| sops[0]`, render `<UrgentBanner>` hanya jika `urgentSop` ditemukan |
| **DEF-07** | `SopScreen.tsx:240` | Badge `"14 Aktif"` statis hardcoded | Ganti dengan interpolasi dinamis: `{filteredSops.length} Aktif` |
| **DEF-08** | `mockData.ts:419, 430` | `'IT & Development'` melanggar `DivisionType` | Ubah menjadi `'IT & Tech'` di seluruh entri mock data |
| **DEF-09** | `mockData.ts:380-425` | Total 93 selesai di leaderboard vs 2 di `INITIAL_TASKS` | Hitung metrik leaderboard dari array tasks atau selaraskan nilai seed mock |
| **DEF-10** | `ReportsScreen:217`, `SopScreen:101, 356` | Tombol inert tanpa event listener `onClick` | Pasang handler interaktif / toast notifikasi |
| **DEF-11** | `ReviewTaskModal.tsx:107` | Tombol "Minta Revisi" hanya memanggil `onClose` | Tambahkan callback `onRequestRevision` untuk memperbarui status tugas |
| **DEF-12** | `ReportsScreen.tsx:64-80` | Filter rentang waktu tidak mengubah metrik laporan | Kaitkan data metrik agregat dengan rentang waktu yang dipilih |
| **DEF-13** | `types.ts`, `App.tsx` | Ketiadaan isolasi multi-tenant dan `companyCode` | Tambahkan model `Company` & `companyCode`, serta tenant switcher pada modal profil |
| **SOP Denominator** | `mockData.ts:260`, `UploadSopModal.tsx:49` | Denominator mengikat `EMPLOYEES.length` konstan | Buat perhitungan pembaca tim dinamis terhadap daftar anggota aktif perusahaan |

---

## 5. Verification Method (Metode Verifikasi Independen)

Untuk memverifikasi kebenaran laporan ini secara independen, jalankan langkah-langkah berikut:

1. **Pemeriksaan Statis & Kompilasi TypeScript**:
   ```powershell
   cd c:\T\Cilalutask
   npm run lint
   ```
   *Ekspektasi*: Exit code `0` tanpa error diagnostik.

2. **Verifikasi String Hardcoded melalui Pencarian Pola (Ripgrep)**:
   - Verifikasi DEF-03 (`completedCount = 42`):
     ```powershell
     rg "completedCount = 42" src
     ```
   - Verifikasi DEF-02 (`activeCount || 24`):
     ```powershell
     rg "activeCount \|\| 24" src
     ```
   - Verifikasi DEF-07 (`14 Aktif`):
     ```powershell
     rg "14 Aktif" src
     ```
   - Verifikasi DEF-08 (`IT & Development`):
     ```powershell
     rg "IT & Development" src
     ```
   - Verifikasi DEF-04 (`|| 5`, `|| 14`, `|| 28`):
     ```powershell
     rg "length \|\| 5" src
     ```
   - Verifikasi DEF-01 (Ternary divisi biner):
     ```powershell
     rg "task\.division\.includes\('Finance'\)" src
     ```

3. **Verifikasi Perhitungan Data Aktual di Node.js / REPL**:
   Eksekusi skrip evaluasi cepat untuk memvalidasi rekonsiliasi tugas:
   ```powershell
   node -e "const tasks = require('./src/data/mockData.ts');"
   ```
   Hitung jumlah tugas dengan `status === 'Selesai'` pada `INITIAL_TASKS` untuk memastikan nilai sebenarnya adalah `2`.

4. **Kondisi Invalidasi (Invalidation Conditions)**:
   - Laporan ini menjadi tidak valid apabila skema `INITIAL_TASKS` telah dimutasi oleh tim lain sehingga jumlah tugas selesai bertambah atau berkurang dari `2`.
   - Laporan ini perlu direvisi apabila arsitektur multi-tenant Firestore diinjeksikan ke dalam aplikasi web menggantikan `useState` lokal.
