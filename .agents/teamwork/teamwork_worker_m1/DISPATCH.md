# Dispatch for Worker 1 (Web Testing: Manual Browser & Automated)

## 2026-11-02T18:08:21Z

## Mandatory Reading
Read `c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md` and `c:\T\Cilalutask\PROJECT.md`.
Also read Explorer 1's findings at `c:\T\Cilalutask\.agents\teamwork\teamwork_explorer_survey_1\handoff.md`.

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Working Directory
`c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m1`

## Scope & Objective
Perform actual, comprehensive QA testing of the Cilalutask Web application (`src/`):
1. **Manual Browser UI & Interaction Testing**:
   - Access the running application at `http://localhost:56855`.
   - Test all 5 main views (Beranda, Tugas, SOP, Laporan, Tim & Notif).
   - Test UI controls, device frame switcher (Smartphone vs Fullscreen), and bottom navigation.
   - Test task operations: Create Task modal form, subtask progress update modal, review modal.
   - Test SOP operations: SOP search, category filters, urgent banner, SOP reader modal, digital sign-off, upload SOP modal.
   - Test Laporan operations: time range filters, metrics, division productivity bars, export modal.
   - Test Tim & Notif: employee directory, 'Beri Tugas' shortcut, broadcast modal, notification center with mark-as-read.
   - Specifically verify known bugs identified by Explorer 1 (e.g., Division label ternary bug in HomeScreen:309, fallback counts || 24, unread count hardcoding, inert buttons).
2. **Automated Web Checks**:
   - Run `npm run lint` (`tsc --noEmit`) and record output.
   - Run `npm run build` (`vite build`) and record output.
   - Run node/tsx verification for data models and headless component rendering (`react-dom/server`).
3. **Deliverable**:
   - Document the structured testing procedure, test steps, inputs, expected results, actual results, and status (Pass / Fail) with clear evidence chains in `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m1\web_test_results.md` and your `handoff.md`.

## 2026-11-02T18:16:55Z
**Context**: Updated User Instructions
**Content**: "Pastikan seluruh data-data sesuai dengan spesifikasi aplikasi yang seharusnya (konsistensi data, alur bisnis, isolasi multi-tenant, dan integritas database). Jika ada data atau perilaku yang tidak sesuai, catat secara rinci di dalam file QA_Report.md agar dapat segera ditindaklanjuti dan diserahkan ke Tim Dev dan Tim Data Master untuk perbaikan."
**Action**: Web testing must specifically evaluate data consistency, business flow integrity, and mock data validity, documenting any discrepancies or defects with high granularity for Dev and Data Master teams in `web_test_results.md` and `handoff.md`.

## 2026-11-02T18:19:24Z
**Context**: URGENT Specific Instruction on Data Reconciliation
**Content**: "Periksa secara teliti perbedaan antara angka metrik/ringkasan dengan data riil pada list/database. Contoh kasus yang harus dicek: jika di dashboard/ringkasan tertera '34 anggota', namun ketika dicek di daftar anggota ternyata hanya ada 1 orang (atau counter tugas menyebutkan 5 tugas tapi di list berbeda). Pastikan seluruh penghitungan metrik (jumlah anggota, tugas aktif, review, selesai) cocok persis dengan data aktual. Jika ada ketidakcocokan antara kartu ringkasan dan daftar aslinya, catat sebagai temuan cacat (FAIL) di QA_Report.md!"
**Action**: Specifically audit every summary card and badge vs the real array length in `src/` and on `http://localhost:56855`. Document all count mismatches as explicit FAIL defect items.
