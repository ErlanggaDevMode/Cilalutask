# Dispatch for Worker 6 (Web Defect Resolution Specialist)

## Mandatory Reading
Read:
- `c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md` (Including Victory Audit feedback)
- `c:\T\Cilalutask\PROJECT.md` § M2
- Target Codebase: `c:\T\Cilalutask\src`

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Working Directory
`c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2_web_fix`

## Scope & Objective
Resolve remaining Web defects identified by the Victory Auditor and Reviewer 1:
1. **Fix `src/components/modals/UploadSopModal.tsx`**:
   - Check line 49 and fix template literal / backtick syntax error so `npm run lint` passes without errors.
2. **Fix DEF-05 (Notification Bell Unread Counter)**:
   - In `src/App.tsx` line 275: replace hardcoded `unreadNotifsCount={3}` with dynamic count derived from unread notifications in state (`notifications.filter(n => !n.isRead).length`).
3. **Fix DEF-10 (Inert Buttons)**:
   - In Header (Bookmark, History), SOP (Share), Reports (Lihat Semua), attach active click handlers (e.g. trigger toast or modal).
4. **Fix DEF-11 (Revision Workflow in ReviewTaskModal)**:
   - In `src/components/modals/ReviewTaskModal.tsx` line 107: "Minta Revisi" must actually update task status back to 'Dalam Proses' with revision note or call an `onReject`/`onRevise` prop.
5. **Fix DEF-12 (Reports Time Range Filtering)**:
   - In `src/components/screens/ReportsScreen.tsx`: wire time range pills ('Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Kuartal Ini') to filter tasks by completion date and compute dynamic completion rate.
6. **Fix DEF-13 (Multi-Tenant Context Support)**:
   - In `src/App.tsx`: provide company context (`companyCode: 'CILALU-88'`), company name header pill, and support for clean separation matching mobile.
7. **Verify Quality Gates**:
   - Run `npm run lint` (`tsc --noEmit`) -> MUST exit code 0.
   - Run `npm run build` (`vite build`) -> MUST exit code 0 and build clean `dist/`.
8. Document all code changes and command outputs in `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2_web_fix\handoff.md`.
Send message back when done.


## 2026-11-03T02:16:43Z
You are Worker 6 (Web Defect Remediation Worker).
Your working directory is c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2_web_fix.
You MUST read c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md before starting work.
Also read your dispatch task at c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2_web_fix\DISPATCH.md.
Reference PROJECT.md at c:\T\Cilalutask\PROJECT.md.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope & Task:
1. Fix syntax in `src/components/modals/UploadSopModal.tsx` line 49 so `npm run lint` passes without errors.
2. Fix DEF-05: In `src/App.tsx` line 275, wire `unreadNotifsCount` dynamically from state (`notifications.filter(n => !n.isRead).length`).
3. Fix DEF-10: In Header, SOP, and Reports, wire inert buttons (Bookmark, History, Share, Lihat Semua) to functional toasts or modals.
4. Fix DEF-11: In `src/components/modals/ReviewTaskModal.tsx` line 107, wire "Minta Revisi" button to execute revision workflow (move status back to 'Dalam Proses' with revision note).
5. Fix DEF-12: In `src/components/screens/ReportsScreen.tsx`, make time range pills filter data and calculate dynamic completion rate.
6. Fix DEF-13: In `src/App.tsx`, provide company context (`companyCode: 'CILALU-88'`) and company pill header.
7. Run `npm run lint` (`tsc --noEmit`) -> verify code 0.
8. Run `npm run build` (`vite build`) -> verify code 0.
9. Document all code changes and command outputs in `c:\T\Cilalutask\.agents\teamwork\teamwork_worker_m2_web_fix\handoff.md`.
When finished, send message back to orchestrator.
