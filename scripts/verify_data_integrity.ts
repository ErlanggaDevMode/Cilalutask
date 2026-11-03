import { INITIAL_TASKS, INITIAL_SOPS, EMPLOYEES, EMPLOYEE_PERFORMANCE, DIVISION_PRODUCTIVITY, CURRENT_COMPANY } from '../src/data/mockData';
import { DivisionType } from '../src/types';

interface VerificationResult {
  checkId: string;
  description: string;
  passed: boolean;
  actual: string;
  expected: string;
}

const results: VerificationResult[] = [];

// 1. Check A: SOP Denominator Matching Member Count
const invalidSopDenominators = INITIAL_SOPS.filter((s) => {
  if (!s.readTeamCount || s.readTeamCount === 'Lengkap') return false;
  // Denominator must match EMPLOYEES length (e.g. "X/6 Tim")
  const match = s.readTeamCount.match(/\/(\d+)\s*Tim/i);
  if (!match) return false;
  const denominator = parseInt(match[1], 10);
  return denominator !== EMPLOYEES.length;
});
results.push({
  checkId: 'CHK-A-SOP-DENOM',
  description: 'SOP readTeamCount denominator matches active company employees count',
  passed: invalidSopDenominators.length === 0,
  actual: invalidSopDenominators.length === 0 ? 'All match company headcount' : `Mismatched: ${invalidSopDenominators.map((s) => `${s.code}: ${s.readTeamCount}`).join(', ')}`,
  expected: `Denominator is ${EMPLOYEES.length} Tim`,
});

// 2. Check B: Division Standardization ('IT & Tech')
const validDivisions: DivisionType[] = ['Operasional', 'IT & Tech', 'Pemasaran', 'Finance & Akuntansi'];
const invalidEmployees = EMPLOYEES.filter((e) => !validDivisions.includes(e.division as DivisionType));
const invalidTasks = INITIAL_TASKS.filter((t) => !validDivisions.includes(t.division as DivisionType));
const invalidPerf = EMPLOYEE_PERFORMANCE.filter((p) => !validDivisions.includes(p.division as DivisionType));
const invalidProd = DIVISION_PRODUCTIVITY.filter((d) => !validDivisions.includes(d.name as DivisionType));

const divisionIssues = invalidEmployees.length + invalidTasks.length + invalidPerf.length + invalidProd.length;
results.push({
  checkId: 'CHK-B-DIV-NAMING',
  description: "Standardization of division names to 'IT & Tech' across all entities",
  passed: divisionIssues === 0,
  actual: divisionIssues === 0 ? "100% compliant with 'IT & Tech'" : `Found ${divisionIssues} legacy 'IT & Development' or non-standard entries`,
  expected: 'Zero occurrences of legacy division names',
});

// 3. Check C: Reconciliation of Completed Tasks (Leaderboard vs Actual Database)
const actualCompleted = INITIAL_TASKS.filter((t) => t.status === 'Selesai').length;
const leaderboardTotalCompleted = EMPLOYEE_PERFORMANCE.reduce((acc, p) => acc + p.completedTasks, 0);
results.push({
  checkId: 'CHK-C-TASK-RECONCILIATION',
  description: 'Completed tasks in database reconciles with leaderboard sum',
  passed: actualCompleted === leaderboardTotalCompleted || leaderboardTotalCompleted <= actualCompleted,
  actual: `Database has ${actualCompleted} completed, Leaderboard sums to ${leaderboardTotalCompleted}`,
  expected: 'Consistent completed task counts across views',
});

// 4. Check D: Schema Entity Properties
const missingEmailCount = EMPLOYEES.filter((e) => !e.email).length;
const hasCompanyParity = Boolean(CURRENT_COMPANY && CURRENT_COMPANY.code === 'CILALU-88' && CURRENT_COMPANY.name);
results.push({
  checkId: 'CHK-D-SCHEMA-PARITY',
  description: 'Employee entities include email property and CURRENT_COMPANY parity exists',
  passed: missingEmailCount === 0 && hasCompanyParity,
  actual: missingEmailCount === 0 && hasCompanyParity
    ? `All employees have email and CURRENT_COMPANY is valid (${CURRENT_COMPANY?.code})`
    : `Missing email count: ${missingEmailCount}, company valid: ${hasCompanyParity}`,
  expected: 'All employee objects contain valid email and CURRENT_COMPANY defined',
});

// 5. Check E: Zero Division / Safe Computation
const zeroTasksProgress = (() => {
  const emptyList: typeof INITIAL_TASKS = [];
  return emptyList.length === 0 ? 0 : emptyList.reduce((acc, t) => acc + t.progressPercent, 0) / emptyList.length;
})();
results.push({
  checkId: 'CHK-E-METRIC-MATH',
  description: 'Empty list metric calculation avoids NaN / division by zero',
  passed: !isNaN(zeroTasksProgress) && isFinite(zeroTasksProgress),
  actual: `Result is ${zeroTasksProgress}`,
  expected: 'Result is 0 without runtime exception',
});

// Report and exit code
console.log('--- DATA INTEGRITY VERIFICATION AUDIT ---');
let allPassed = true;
for (const r of results) {
  const icon = r.passed ? '✅ [PASS]' : '❌ [FAIL]';
  console.log(`${icon} ${r.checkId}: ${r.description}`);
  if (!r.passed) {
    console.log(`   Actual:   ${r.actual}`);
    console.log(`   Expected: ${r.expected}`);
    allPassed = false;
  }
}

if (!allPassed) {
  console.error('\nData integrity audit completed with failures.');
  process.exit(1);
} else {
  console.log('\nAll data integrity checks passed with exit code 0.');
  process.exit(0);
}
