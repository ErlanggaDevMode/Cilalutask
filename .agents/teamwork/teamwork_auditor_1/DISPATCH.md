# Dispatch for Auditor 1 (Forensic Integrity Auditor)

## Mandatory Reading
Read:
- `c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md` (Mandatory - contains integrity constraints)
- `c:\T\Cilalutask\PROJECT.md`
- Target Deliverable: `c:\T\Cilalutask\QA_Report.md`

## Working Directory
`c:\T\Cilalutask\.agents\teamwork\teamwork_auditor_1`

## Scope & Objective
Perform rigorous forensic integrity audit on `c:\T\Cilalutask\QA_Report.md` and the QA team's execution:
1. Verify Constraint Compliance: "The team must NOT: Mark checklist items (Pass/Fail) without actual execution and verification against the application."
2. Check for Integrity Violations:
   - Check if any checklist item was assumed or fabricated without real execution.
   - Check if evidence chains (commands, terminal outputs, exit codes) correspond to genuine execution in the workspace.
   - Verify that the Pass and Fail classifications reflect actual verification results rather than whitewashing or dummy claims.
   - Verify that `QA_Report.md` genuinely exists at root `c:\T\Cilalutask\QA_Report.md` and was produced with real content.
3. Record binary verdict:
   - **CLEAN**: No cheating, zero fabrication, all checklist items backed by actual execution and verifiable facts.
   - **INTEGRITY VIOLATION**: Cheating detected, fake results, or unverified claims.
Document full evidence in `c:\T\Cilalutask\.agents\teamwork\teamwork_auditor_1\handoff.md`.
Send message back when done.

## 2026-11-02T18:38:27Z
You are Auditor 1 (Forensic Integrity Auditor).
Your working directory is c:\T\Cilalutask\.agents\teamwork\teamwork_auditor_1.
You MUST read c:\T\Cilalutask\.agents\teamwork\ORIGINAL_REQUEST.md before starting work.
Also read your dispatch task at c:\T\Cilalutask\.agents\teamwork\teamwork_auditor_1\DISPATCH.md.
Review target: c:\T\Cilalutask\QA_Report.md.

Task:
Perform a strict forensic integrity audit on QA_Report.md and the team's work products:
- Verify constraint: "The team must NOT: Mark checklist items (Pass/Fail) without actual execution and verification against the application."
- Check for any simulated, assumed, or fake results: verify that all terminal command outputs, exit codes, and test counts reflect genuine executions in the repository.
- Verify that QA_Report.md exists at c:\T\Cilalutask\QA_Report.md and is fully populated with empirical data.
- Check for binary integrity verdict: CLEAN or INTEGRITY VIOLATION.
Record your verdict and full evidence report in c:\T\Cilalutask\.agents\teamwork\teamwork_auditor_1\handoff.md.
When finished, send a message back to orchestrator.
