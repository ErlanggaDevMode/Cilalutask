# Dispatch for Worker 5 (Mobile Defect Resolution & Quality Gates)

## Mandatory Reading
Read:
- `c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md` (Including Victory Audit feedback)
- `c:\T\Cilalutask\PROJECT.md` § M1
- Target Codebase: `c:\T\Cilalutask\cilalutask_mobile`

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Working Directory
`c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m1_mobile_fix`

## Scope & Objective
1. **Fix Compilation in `test/data_integrity_audit_test.dart`**:
   - Locate line 64:23 (and any other occurrences) where `Company(...)` constructor is called.
   - Provide required parameters: `adminName` (e.g. `'Sarah Pratama'`), `createdAt` (e.g. `DateTime.now()`), and `id` (e.g. `'cmp-001'`).
2. **Verify Mobile Quality Gates**:
   - `upload_sop_bottom_sheet.dart`: ensure `readTeamCount` resolves without undefined identifiers.
   - Run `dart format --output=none --set-exit-if-changed .` -> MUST exit code 0. (Run `dart format .` if any file needs formatting).
   - Run `flutter analyze` -> MUST exit code 0 with 0 issues / 0 errors / 0 warnings.
   - Run `flutter test` -> MUST pass 100% across all suites (including `data_integrity_audit_test.dart`).
3. Document exact commands, outputs, and verification results in `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m1_mobile_fix\handoff.md`.
Send message back when done.


## 2026-11-03T02:16:30Z
You are Worker 5 (Mobile Quality Gate Worker).
Your working directory is c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m1_mobile_fix.
You MUST read c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md before starting work.
Also read your dispatch task at c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m1_mobile_fix\DISPATCH.md.
Reference PROJECT.md at c:\T\Cilalutask\PROJECT.md.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope & Task:
1. Fix compilation in `cilalutask_mobile/test/data_integrity_audit_test.dart`:
   - Line 64:23 (and any other Company instantiation): supply required named arguments `adminName`, `createdAt`, `id` (e.g. `adminName: 'Sarah Pratama', createdAt: DateTime.now(), id: 'cmp-001'`).
2. Verify `upload_sop_bottom_sheet.dart` compiles cleanly without missing getters.
3. Run `dart format --output=none --set-exit-if-changed .` in `cilalutask_mobile`. (If needed, run `dart format .` to format files).
4. Run `flutter analyze` in `cilalutask_mobile` -> verify 0 issues found!
5. Run `flutter test` in `cilalutask_mobile` -> verify 100% tests pass across all test suites!
6. Document all results and exact command outputs in `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m1_mobile_fix\handoff.md`.
When finished, send message back to orchestrator.
