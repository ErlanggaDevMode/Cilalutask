# Dispatch for Worker 2 (Mobile Testing: Quality Gates & Automated Suites)

## Mandatory Reading
Read `c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md` and `c:\T\Cilalutask\PROJECT.md`.
Also read Explorer 2 & 3 findings at:
- `c:\T\Cilalutask\.agents\teamwork\teamwork_explorer_survey_2\handoff.md`
- `c:\T\Cilalutask\.agents\teamwork\teamwork_explorer_survey_3\handoff.md`

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Working Directory
`c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2`

## Scope & Objective
Perform actual, comprehensive QA testing of the Cilalutask Mobile application (`cilalutask_mobile/`):
1. **Gate 1: Format Verification**:
   - Run `dart format --output=none --set-exit-if-changed .` inside `cilalutask_mobile`.
   - Record exact output and exit code (verify if `lib/state/notification_controller.dart` fails formatting).
2. **Gate 2: Static Code Analysis**:
   - Run `flutter analyze` inside `cilalutask_mobile`.
   - Record exact output and exit code.
3. **Gate 3: Automated Test Execution**:
   - Run `flutter test` across the full test suite (15 test suites).
   - Execute specific suite runs to capture granular results for:
     - Pure business logic & models (`pure_business_logic_and_models_test.dart`)
     - State controllers (`task_controller_test.dart`, `company_controller_test.dart`, etc.)
     - Security, auth & multi-tenancy (`security_and_auth_test.dart`, `repository_test_doubles_test.dart`)
     - Performance, offline sync & UI responsiveness (`performance_and_offline_test.dart`, `ui_ux_quality_test.dart`)
     - End-to-End flow (`integration_main_user_flow_test.dart`)
   - Record exact test counts, pass/fail statistics, execution times, and coverage details.
4. **Deliverable**:
   - Document the structured testing procedure, test steps, commands, expected results, actual execution outputs, and status (Pass / Fail) with clear evidence in `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2\mobile_test_results.md` and your `handoff.md`.


## 2026-11-02T18:08:29Z
You are Worker 2 (Mobile QA Execution Specialist).
Your working directory is c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2.
You MUST read c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md before starting work.
Also read your dispatch task at c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2\DISPATCH.md.
Reference PROJECT.md at c:\T\Cilalutask\PROJECT.md and Explorer reports at:
- c:\T\Cilalutask\.agents\teamwork\teamwork_explorer_survey_2\handoff.md
- c:\T\Cilalutask\.agents\teamwork\teamwork_explorer_survey_3\handoff.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope & Task:
1. Execute Mobile Quality Gates in `cilalutask_mobile`:
   - Gate 1: `dart format --output=none --set-exit-if-changed .` (record output, exit code, and verify formatted/unformatted files).
   - Gate 2: `flutter analyze` (record output and exit code).
   - Gate 3: `flutter test` across all 15 suites and 96 test cases.
   - Run granular test suites to collect precise test cases, pass/fail counts, execution times, and assertions for:
     * Pure business logic & models (`test/pure_business_logic_and_models_test.dart`)
     * State controllers (`test/task_controller_test.dart`, `test/company_controller_test.dart`, `test/sop_controller_test.dart`, `test/chat_controller_test.dart`, `test/notification_controller_test.dart`)
     * Security, auth & multi-tenancy (`test/security_and_auth_test.dart`, `test/repository_test_doubles_test.dart`)
     * Performance & UI responsiveness (`test/performance_and_offline_test.dart`, `test/ui_ux_quality_test.dart`, `test/widget_test.dart`)
     * End-to-End user flow (`test/integration_main_user_flow_test.dart`)
2. Document all test procedures, steps, commands, expected results, actual execution outputs, and Pass/Fail status with clear evidence in:
   - c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2\mobile_test_results.md
   - c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2\handoff.md

Update your progress.md periodically.
When finished, send a message to the orchestrator with your summary and file paths.


## 2026-11-02T18:17:04Z
**Context**: Updated User Instructions (2026-11-02T18:16:01Z)
**Content**: User just issued direct instructions:
"Pastikan seluruh data-data sesuai dengan spesifikasi aplikasi yang seharusnya (konsistensi data, alur bisnis, isolasi multi-tenant, dan integritas database). Jika ada data atau perilaku yang tidak sesuai, catat secara rinci di dalam file QA_Report.md agar dapat segera ditindaklanjuti dan diserahkan ke Tim Dev dan Tim Data Master untuk perbaikan."
**Action**: Please ensure your mobile test results document the multi-tenant isolation, database/data architecture integrity, and business flow results in deep detail for Dev and Data Master teams in your `mobile_test_results.md` and `handoff.md`.


## 2026-11-02T18:19:30Z
**Context**: URGENT Specific Instruction on Data Reconciliation (2026-11-02T18:18:36Z)
**Content**: User mandates:
"Periksa secara teliti perbedaan antara angka metrik/ringkasan dengan data riil pada list/database.
Contoh kasus yang harus dicek: jika di dashboard/ringkasan tertera '34 anggota', namun ketika dicek di daftar anggota ternyata hanya ada 1 orang (atau counter tugas menyebutkan 5 tugas tapi di list berbeda).
Pastikan seluruh penghitungan metrik (jumlah anggota, tugas aktif, review, selesai) cocok persis dengan data aktual. Jika ada ketidakcocokan antara kartu ringkasan dan daftar aslinya, catat sebagai temuan cacat (FAIL) di QA_Report.md!"

**Action**: Specifically audit every summary metric on mobile:
1. Verify `TaskMetricsCalculator` and HomeScreen KPI cards (total tasks, pending, in progress, completed, review) against the actual items in `TaskController.tasks`.
2. Verify TeamScreen employee counts vs actual list in `CompanyController.employees` and join requests.
3. Verify notification badge counts vs actual unread items in `NotificationController.notifications`.
4. Document whether mobile has any hardcoded summary fallbacks or whether it calculates everything dynamically from actual data, and log any discrepancies as FAIL in `mobile_test_results.md`.
