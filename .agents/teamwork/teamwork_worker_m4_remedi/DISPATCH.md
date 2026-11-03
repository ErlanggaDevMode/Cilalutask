# Dispatch for Worker 4 (Quality Remediation & Fix Specialist)

## Mandatory Reading
Read:
- `c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md` (Including Follow-up 18:46:28Z)
- Reviewer 1 findings: `c:\T\Cilalutask\.agents\teamwork\teamwork_reviewer_1\handoff.md`
- Target Deliverables: `c:\T\Cilalutask\QA_Report.md`, `src/components/modals/UploadSopModal.tsx`, `cilalutask_mobile/lib/widgets/modals/upload_sop_bottom_sheet.dart`

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Working Directory
`c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m4_remedi`

## Scope & Objective
Resolve the issues identified by Reviewer 1 and align with user follow-up (18:46:28Z):
1. **Fix `src/components/modals/UploadSopModal.tsx`**:
   - Check line 49 and surroundings. Fix any missing backticks or syntax error so that `npm run lint` (`tsc --noEmit`) passes cleanly with exit code 0.
2. **Fix `cilalutask_mobile/lib/widgets/modals/upload_sop_bottom_sheet.dart`**:
   - Fix line 87 or `readTeamCount` so that `state` is properly accessed (e.g. `AppStateScope.of(context).employees.length` or `widget.state.employees.length`) and does not produce compilation errors in `flutter test`.
3. **Execute Verification Commands**:
   - `npm run lint` (`tsc --noEmit`) -> MUST exit code 0.
   - `npm run build` (`vite build`) -> MUST exit code 0.
   - `cd cilalutask_mobile; dart format .` -> format all files.
   - `cd cilalutask_mobile; flutter analyze` -> MUST exit code 0 ("No issues found!").
   - `cd cilalutask_mobile; flutter test` -> MUST pass 100% (96/96 passed).
4. **Update `c:\T\Cilalutask\QA_Report.md`**:
   - Correct recommendation code snippet at line 698 so it shows the proper syntax `AppStateScope.of(context).employees.length`.
   - Incorporate the user follow-up (18:46:28Z) noting that TC-02, TC-03, TC-04 initial discrepancies and M-DEF-05 were documented as FAIL, and record the verified remediations.
5. Document all actions, command outputs, and verification results in `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m4_remedi\handoff.md`.
Send message back when done.


## 2026-11-02T18:55:07Z
You are Worker 4 (Quality Remediation & Fix Specialist).
Your working directory is c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m4_remedi.
You MUST read c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md before starting work.
Also read your dispatch task at c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m4_remedi\DISPATCH.md.
Review Reviewer 1's findings at c:\T\Cilalutask\.agents\teamwork\teamwork_reviewer_1\handoff.md.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope & Task:
1. Fix syntax/compilation issues:
   - In `src/components/modals/UploadSopModal.tsx`: fix any syntax error (missing backtick) so `npm run lint` passes with code 0.
   - In `cilalutask_mobile/lib/widgets/modals/upload_sop_bottom_sheet.dart`: fix line 87 (`readTeamCount`) to correctly resolve employee count via `AppStateScope.of(context).employees.length` or `widget.state`.
2. Run full verification:
   - Run `npm run lint` (`tsc --noEmit`) -> verify code 0.
   - Run `npm run build` (`vite build`) -> verify code 0.
   - In `cilalutask_mobile`: Run `dart format .`, `flutter analyze`, and `flutter test` -> verify 100% tests pass.
3. Update `c:\T\Cilalutask\QA_Report.md`:
   - Fix code recommendation snippet at line 698.
   - Incorporate user follow-up (18:46:28Z) on initial FAIL and remediation status for TC-02, TC-03, TC-04, and M-DEF-05.
4. Write handoff report with exact command outputs to `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m4_remedi\handoff.md`.
When finished, send message back to orchestrator.
