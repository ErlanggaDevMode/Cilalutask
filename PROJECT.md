# Project: Cilalutask Defect Remediation & Quality Assurance

## Architecture
Cilalutask consists of two synchronized client platforms:
1. **Web SPA (`src/`)**: Built on React 19, TypeScript, Vite, and TailwindCSS. State is managed via React hooks in `App.tsx` and distributed to screen components (`HomeScreen`, `TasksScreen`, `SopScreen`, `ReportsScreen`, `TeamScreen`) and modals.
2. **Mobile App (`cilalutask_mobile/`)**: Built on Flutter (Dart SDK 3.13+), structured around Controller-based state management (`AppStateController`, `NotificationController`, `TaskController`, `SopController`, `CompanyController`, `ChatController`) and scoped state widgets (`AppStateScope`).

## Feature Inventory
| # | Feature / Defect | Description | Milestone | Source |
|---|------------------|-------------|-----------|--------|
| 1 | DEF-01 | Fix binary division ternary in HomeScreen approaching deadlines list | M2 | QA_Report §5.1 |
| 2 | DEF-02 | Fix falsy OR fallback `activeCount \|\| 24` in HomeScreen metric card | M2 | QA_Report §5.1 |
| 3 | DEF-03 | Fix hardcoded completed count `42` in HomeScreen metric card to dynamic | M2 | QA_Report §5.1 |
| 4 | DEF-04 | Fix falsy OR fallbacks (5, 14, 28) in TasksScreen status tab badges | M2 | QA_Report §5.1 |
| 5 | DEF-05 | Synchronize Header notification bell unread counter with real notifications | M2 | QA_Report §5.1 |
| 6 | DEF-06 | Fix urgent SOP banner fallback `\|\| sops[0]` when no urgent SOP exists | M2 | QA_Report §5.1 |
| 7 | DEF-07 | Fix hardcoded SOP directory badge `"14 Aktif"` to dynamic `sops.length` | M2 | QA_Report §5.1 |
| 8 | DEF-08 | Reconcile division naming ('IT & Development' vs 'IT & Tech') in ReportsScreen | M2 | QA_Report §5.1 |
| 9 | DEF-09 | Reconcile employee leaderboard completed task counts to real data | M2 | QA_Report §5.1 |
| 10 | DEF-10 | Wire inert action buttons (Header, SOP, Reports) to active handlers | M2 | QA_Report §5.1 |
| 11 | DEF-11 | Implement revision workflow on "Minta Revisi" in ReviewTaskModal | M2 | QA_Report §5.1 |
| 12 | DEF-12 | Implement dynamic metrics filtering by time range in ReportsScreen | M2 | QA_Report §5.1 |
| 13 | DEF-13 | Multi-tenant company isolation mitigation and company context support | M2 | QA_Report §5.1 |
| 14 | DEF-PLUS-01..06 | Fix discovered falsy OR bugs (read progress, review count, deadline count) | M2 | spec_miner_survey_1 |
| 15 | M-DEF-01 | Dart formatting compliance on `lib/state/notification_controller.dart` | M1 | QA_Report §5.2 |
| 16 | M-DEF-02 | Dynamic active task subtext based on `activeCount` in `home_screen.dart` | M1 | QA_Report §5.2 |
| 17 | M-DEF-03 | Dynamic team efficiency via TaskMetricsCalculator in `home_screen.dart` | M1 | QA_Report §5.2 |
| 18 | M-DEF-04 | Dynamic SOP reader denominator & fix undefined `state` compilation bug | M1 | QA_Report §5.2 |
| 19 | M-DEF-05 | Strict multi-layer isolation of Direct Messages from Notification Center | M1 | QA_Report §5.2 |
| 20 | M-OVERFLOW | Fix 13px RenderFlex overflow on small screens (320x480) in `home_screen.dart` | M1 | explorer_survey_2 |
| 21 | M-ANALYZE | Clean unused `user` variable in `home_screen.dart:19` for 0 analyze warnings | M1 | explorer_survey_2 |
| 22 | E2E-TEST | Comprehensive Web & Mobile E2E verification test harness | M3 | Dual-Track |
| 23 | QA-UPDATE | Update all 21 FAIL items and summary tables in `QA_Report.md` to PASS | M4 | QA_Report §1-6 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Mobile Defect Resolution & Quality Gates | Resolve M-DEF-01..05, fix compile error & RenderFlex overflow, 96/96 tests pass, 0 analyze issues | none | DONE (Fixed data_integrity_audit_test, 103/103 tests pass, dart format clean, flutter analyze 0 issues) |
| M2 | Web Defect Resolution | Resolve DEF-01..13 + DEF-PLUS-01..06, verify `npm run lint` & `npm run build` | none | IN_PROGRESS (Worker 6) |
| M3 | E2E Testing Suite | Requirement-driven automated E2E verification suite for Web and Mobile | M1, M2 | PLANNED |
| M4 | QA Report Update & Final Integrity Audit | Update QA_Report.md to 100% PASS, run independent forensic audit | M3 | PLANNED |

## Interface Contracts
### Web SPA (`src/`) ↔ Mobile (`cilalutask_mobile/`) Business Parity
- **Status Enum Values**: `todo` ("Belum Dimulai"), `in_progress` ("Dalam Proses"), `completed` ("Selesai").
- **Metrics Calculation**:
  - `activeCount` = tasks with status `in_progress` (or `todo` + `in_progress`).
  - `completedCount` = tasks with status `completed`.
  - `teamEfficiencyPercent` = `(completedCount / totalTasks) * 100` (or 100% when totalTasks is 0).
- **Direct Message Isolation Contract**:
  - Notification Center MUST NEVER display notifications originating from Direct Messages (targetId == 'direct_chat' or type == 'direct_chat' or title containing 'Pesan Langsung').

## Code Layout
- `cilalutask_mobile/` — Owned exclusively by Milestone M1 workers.
- `src/` — Owned exclusively by Milestone M2 workers.
- `c:\T\Cilalutask\QA_Report.md` — Owned exclusively by Milestone M4 workers.
- `.agents/teamwork/` — Agent coordination artifacts only.
