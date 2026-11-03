# Scope: Data Master & Database Reconciliation (Web & Mobile)

## Architecture
- **Web Layer (`src/`)**: React 19 SPA, TypeScript, TailwindCSS. State management via React hooks (`useState`), typed via `src/types.ts`.
- **Mobile Layer (`cilalutask_mobile/`)**: Flutter 3 / Dart SDK. State management via Controllers (`AppStateController`, `CompanyController`, `SopController`, `NotificationController`).
- **Cloud Database (Firebase Firestore)**: Sub-collection pattern partitioned by `companyCode`: `/companies/{companyCode}/{collectionName}/{docId}`. Security rules enforced via `isCompanyMember()` and `isCompanyAdmin()`.
- **Local Storage Partitioning**: Mobile `SharedPreferences` partitioned with key prefix `cilalu_*_{companyCode}`. Web state aligned with multi-tenant data contracts.
- **Data Master Taxonomy**: Division contract strictly standardized to: `'Operasional' | 'IT & Tech' | 'Pemasaran' | 'Finance & Akuntansi'`.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Dynamic SOP Denominator & Reader Counts | Eliminate static '34 Tim' or '32/34 Tim'; compute dynamic ratios against real tenant headcount | M1 | R1, QA 4.4, M-DEF-04 |
| 2 | Mobile Home Efficiency Math Fix | Fix inflation bug in `home_screen.dart:180` (completionRate * 100 -> completionRate) | M1 | dm_explorer_2, QA 4.4 |
| 3 | Division Standardization to 'IT & Tech' | Unify legacy 'IT & Development' -> 'IT & Tech' in mockData.ts, mock_data.dart, and fix binary division ternary in HomeScreen.tsx | M2 | R3, QA 5.1 DEF-08, DEF-01 |
| 4 | Dead Mock Data Elimination & Task Reconciliation | Purge unused `kEmployeePerformance` & `kDivisionProductivity` from mock_data.dart; reconcile web completed tasks (42 vs 93 vs 2 actual) | M2 | R3, QA 4.4, DEF-09 |
| 5 | Multi-Tenant Schema Parity (Company & companyCode) | Introduce Company model and tenant isolation fields to Web types.ts; verify Firestore rules & LocalStorage parity | M3 | R2, QA 5.1 DEF-13 |
| 6 | Automated Integrity Test Suite (Web & Mobile) | Implement `scripts/verify_data_integrity.ts` and `cilalutask_mobile/test/data_integrity_audit_test.dart` | M4 | R5, QA 4.4 |
| 7 | Data Master Audit Report & Dev Handover | Compile comprehensive data audit report documenting reconciliation, Firestore schema mapping, and data bug fixes | M4 | R4 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | M1: SOP Denominator & Metrics Reconciliation | Dynamic SOP denominator across web & mobile, fix mobile 2500% efficiency math bug | none | PLANNED |
| 2 | M2: Division Standardization & Dead Mock Cleanup | Standardize 'IT & Tech' across web & mobile; purge dead mock data lists; reconcile completed task metrics | M1 | PLANNED |
| 3 | M3: Multi-Tenant Schema Parity & Isolation | Add Company & companyCode models to Web types.ts; document & verify Firestore multi-tenant security rules | M2 | PLANNED |
| 4 | M4: Automated Verification Test Suites & Final Audit Report | Implement automated integrity tests on Web and Mobile; run all test suites; compile Data Master Audit Report | M3 | PLANNED |

## Interface Contracts
### Web Data Contracts (`src/types.ts`)
- `DivisionType = 'Semua' | 'Operasional' | 'IT & Tech' | 'Pemasaran' | 'Finance & Akuntansi'`
- `Company`:
  ```ts
  export interface Company {
    id: string;
    name: string;
    code: string;
    adminName: string;
    adminEmail: string;
    createdAt?: string;
    industry?: string;
  }
  ```
- `Task` & `SOPDocument` include optional `companyCode?: string;`
- `Assignee` includes optional `email?: string;`

### Mobile Data Contracts (`cilalutask_mobile/lib/`)
- `Company` (`lib/models/company.dart`): `code: String`, `name: String`, `adminEmail: String`
- `TaskMetricsCalculator` returns completionRate as a percentage (0.0 to 100.0).

## Code Layout
- Web data & types: `src/data/mockData.ts`, `src/types.ts`, `src/components/screens/`, `src/components/modals/`
- Mobile data & models: `cilalutask_mobile/lib/data/mock_data.dart`, `cilalutask_mobile/lib/models/`, `cilalutask_mobile/lib/screens/`, `cilalutask_mobile/lib/widgets/`
- Automated test scripts: `scripts/verify_data_integrity.ts`, `cilalutask_mobile/test/data_integrity_audit_test.dart`
- Reporting: `DATA_MASTER_AUDIT_REPORT.md`
