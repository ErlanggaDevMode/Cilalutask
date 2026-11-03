# Task Assignment: Worker M1 (Mobile Defect Implementation & Quality Gates)

- **Role**: teamwork_worker
- **Working directory**: c:\T\Cilalutask\.agents\teamwork\worker_m1
- **Parent**: teamwork_orchestrator (conv id: 24548c72-c8fc-42d0-bd45-af8f08f1722b)
- **Original request**: c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md
- **Project Scope**: c:\T\Cilalutask\PROJECT.md
- **Explorer Reports to Read**:
  - `c:\T\Cilalutask\.agents\teamwork\explorer_m1_1\handoff.md` (M-DEF-01, M-DEF-02, M-DEF-03, unused `user`)
  - `c:\T\Cilalutask\.agents\teamwork\explorer_m1_2\handoff.md` (M-DEF-04 compile blocker & dynamic SOP denominator)
  - `c:\T\Cilalutask\.agents\teamwork\explorer_m1_3\handoff.md` (M-DEF-05 DM isolation & 13px RenderFlex overflow)

## Exclusive Write Ownership
You own files in `cilalutask_mobile/` exclusively. You MUST NOT modify files outside `cilalutask_mobile/`.
Specifically, edit:
1. `cilalutask_mobile/lib/screens/home/home_screen.dart`:
   - Remove unused variable `final user = state.currentUser;` at line 19.
   - At line 180: dynamic efficiency calculation `${metrics.total > 0 ? metrics.completionRate.round() : 100}%`.
   - At line 458: dynamic active task subtext `activeCount > 0 ? '$activeCount tugas berjalan' : '0 tugas aktif'`.
   - At line 511-545: fix 13px RenderFlex overflow on small screen (320x480 dp) by wrapping the title text in `Expanded` with `maxLines: 1` and `TextOverflow.ellipsis`.
2. `cilalutask_mobile/lib/widgets/modals/upload_sop_bottom_sheet.dart`:
   - Fix undefined `state` getter in `_submit()`: retrieve safely via `AppStateScope.maybeOf(context)` and compute dynamic employee denominator `(appState != null && appState.employees.isNotEmpty) ? appState.employees.length : (appState?.isBlankMode == true ? 1 : 6)`.
3. `cilalutask_mobile/lib/data/mock_data.dart`:
   - Reconcile `SOP-CC-012` to `readTeamCount: '5/6 Tim'` and `readProgressPercent: 83`.
4. `cilalutask_mobile/lib/state/notification_controller.dart`:
   - Ensure DM isolation and format compliance.

## Verification Requirements
Run and ensure exit code 0 for all mobile quality gates:
1. `dart format --output=none --set-exit-if-changed .` in `cilalutask_mobile/`
2. `flutter analyze` in `cilalutask_mobile/` (MUST report 0 issues, 0 warnings)
3. `flutter test` in `cilalutask_mobile/` (MUST achieve 100% pass across all tests, 96+ tests)

## MANDATORY INTEGRITY WARNING
> DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Output
Write your handoff report to `c:\T\Cilalutask\.agents\teamwork\worker_m1\handoff.md` with:
- Files modified with diff summaries
- Verification commands executed and their verbatim outputs
- Status of M-DEF-01 through M-DEF-05
Notify parent via `send_message` when done.

## 2026-11-03T02:21:11Z
You are worker_m1, working as teamwork_worker on project Cilalutask Milestone M1.
Your working directory is: c:\T\Cilalutask\.agents\teamwork\worker_m1
Your parent is teamwork_orchestrator (conv id: 24548c72-c8fc-42d0-bd45-af8f08f1722b).

Read your task assignment at c:\T\Cilalutask\.agents\teamwork\worker_m1\DISPATCH.md
Read the user request at c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md
Read PROJECT.md at c:\T\Cilalutask\PROJECT.md
Read explorer reports:
- c:\T\Cilalutask\.agents\teamwork\explorer_m1_1\handoff.md
- c:\T\Cilalutask\.agents\teamwork\explorer_m1_2\handoff.md
- c:\T\Cilalutask\.agents\teamwork\explorer_m1_3\handoff.md

Implement the mobile fixes in cilalutask_mobile/ exclusively:
1. home_screen.dart (remove unused user variable, dynamic efficiency, dynamic active subtext, 13px RenderFlex overflow fix).
2. upload_sop_bottom_sheet.dart (fix undefined state in _submit(), dynamic employee denominator).
3. mock_data.dart (reconcile SOP-CC-012 denominator to 5/6 Tim, 83%).
4. notification_controller.dart (DM isolation & formatting).

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Run all quality gates:
1. dart format --output=none --set-exit-if-changed .
2. flutter analyze (0 issues required)
3. flutter test (100% pass across all 96+ tests)

Write handoff report to c:\T\Cilalutask\.agents\teamwork\worker_m1\handoff.md and notify parent when complete.

