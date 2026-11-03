## 2026-11-03T02:00:37Z
You are dm_worker_2 (Data Master Replacement Worker).
Your working directory is: c:\T\Cilalutask\.agents\teamwork\dm_worker_2
Your parent is: orchestrator_datamaster (Conv ID: 1d912ce8-fd6e-4794-86ba-c3cd76af91eb).

Read the following reference files:
- c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md
- c:\T\Cilalutask\.agents\teamwork\orchestrator_datamaster\DISPATCH.md
- c:\T\Cilalutask\.agents\teamwork\orchestrator_datamaster\SCOPE.md
- c:\T\Cilalutask\.agents\teamwork\dm_explorer_1\handoff.md
- c:\T\Cilalutask\.agents\teamwork\dm_explorer_2\handoff.md
- c:\T\Cilalutask\.agents\teamwork\dm_explorer_3\handoff.md
- c:\T\Cilalutask\QA_Report.md (Bagian 4.4 dan Bagian 5)

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Context:
Your predecessor dm_worker_1 already began work and created `scripts/verify_data_integrity.ts` and `cilalutask_mobile/test/data_integrity_audit_test.dart`. You are taking over to verify all changes, complete any missing items, run the full verification test suites, and draft `DATA_MASTER_AUDIT_REPORT.md`.

File Write Ownership:
You have exclusive write ownership of:
- `src/data/mockData.ts`
- `src/types.ts`
- `src/components/screens/HomeScreen.tsx`
- `src/components/screens/TasksScreen.tsx`
- `src/components/screens/SopScreen.tsx`
- `src/components/modals/UploadSopModal.tsx`
- `cilalutask_mobile/lib/data/mock_data.dart`
- `cilalutask_mobile/lib/screens/home/home_screen.dart`
- `package.json`
- `scripts/verify_data_integrity.ts`
- `cilalutask_mobile/test/data_integrity_audit_test.dart`
- `DATA_MASTER_AUDIT_REPORT.md`

Tasks:
1. Verify & finalize changes across Web & Mobile per SCOPE.md:
   - R1: Dynamic SOP denominator across web (`mockData.ts`, `UploadSopModal.tsx`) & mobile (`mock_data.dart`). In `home_screen.dart`: line 180 fix math bug (`metrics.completionRate.round()`), line 19 remove unused `user` variable. In web: fix DEF-01, DEF-02, DEF-03, DEF-04, DEF-06, DEF-07.
   - R2: Multi-tenant schema parity (`Company` interface in `src/types.ts`, optional `companyCode` on `Task` and `SOPDocument`, `email` on `Assignee` and employees in `mockData.ts`).
   - R3: Dead mock data (`kEmployeePerformance`, `kDivisionProductivity`) purged from `mock_data.dart`; division naming 100% standardized to `'IT & Tech'` (replacing `'IT & Development'`).
   - R5: Automated test suites:
     - Ensure `scripts/verify_data_integrity.ts` is complete and runs cleanly via `npx tsx scripts/verify_data_integrity.ts`.
     - Ensure `"test:integrity": "tsx scripts/verify_data_integrity.ts"` is in `package.json`.
     - Ensure `cilalutask_mobile/test/data_integrity_audit_test.dart` is complete and runs cleanly via `flutter test test/data_integrity_audit_test.dart`.
2. Compile `DATA_MASTER_AUDIT_REPORT.md` at project root covering:
   - Executive Summary
   - Audit Rekonsiliasi & Penanganan Cacat Data (SOP Denominator, status tugas selesai, bug formula 2500% -> 25%, division naming)
   - Sinkronisasi Skema Multi-Tenant (Firestore sub-collection architecture, local storage prefixing, web types parity)
   - Pembersihan Dead Mock Data & Standardisasi Master Data
   - Hasil Eksekusi Test Suite Otomatis (verifikasi web & mobile quality gates)
   - Panduan Kolaborasi Tim Dev (Web & Mobile)
3. Execute and document all verification commands:
   - `npx tsx scripts/verify_data_integrity.ts`
   - `npm run lint`
   - `npm run build`
   - In `cilalutask_mobile`:
     - `dart format --output=none --set-exit-if-changed .`
     - `flutter analyze`
     - `flutter test test/data_integrity_audit_test.dart`
     - `flutter test`

Report all results in `c:\T\Cilalutask\.agents\teamwork\dm_worker_2\handoff.md` and send a completion message to your parent.
