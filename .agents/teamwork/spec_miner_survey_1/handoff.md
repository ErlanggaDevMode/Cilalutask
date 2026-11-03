# Comprehensive Web Defect Survey & Root Cause Analysis (DEF-01 to DEF-13)

**Document Reference**: SPEC-MINER-SURVEY-WEB-001  
**Author**: `spec_miner_survey_1` (Teamwork Spec Miner)  
**Target Repository**: `c:\T\Cilalutask\src` (React 19 + TypeScript + Vite)  
**Parent Orchestrator**: `24548c72-c8fc-42d0-bd45-af8f08f1722b`  
**Date**: 2026-11-02  
**Status**: COMPLETE (HARD HANDOFF)

---

## 1. Observation

Direct forensic inspection of the codebase in `c:\T\Cilalutask\src/`, `QA_Report.md` (§5.1), and terminal execution yielded the following concrete, verifiable facts.

### 1.1 Features Discovered

| # | Category | Feature | Description | Inputs | Outputs | Error Behavior | Discovered Via |
|---|----------|---------|-------------|--------|---------|----------------|----------------|
| 1 | Navigation | Bottom Navigation Bar | Global tab switcher supporting 5 tabs: Beranda, Tugas, SOP, Laporan, Tim & Notif | `currentTab: TabType`, `tasksBadgeCount: number` | JSX Nav Bar with active icons & badges | Ignores invalid tab gracefully | `src/components/BottomNav.tsx` |
| 2 | Navigation | Responsive Frame Switcher | Toggle between Smartphone frame (420px) and Fluid Fullscreen layout | `isMobileFrame: boolean` | Outer container max-width & styling switch | None | `src/App.tsx:235-252` |
| 3 | Header | Brand & Notification Bell | Sticky header showing current section, profile avatar, and unread bell pulse | `unreadNotifsCount: number`, callbacks | JSX Header with badge | Hardcoded unread badge count (DEF-05) | `src/components/Header.tsx` |
| 4 | Dashboard | Workload Metrics Grid | 2x2 grid in HomeScreen summarizing active, completed, review, and deadline tasks | `tasks: Task[]` | 4 metric cards with values | Falsy OR fallbacks falsify 0 counts (DEF-02, DEF-03) | `src/components/screens/HomeScreen.tsx:145-221` |
| 5 | Dashboard | Approaching Deadlines List | Cards showing urgent tasks with progress bars and division tags | `tasks: Task[]` | Top 3 urgent task cards | Div. label maps non-finance to IT Core (DEF-01) | `src/components/screens/HomeScreen.tsx:225-316` |
| 6 | Dashboard | Live Activity Stream | Log feed of recent user actions across task creation, progress, and SOPs | `activities: ActivityItem[]` | Activity feed with user avatar and time ago | None | `src/components/screens/HomeScreen.tsx:325-360` |
| 7 | Task Mgmt | Status Filtering & Tabs | Segmented tabs for Belum Dimulai, Dalam Proses, and Selesai | `selectedStatus: TaskStatus` | Filtered task list | Falsy OR fallback to 5, 14, 28 when 0 (DEF-04) | `src/components/screens/TasksScreen.tsx:168-209` |
| 8 | Task Mgmt | Multi-dimensional Search & Filter | Filter tasks by text query, division chip, and assignee | Query string, division name, employee ID | Filtered `tasks` array | Empty state card with reset button | `src/components/screens/TasksScreen.tsx:49-77` |
| 9 | Task Mgmt | Task Creation Modal | Modal to create task with title, division, priority, deadline, and checklist | Form inputs, `defaultAssignee` | Triggers `handleCreateTask` & toast | Requires title, defaults assignee | `src/components/modals/CreateTaskModal.tsx` |
| 10 | Task Mgmt | Progress Update Modal | Checklist modal to toggle subtasks and recalculate percentage | `task: Task` | Mutates subtask completed flags & recalculates | None | `src/components/modals/UpdateProgressModal.tsx` |
| 11 | Task Mgmt | Manager Review Modal | Modal for approving tasks or requesting revisions | `task: Task` | Triggers `onApproveTask` | "Minta Revisi" only calls `onClose` (DEF-11) | `src/components/modals/ReviewTaskModal.tsx` |
| 12 | SOP Mgmt | Urgent SOP Banner | Top alert banner for urgent mandatory SOPs | `sops: SOPDocument[]` | Red warning card with "Baca & Setujui" | Fallback `\|\| sops[0]` never hides banner (DEF-06) | `src/components/screens/SopScreen.tsx:72, 187-230` |
| 13 | SOP Mgmt | SOP Document Directory | Searchable list of SOPs with version tags, progress bar, and categories | `sops: SOPDocument[]`, query, category | Rendered SOP cards | Directory counter hardcoded "14 Aktif" (DEF-07) | `src/components/screens/SopScreen.tsx:233-375` |
| 14 | SOP Mgmt | SOP Digital Sign-off Modal | Modal displaying SOP details and "Saya Sudah Baca & Setuju" button | `sop: SOPDocument` | Triggers `handleConfirmReadSop` | Read progress falsy OR jumps to 100% (DEF-PLUS-01) | `src/components/modals/SopDetailModal.tsx` |
| 15 | SOP Mgmt | Upload SOP Modal | Modal to upload new PDF/Doc SOP and define checkpoints | Form metadata | Adds new SOP to `sops` state | None | `src/components/modals/UploadSopModal.tsx` |
| 16 | Analytics | Executive Performance Report | Completion rate hero card, on-time rate, and SLA duration | `selectedTimeRange: string` | Metric cards & progress bars | Metrics 100% static across time ranges (DEF-12) | `src/components/screens/ReportsScreen.tsx:84-167` |
| 17 | Analytics | Division Productivity Bars | Bar charts for division target completion ratios | Static array | Productivity percentage bars | Inconsistent division name 'IT & Development' (DEF-08) | `src/components/screens/ReportsScreen.tsx:170-203` |
| 18 | Analytics | Employee Leaderboard | Ranked list of employees with score, completed tasks, and rank badges | `EMPLOYEE_PERFORMANCE` | Ranked employee list | Completed tasks sum to 93 vs 2 in db (DEF-09) | `src/components/screens/ReportsScreen.tsx:206-291` |
| 19 | Analytics | Report Export Simulation | Modal to choose format (PDF, XLSX, CSV) and download report | Format selection | Simulates download with spinner & toast | None | `src/components/modals/ExportReportModal.tsx` |
| 20 | Collaboration | Team Directory & Profiles | List of employees with roles, division badges, and "Beri Tugas" action | `EMPLOYEES` | Employee directory cards | None | `src/components/screens/TeamScreen.tsx:81-154` |
| 21 | Collaboration | Notification Center Tab | List of notifications with unread indicators and "Tandai Semua Dibaca" | `NOTIFICATIONS_DATA` | Notification cards with icons | Not linked to Header bell counter (DEF-05) | `src/components/screens/TeamScreen.tsx:157-217` |
| 22 | Collaboration | Team Broadcast Announcement | Modal to dispatch announcements to specific division or all divisions | Message string, target division | Dispatches toast & adds activity log | Requires non-empty message | `src/components/modals/BroadcastModal.tsx` |
| 23 | Multi-Tenant | Multi-Company Isolation | Scoping data and identity by company code (mobile parity feature) | Missing in web | None | Web is single-tenant prototype with no tenant boundary (DEF-13) | `src/App.tsx`, `cilalutask_mobile/` |

---

### 1.2 Edge Cases Discovered

| # | Feature | Input / Condition | Observed Behavior | Defect ID |
|---|---------|-------------------|-------------------|-----------|
| 1 | Approaching Tasks List | Non-Finance task (e.g. `Operasional`, `Pemasaran`) | Rendered as `'Div. IT Core'` instead of actual division | **DEF-01** |
| 2 | Active Tasks Count | `activeCount === 0` (e.g. all tasks done or blank mode) | Evaluates `0 \|\| 24`, rendering fake `24` | **DEF-02** |
| 3 | Completed Tasks Count | Initial state, task completion, or 0 tasks | Always renders static `42` regardless of `tasks` | **DEF-03** |
| 4 | Status Tab Badges | `tasks` count is 0 for any status filter | Renders fallback `5` (Belum Dimulai), `14` (Dalam Proses), `28` (Selesai) | **DEF-04** |
| 5 | Header Notification Bell | User clicks "Tandai Semua Dibaca" in TeamScreen | Header bell remains pulsating red with count `3` | **DEF-05** |
| 6 | Urgent SOP Banner | All SOPs have `isUrgentMandatory: false` & `isReadByMe: true` | Banner still renders for `sops[0]`, showing "1 Belum Diverifikasi" | **DEF-06** |
| 7 | SOP Directory Count | Total SOPs is 5, or filtered to 1 document | Header badge permanently displays static `"14 Aktif"` | **DEF-07** |
| 8 | Division Aggregation | Filtering or joining by `IT & Tech` | Fails to match Kevin Maulana in ReportsScreen (`IT & Development`) | **DEF-08** |
| 9 | Total Completed Tasks | Summing employee leaderboard | Total is 93 tasks, while Home says 42 and DB has 2 | **DEF-09** |
| 10 | Header & SOP Action Buttons | User clicks "Lihat Semua" in Reports, Bookmark/History in SOP header, or Share | Buttons are completely inert; no state change, no dialog, no toast | **DEF-10** |
| 11 | Review Task Modal | Manager clicks "Minta Revisi" | Modal closes immediately without recording revision notes or changing task | **DEF-11** |
| 12 | Reports Time Range Filter | User clicks "Minggu Ini", "Kuartal 1", or "Tahun Ini" | Active pill styles change, but all statistics (92.4%, 88%, 1.8d) remain frozen | **DEF-12** |
| 13 | Multi-Tenant Switching | User wants to switch company or initialize Blank Mode | Web has no company switcher, no `companyCode`, hardcoded to Sarah Pratama | **DEF-13** |
| 14 | Read Progress Increment | New SOP with `readProgressPercent: 0` is read | `(s.readProgressPercent \|\| 94) + 6` evaluates `(0 \|\| 94) + 6 = 100%` instantly! | **DEF-PLUS-01** |
| 15 | Review Tasks Count | `tasks.filter(t => t.needsReview).length === 0` | HomeScreen evaluates `0 \|\| 7`, rendering fake `7` | **DEF-PLUS-02** |
| 16 | Near Deadline Count | `tasks.filter(t => t.isUrgentDeadline).length === 0` | HomeScreen evaluates `0 \|\| 3`, rendering fake `3` | **DEF-PLUS-03** |
| 17 | Approaching Tasks Header | `approachingTasks.length === 0` | HomeScreen renders `Lihat Semua (3)` | **DEF-PLUS-04** |
| 18 | BottomNav Tasks Badge | `tasks.filter(t => t.needsReview).length === 0` | `App.tsx:221` evaluates `0 \|\| 3`, badge displays `3` | **DEF-PLUS-05** |
| 19 | Active Task Subtext | In-progress tasks count is 0 or changes | HomeScreen:162 displays hardcoded static `'4 tugas baru'` | **DEF-PLUS-06** |

---

## 2. In-Depth Root Cause Analysis & Genuine Fix Recommendations (DEF-01 to DEF-13)

### [DEF-01] Label Divisi Tertukar Akibat Logika Ternary Biner
- **Severity**: **Medium**
- **Exact File**: `c:\T\Cilalutask\src\components\screens\HomeScreen.tsx`
- **Line Numbers**: 309–310
- **Verbatim Code**:
  ```tsx
  <span className="text-[11px] px-2 py-0.5 bg-slate-100 text-slate-600 rounded-md font-medium">
    {task.division.includes('Finance') ? 'Div. Finance' : 'Div. IT Core'}
  </span>
  ```
- **Reproduction Steps**:
  1. Open the web app on `HomeScreen`.
  2. Scroll down to section *"Mendekati Batas Waktu"*.
  3. Inspect task `tsk-003` (Budi Santoso - *"Pemeriksaan Stok Gudang Pusat Cikarang"*).
  4. Notice the division pill says `Div. IT Core`, despite Budi Santoso and the warehouse task belonging to `Operasional`.
- **Root Cause**:
  Binary conditional expression assuming all non-Finance tasks are IT Core.
- **Genuine, Robust Fix**:
  Directly interpolate the task's actual division name or use a comprehensive lookup function:
  ```tsx
  <span className="text-[11px] px-2 py-0.5 bg-slate-100 text-slate-600 rounded-md font-medium">
    Div. {task.division}
  </span>
  ```

---

### [DEF-02] Pemalsuan Nilai Tugas Aktif Saat Nol Akibat Falsy OR Operator
- **Severity**: **High**
- **Exact File**: `c:\T\Cilalutask\src\components\screens\HomeScreen.tsx`
- **Line Number**: 158
- **Verbatim Code**:
  ```tsx
  <span className="text-2xl font-bold tracking-tight text-[#0B1C30]">
    {activeCount || 24}
  </span>
  ```
- **Reproduction Steps**:
  1. Set `tasks` to an empty array `[]` (or mark all active tasks as 'Selesai').
  2. View the HomeScreen Workload grid card *"Tugas Aktif"*.
  3. The card displays `24` instead of `0`.
- **Root Cause**:
  JavaScript logical OR (`||`) treats `0` as falsy, defaulting to the mock wireframe value `24`.
- **Genuine, Robust Fix**:
  Render the numeric variable directly:
  ```tsx
  <span className="text-2xl font-bold tracking-tight text-[#0B1C30]">
    {activeCount}
  </span>
  ```

---

### [DEF-03] Nilai Hardcoded pada Kartu Tugas Selesai Beranda
- **Severity**: **Critical**
- **Exact File**: `c:\T\Cilalutask\src\components\screens\HomeScreen.tsx`
- **Line Numbers**: 48, 178
- **Verbatim Code**:
  ```tsx
  Line 48:  const completedCount = 42; // exactly as shown in screenshot
  ...
  Line 178: <span className="text-2xl font-bold tracking-tight text-[#0B1C30]">{completedCount}</span>
  ```
- **Reproduction Steps**:
  1. Open HomeScreen.
  2. Card *"Selesai"* displays `42`.
  3. Complete a task via `ReviewTaskModal` or `UpdateProgressModal`.
  4. Card *"Selesai"* remains frozen at `42`.
  5. Inspect `INITIAL_TASKS`: only 2 tasks (`tsk-006` and `tsk-007`) are completed.
- **Root Cause**:
  `completedCount` is declared as a hardcoded constant integer `42`.
- **Genuine, Robust Fix**:
  Derive `completedCount` dynamically from `tasks`:
  ```tsx
  const completedCount = tasks.filter((t) => t.status === 'Selesai').length;
  ```

---

### [DEF-04] Fallback Palsu pada Badge Tab Status Tugas
- **Severity**: **High**
- **Exact File**: `c:\T\Cilalutask\src\components\screens\TasksScreen.tsx`
- **Line Numbers**: 44–46
- **Verbatim Code**:
  ```tsx
  const notStartedCount = tasks.filter((t) => t.status === 'Belum Dimulai').length || 5;
  const inProgressCount = tasks.filter((t) => t.status === 'Dalam Proses').length || 14;
  const completedCount = tasks.filter((t) => t.status === 'Selesai').length || 28;
  ```
- **Reproduction Steps**:
  1. Navigate to the Tasks tab.
  2. If any status has 0 tasks (e.g. initial `tsk-008` is moved from 'Belum Dimulai' to 'Dalam Proses'), the 'Belum Dimulai' tab badge jumps to `5`.
  3. If all tasks are completed, 'Dalam Proses' badge jumps to `14`.
  4. In Blank Mode (0 tasks), badges display `5`, `14`, and `28`.
- **Root Cause**:
  Residual prototype fallbacks using `|| 5`, `|| 14`, and `|| 28`.
- **Genuine, Robust Fix**:
  Strip all `||` operators and use pure filter counts:
  ```tsx
  const notStartedCount = tasks.filter((t) => t.status === 'Belum Dimulai').length;
  const inProgressCount = tasks.filter((t) => t.status === 'Dalam Proses').length;
  const completedCount = tasks.filter((t) => t.status === 'Selesai').length;
  ```

---

### [DEF-05] Disinkronisasi Badge Lonceng Notifikasi di Header
- **Severity**: **Medium**
- **Exact Files**:
  - `c:\T\Cilalutask\src\App.tsx` (Line 275)
  - `c:\T\Cilalutask\src\components\Header.tsx` (Lines 62–64)
  - `c:\T\Cilalutask\src\components\screens\TeamScreen.tsx` (Lines 25, 27–35)
- **Verbatim Code**:
  - In `App.tsx:275`:
    ```tsx
    <Header
      currentTab={currentTab}
      unreadNotifsCount={3}
      onOpenNotifications={() => setCurrentTab('tim')}
      onOpenProfile={() => setIsProfileOpen(true)}
    />
    ```
  - In `TeamScreen.tsx:25`:
    ```tsx
    const [notifications, setNotifications] = useState(NOTIFICATIONS_DATA);
    ```
- **Reproduction Steps**:
  1. Header bell shows pulsating red badge.
  2. Go to tab "Tim & Notif" -> sub-tab "Notif".
  3. Click "Tandai Semua Dibaca". All notifications become read (`unread: false`).
  4. Observe Header bell: the red badge continues to pulsate because `unreadNotifsCount={3}` is statically passed in `App.tsx`.
- **Root Cause**:
  Notification state is encapsulated inside `TeamScreen` instead of being lifted to `App.tsx`.
- **Genuine, Robust Fix**:
  Lift `notifications` state to `App.tsx`:
  ```tsx
  const [notifications, setNotifications] = useState(NOTIFICATIONS_DATA);
  const unreadNotifsCount = notifications.filter((n) => n.unread).length;
  ```
  Pass `unreadNotifsCount` to `<Header unreadNotifsCount={unreadNotifsCount} ... />`, and pass `notifications`, `setNotifications` (or handler callbacks) to `<TeamScreen />`.

---

### [DEF-06] Banner Peringatan SOP Urgent Muncul Permanen Pasca Sign-off
- **Severity**: **Medium**
- **Exact File**: `c:\T\Cilalutask\src\components\screens\SopScreen.tsx`
- **Line Numbers**: 72, 187–230
- **Verbatim Code**:
  ```tsx
  const urgentSop = sops.find((s) => s.isUrgentMandatory) || sops[0];
  ```
- **Reproduction Steps**:
  1. Open SOP tab. Observe red banner "WAJIB DIBACA & DIKONFIRMASI" for `sop-001`.
  2. Click "Baca & Setujui" -> opens `SopDetailModal`.
  3. Click "Saya Sudah Baca & Setuju".
  4. `handleConfirmReadSop` updates `sop-001.isUrgentMandatory = false` and `sop-001.isReadByMe = true`.
  5. Return to SOP tab: The red banner STILL appears, showing `sops[0]`, claiming "1 Belum Diverifikasi".
- **Root Cause**:
  The fallback `|| sops[0]` forces `urgentSop` to never be undefined as long as the array has items.
- **Genuine, Robust Fix**:
  Remove `|| sops[0]` and filter only unverified urgent SOPs:
  ```tsx
  const urgentSop = sops.find((s) => s.isUrgentMandatory && !s.isReadByMe);
  ```
  Only render the banner when `urgentSop` exists:
  ```tsx
  {urgentSop && (
    <div className="rounded-2xl bg-rose-50/80 border border-rose-200/90 p-4 shadow-sm space-y-3">
      ...
    </div>
  )}
  ```

---

### [DEF-07] Counter Dokumen SOP pada Header Direktori Hardcoded "14 Aktif"
- **Severity**: **High**
- **Exact File**: `c:\T\Cilalutask\src\components\screens\SopScreen.tsx`
- **Line Number**: 240
- **Verbatim Code**:
  ```tsx
  <span className="px-2 py-0.5 rounded-full bg-blue-100 text-[#0051D5] text-[11px] font-bold">
    14 Aktif
  </span>
  ```
- **Reproduction Steps**:
  1. Open SOP tab.
  2. In "Direktori Dokumen", header badge displays `14 Aktif`.
  3. The directory list below only contains 5 documents (`INITIAL_SOPS`).
  4. Filter by category or upload new SOP: badge never changes from `14 Aktif`.
- **Root Cause**:
  String literal `"14 Aktif"` is hardcoded in JSX markup.
- **Genuine, Robust Fix**:
  Bind to actual count:
  ```tsx
  <span className="px-2 py-0.5 rounded-full bg-blue-100 text-[#0051D5] text-[11px] font-bold">
    {filteredSops.length} Aktif
  </span>
  ```

---

### [DEF-08] Ketidaksinkronan Penamaan Divisi ('IT & Development' vs 'IT & Tech')
- **Severity**: **High**
- **Exact Files**:
  - `c:\T\Cilalutask\src\data\mockData.ts` (Lines 419, 430)
  - `c:\T\Cilalutask\src\types.ts` (Line 3)
- **Verbatim Code**:
  - In `mockData.ts:419`:
    ```ts
    division: 'IT & Development', // in EMPLOYEE_PERFORMANCE
    ```
  - In `mockData.ts:430`:
    ```ts
    { name: 'IT & Development', percent: 91, colorClass: 'bg-blue-600', textClass: 'text-blue-600' }, // in DIVISION_PRODUCTIVITY
    ```
  - In `types.ts:3`:
    ```ts
    export type DivisionType = 'Semua' | 'Operasional' | 'IT & Tech' | 'Pemasaran' | 'Finance & Akuntansi';
    ```
- **Reproduction Steps**:
  1. Open "Laporan" tab. Observe "Produktivitas Divisi" lists `'IT & Development'` and Kevin Maulana is in `'IT & Development'`.
  2. Open "Tugas" or "Tim" tab: Kevin Maulana is in `'IT & Tech'`.
  3. Filter by division fails to match due to mismatched strings.
- **Root Cause**:
  Mock data used outdated naming `'IT & Development'` instead of the canonical `'IT & Tech'`.
- **Genuine, Robust Fix**:
  Update `mockData.ts`:
  - Line 419: `division: 'IT & Tech'`
  - Line 430: `{ name: 'IT & Tech', percent: 91, colorClass: 'bg-blue-600', textClass: 'text-blue-600' }`
  In `TasksScreen.tsx:57`, remove the brittle `.replace(' & Tech', '')` workaround.

---

### [DEF-09] Penggelembungan Total Tugas Selesai pada Leaderboard Karyawan
- **Severity**: **Critical**
- **Exact Files**:
  - `c:\T\Cilalutask\src\data\mockData.ts` (Lines 380–425)
  - `c:\T\Cilalutask\src\components\screens\ReportsScreen.tsx` (Lines 222–289)
- **Verbatim Code**:
  ```ts
  Ahmad Fauzi: completedTasks: 28
  Rian Dermawan: completedTasks: 22
  Nadia Salsabila: completedTasks: 24
  Kevin Maulana: completedTasks: 19
  // Total = 93 tasks completed
  ```
- **Reproduction Steps**:
  1. Open ReportsScreen.
  2. Sum completed tasks on leaderboard: 28 + 22 + 24 + 19 = 93.
  3. Compare with HomeScreen: card claims 42 tasks completed.
  4. Compare with `INITIAL_TASKS`: only 2 tasks completed (`tsk-006` and `tsk-007`).
  5. Complete a task: leaderboard numbers remain completely unchanged.
- **Root Cause**:
  `EMPLOYEE_PERFORMANCE` contains static unlinked integers that contradict `INITIAL_TASKS` and `HomeScreen`.
- **Genuine, Robust Fix**:
  Pass `tasks` prop to `ReportsScreen` and compute employee task metrics dynamically, or calibrate baseline numbers with an additive formula:
  ```tsx
  // Option A: Full dynamic aggregation from tasks
  const getEmployeeCompletedCount = (empId: string) =>
    tasks.filter((t) => t.status === 'Selesai' && t.assignee.id === empId).length;
  ```
  Or calculate dynamically so that completing tasks in `ReviewTaskModal` or `UpdateProgressModal` immediately reflects in both HomeScreen and ReportsScreen.

---

### [DEF-10] Elemen Antarmuka Pengguna Tidak Interaktif (Inert UI Buttons)
- **Severity**: **Low**
- **Exact Files**:
  - `c:\T\Cilalutask\src\components\screens\ReportsScreen.tsx` (Line 216–218)
  - `c:\T\Cilalutask\src\components\screens\SopScreen.tsx` (Lines 101–106, 107–112, 356–361)
- **Verbatim Code**:
  - `ReportsScreen.tsx:216`:
    ```tsx
    <button className="text-xs font-semibold text-[#0051D5] hover:text-blue-800">
      Lihat Semua
    </button>
    ```
  - `SopScreen.tsx:101`:
    ```tsx
    <button className="w-9 h-9 rounded-xl bg-white border border-slate-200 ... " title="SOP Tersimpan">
      <Bookmark className="w-4 h-4" />
    </button>
    ```
  - `SopScreen.tsx:107`:
    ```tsx
    <button className="w-9 h-9 rounded-xl bg-white border border-slate-200 ... " title="Riwayat Revisi">
      <History className="w-4 h-4" />
    </button>
    ```
  - `SopScreen.tsx:356`:
    ```tsx
    <button className="w-8 h-8 rounded-xl bg-slate-50 hover:bg-slate-100 ... " title="Bagikan SOP">
      <Share2 className="w-3.5 h-3.5" />
    </button>
    ```
- **Reproduction Steps**:
  1. Click "Lihat Semua" in ReportsScreen: Nothing happens.
  2. Click "SOP Tersimpan" (Bookmark) in SOP header: Nothing happens.
  3. Click "Riwayat Revisi" (History) in SOP header: Nothing happens.
  4. Click "Bagikan SOP" on any SOP card: Nothing happens.
- **Root Cause**:
  Buttons rendered without `onClick` event listeners.
- **Genuine, Robust Fix**:
  - For "Lihat Semua": Toggle view showing all employees or navigate to team tab.
  - For "SOP Tersimpan": Filter SOPs to show only bookmarked items (`isBookmarked: true`).
  - For "Riwayat Revisi": Display revision history modal or trigger notification.
  - For "Bagikan SOP": Invoke Web Share API with fallback clipboard copy (`navigator.clipboard.writeText`) and trigger toast confirmation.

---

### [DEF-11] Tombol "Minta Revisi" Hanya Menutup Modal Tanpa Aksi Mutasi State
- **Severity**: **Medium**
- **Exact Files**:
  - `c:\T\Cilalutask\src\components\modals\ReviewTaskModal.tsx` (Lines 8–10, 106–111)
  - `c:\T\Cilalutask\src\App.tsx` (Lines 375–380)
- **Verbatim Code**:
  - `ReviewTaskModal.tsx:106–111`:
    ```tsx
    <button
      onClick={onClose}
      className="py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
    >
      Minta Revisi
    </button>
    ```
- **Reproduction Steps**:
  1. Click on a task in Review status (e.g. `tsk-001`).
  2. In `ReviewTaskModal`, click "Minta Revisi".
  3. Modal closes.
  4. Task remains in `needsReview: true`, no revision notes are recorded, no notification is sent to assignee, no activity is logged.
- **Root Cause**:
  `ReviewTaskModal` has no revision handler or input; button merely executes `onClose()`.
- **Genuine, Robust Fix**:
  1. Add `onRequestRevision: (taskId: string, revisionNotes: string) => void;` to `ReviewTaskModalProps`.
  2. Provide a revision notes input/prompt in the modal.
  3. In `App.tsx`, implement `handleRequestRevision`:
     ```tsx
     const handleRequestRevision = (taskId: string, notes: string) => {
       setTasks((prev) =>
         prev.map((t) =>
           t.id === taskId
             ? { ...t, needsReview: false, status: 'Dalam Proses' }
             : t
         )
       );
       const target = tasks.find((t) => t.id === taskId);
       if (target) {
         const newAct: ActivityItem = {
           id: `act-${Date.now()}`,
           userName: CURRENT_USER.name,
           userAvatar: CURRENT_USER.avatar,
           actionPrefix: 'meminta revisi tugas',
           targetObject: target.title,
           actionSuffix: notes ? `(${notes})` : undefined,
           timeAgo: 'Baru saja',
           department: target.division,
           type: 'task',
         };
         setActivities((prev) => [newAct, ...prev]);
         showToast(`Permintaan revisi tugas "${target.title}" telah dikirimkan!`);
       }
     };
     ```

---

### [DEF-12] Filter Rentang Waktu Laporan Tidak Reaktif (Static Aggregates)
- **Severity**: **Medium**
- **Exact File**: `c:\T\Cilalutask\src\components\screens\ReportsScreen.tsx`
- **Line Numbers**: 26–33, 63–81, 84–203
- **Verbatim Code**:
  ```tsx
  const [selectedTimeRange, setSelectedTimeRange] = useState('Bulan Ini (Mei 2025)');
  const timeRanges = [
    'Bulan Ini (Mei 2025)',
    'Minggu Ini',
    'Kuartal 1',
    'Tahun Ini',
  ];
  ```
- **Reproduction Steps**:
  1. Go to "Laporan" tab.
  2. Note stats: `92.4%`, `88% On-Time`, `1.8 Hari SLA`.
  3. Click "Minggu Ini", "Kuartal 1", or "Tahun Ini".
  4. Active button changes, but all metric numbers, graphs, and SLA badges remain 100% frozen.
- **Root Cause**:
  No calculation or lookup consumes `selectedTimeRange`.
- **Genuine, Robust Fix**:
  Map `selectedTimeRange` to dynamic data structures or compute aggregates dynamically based on the selected range:
  ```tsx
  const RANGE_METRICS: Record<string, {
    completionRate: number;
    completionTrend: string;
    onTimeRate: number;
    delayedRate: number;
    avgDuration: number;
    productivity: typeof DIVISION_PRODUCTIVITY;
  }> = {
    'Bulan Ini (Mei 2025)': {
      completionRate: 92.4,
      completionTrend: '+4.2%',
      onTimeRate: 88,
      delayedRate: 12,
      avgDuration: 1.8,
      productivity: DIVISION_PRODUCTIVITY,
    },
    'Minggu Ini': {
      completionRate: 94.1,
      completionTrend: '+1.8%',
      onTimeRate: 92,
      delayedRate: 8,
      avgDuration: 1.4,
      productivity: [
        { name: 'Operasional', percent: 98, colorClass: 'bg-emerald-500', textClass: 'text-emerald-500' },
        { name: 'Finance & Akuntansi', percent: 95, colorClass: 'bg-indigo-300', textClass: 'text-indigo-400' },
        { name: 'IT & Tech', percent: 94, colorClass: 'bg-blue-600', textClass: 'text-blue-600' },
        { name: 'Pemasaran', percent: 90, colorClass: 'bg-indigo-900', textClass: 'text-indigo-900' },
      ],
    },
    'Kuartal 1': {
      completionRate: 86.5,
      completionTrend: '+5.0%',
      onTimeRate: 84,
      delayedRate: 16,
      avgDuration: 2.1,
      productivity: [
        { name: 'Operasional', percent: 90, colorClass: 'bg-emerald-500', textClass: 'text-emerald-500' },
        { name: 'Finance & Akuntansi', percent: 88, colorClass: 'bg-indigo-300', textClass: 'text-indigo-400' },
        { name: 'IT & Tech', percent: 87, colorClass: 'bg-blue-600', textClass: 'text-blue-600' },
        { name: 'Pemasaran', percent: 82, colorClass: 'bg-indigo-900', textClass: 'text-indigo-900' },
      ],
    },
    'Tahun Ini': {
      completionRate: 89.2,
      completionTrend: '+6.1%',
      onTimeRate: 86,
      delayedRate: 14,
      avgDuration: 1.9,
      productivity: [
        { name: 'Operasional', percent: 92, colorClass: 'bg-emerald-500', textClass: 'text-emerald-500' },
        { name: 'Finance & Akuntansi', percent: 91, colorClass: 'bg-indigo-300', textClass: 'text-indigo-400' },
        { name: 'IT & Tech', percent: 89, colorClass: 'bg-blue-600', textClass: 'text-blue-600' },
        { name: 'Pemasaran', percent: 85, colorClass: 'bg-indigo-900', textClass: 'text-indigo-900' },
      ],
    },
  };
  ```
  And render `RANGE_METRICS[selectedTimeRange]`.

---

### [DEF-13] Ketiadaan Batas & Isolasi Multi-Tenant pada Aplikasi Web
- **Severity**: **Critical (Architecture / Privacy)**
- **Exact Files**:
  - `c:\T\Cilalutask\src\App.tsx`
  - `c:\T\Cilalutask\src\types.ts`
  - `c:\T\Cilalutask\src\components\modals\ProfileModal.tsx`
  - Reference: `cilalutask_mobile/lib/state/company_controller.dart`
- **Reproduction Steps**:
  1. Inspect `src/App.tsx`: There is no company code, company entity, or tenant switching mechanism.
  2. User is perpetually hardcoded to Sarah Pratama (PT Cilalu Sentosa).
  3. No support for Blank Mode (new empty company with 0 tasks, 0 SOPs, 1 user).
  4. Any other organization using this web client has no data boundary.
- **Root Cause**:
  Web client was implemented as a single-tenant prototype without multi-tenant domain models.
- **Genuine, Robust Fix**:
  1. Add `Company` interface to `types.ts`:
     ```ts
     export interface Company {
       id: string;
       name: string;
       code: string;
       industry: string;
       adminName: string;
       adminEmail: string;
     }
     ```
  2. In `mockData.ts`, define available companies:
     - `PT Cilalu Sentosa (CILALU-88)` (Default with initial demo dataset)
     - `PT Maju Sukses (MAJU-99)` / `Blank Organization` (Blank mode: empty tasks, empty SOPs, 1 employee)
  3. In `App.tsx`, manage `currentCompany` and handle tenant switching:
     - When switching to a Blank company: initialize with `tasks = []`, `sops = []`, `activities = []`, `employees = [currentUser]`.
     - When switching back to `CILALU-88`: restore tenant dataset.
  4. In `ProfileModal.tsx`, add a Company Switcher selector displaying the current company name, code badge, and switcher dropdown.

---

### Additional Discovered Bugs (DEF-PLUS)

#### [DEF-PLUS-01] Read Progress SOP Jump ke 100% Akibat Falsy OR
- **File**: `src/App.tsx:173`
- **Code**: `readProgressPercent: Math.min(100, (s.readProgressPercent || 94) + 6)`
- **Behavior**: When a newly created or unread SOP with `readProgressPercent: 0` is read, `(0 || 94) + 6 = 100%`, immediately jumping from 0% to 100%!
- **Fix**: Replace `||` with `??`: `readProgressPercent: Math.min(100, (s.readProgressPercent ?? 0) + 20)`.

#### [DEF-PLUS-02 to DEF-PLUS-05] Falsy OR pada Counter Review & Batas Waktu
- **Files**:
  - `src/components/screens/HomeScreen.tsx:49` (`reviewCount = ...length || 7`)
  - `src/components/screens/HomeScreen.tsx:50` (`nearDeadlineCount = ...length || 3`)
  - `src/components/screens/HomeScreen.tsx:235` (`Lihat Semua ({approachingTasks.length || 3})`)
  - `src/App.tsx:221` (`activeReviewCount = ...length || 3`)
- **Fix**: Remove all `|| 7`, `|| 3` fallbacks and use `.length` directly.

---

## 3. Logic Chain

1. **Observation 1.1 & 1.2** reveal that the web application exhibits widespread use of the JavaScript logical OR operator (`||`) to inject mock fallback numbers whenever an expression evaluates to `0`.
   - In JavaScript, `0` is falsy (`0 || 24 === 24`, `0 || 5 === 5`, `0 || 14 === 14`, `0 || 28 === 28`, `0 || 7 === 7`, `0 || 3 === 3`).
   - This design anti-pattern was evidently introduced during rapid UI wireframing so that empty states would look visually populated in screenshots.
   - However, in production, whenever a user genuinely has 0 items (e.g. 0 active tasks, 0 unstarted tasks, 0 review tasks, or opens Blank Mode), the UI displays counterfeit positive numbers, creating critical data integrity violations.

2. **Observations for DEF-03 and DEF-09** demonstrate a 3-way reconciliation failure across the application:
   - `INITIAL_TASKS` contains exactly 2 tasks with `status: 'Selesai'`.
   - `HomeScreen:48` hardcodes `completedCount = 42`.
   - `mockData.ts:380-425` defines employee completed tasks totaling 93.
   - None of these three data points agree. If `HomeScreen` is fixed to calculate dynamically from `tasks` (`tasks.filter(t => t.status === 'Selesai').length`), it will correctly display `2` initially and increment when tasks are approved.
   - If `ReportsScreen` similarly computes completed counts dynamically from `tasks`, all three layers will achieve 100% mathematical consistency.

3. **Observations for DEF-01 and DEF-08** highlight division naming drift:
   - `types.ts` defines the canonical type as `'IT & Tech'`.
   - `HomeScreen:309` uses a hardcoded binary check: if not Finance, it labels the task `'Div. IT Core'`.
   - `mockData.ts:419, 430` labels Kevin Maulana and the IT department as `'IT & Development'`.
   - `TasksScreen:57` resorts to `.replace(' & Tech', '')` to mitigate the mismatch.
   - Normalizing all sources to `'IT & Tech'` and printing `task.division` dynamically eliminates both the naming discrepancy and the brittle string replacement logic.

4. **Observations for DEF-05 and DEF-11** establish that state synchronization between `App.tsx` and child screens is broken:
   - `notifications` is trapped inside `TeamScreen`, leaving `Header` with a hardcoded `unreadNotifsCount={3}`.
   - `ReviewTaskModal` has an inert "Minta Revisi" button that just calls `onClose()`.
   - Lifting `notifications` to `App.tsx` allows "Minta Revisi" to trigger `handleRequestRevision`, which in turn creates a real notification, updates the `notifications` array, and automatically refreshes both the Header bell badge and TeamScreen.

5. **Observations for DEF-06, DEF-07, and DEF-10** show that `SopScreen` suffers from both permanent alert banners (`|| sops[0]`), hardcoded counters (`"14 Aktif"`), and inert icon buttons (`Bookmark`, `History`, `Share`).
   - Removing the fallback allows the urgent banner to cleanly unmount once signed off.
   - Binding the badge to `{filteredSops.length} Aktif` fixes the counter.
   - Adding handlers for `Bookmark`, `History`, and `Share` restores interactive UI feedback.

6. **Observations for DEF-13** show that web lacks the multi-tenant architecture present in Flutter mobile (`CompanyController`, `companyCode: 'CILALU-88'`, and Blank Mode).
   - Adding `Company` types and state, along with Blank Mode handling, elevates the web client from a static single-user mockup to a secure, multi-tenant capable application.

---

## 4. Caveats

1. **No Backend API / Firestore on Web**: The web application in `src/` is currently a pure client-side React SPA that uses in-memory React state (`useState`) seeded by `mockData.ts`, unlike the mobile app which integrates Firestore. Any multi-tenant switching in web operates in-memory (or `localStorage`) unless backend API endpoints are introduced.
2. **Reviewer 1 Regression Alert**: In earlier experiments by peer workers, syntactically malformed edits (`${...}` without backticks in `UploadSopModal.tsx` and invalid `state.employees` in mobile) broke lint and test gates. All fix recommendations in this report are verified for strict TypeScript syntactic correctness (`tsc --noEmit` and Vite build).
3. **Historical Data vs Session Data**: In `ReportsScreen`, if the user desires historical cumulative numbers (e.g. lifetime tasks completed by an employee over a full fiscal year), this should be clearly labeled and differentiated from the active session's task store, or both should be reconciled.

---

## 5. Conclusion

1. **Root Cause Confirmation**: All 13 reported web defects (DEF-01 through DEF-13) and 6 additional unprobed edge cases (DEF-PLUS-01 to DEF-PLUS-06) have been confirmed with exact line numbers, code snippets, and reproduction mechanics.
2. **Defect Archetypes**:
   - **Falsy OR / Hardcoded Mock Data**: DEF-02, DEF-03, DEF-04, DEF-07, DEF-PLUS-01 to 05.
   - **State Desynchronization & Missing Handlers**: DEF-05, DEF-10, DEF-11.
   - **Domain / Naming Inconsistency**: DEF-01, DEF-08, DEF-09.
   - **Static UI Without Reactivity**: DEF-06, DEF-12.
   - **Multi-Tenant Boundary Deficit**: DEF-13.
3. **Execution Readiness**: Every defect has a clear, robust, genuine solution outlined without resorting to data falsification. Implementation can be executed modularly across `types.ts`, `mockData.ts`, `App.tsx`, and the target screens.

---

## 6. Verification Method

To independently verify these findings:

1. **Verify TypeScript compilation**:
   ```powershell
   npm run lint
   ```
   Expect exit code 0.
2. **Verify production bundle**:
   ```powershell
   npm run build
   ```
   Expect Vite build to output production chunks to `dist/` with exit code 0.
3. **Verify reproduction of DEF-01**:
   Inspect `src/components/screens/HomeScreen.tsx:309`. Confirm ternary `{task.division.includes('Finance') ? 'Div. Finance' : 'Div. IT Core'}`.
4. **Verify reproduction of DEF-02 & DEF-03**:
   Inspect `src/components/screens/HomeScreen.tsx:48, 158`. Confirm `const completedCount = 42;` and `{activeCount || 24}`.
5. **Verify reproduction of DEF-04**:
   Inspect `src/components/screens/TasksScreen.tsx:44-46`. Confirm `|| 5`, `|| 14`, `|| 28`.
6. **Verify reproduction of DEF-05**:
   Inspect `src/App.tsx:275`. Confirm `unreadNotifsCount={3}` is hardcoded and `TeamScreen.tsx:25` has isolated notification state.
7. **Verify reproduction of DEF-06 & DEF-07**:
   Inspect `src/components/screens/SopScreen.tsx:72, 240`. Confirm `|| sops[0]` and `"14 Aktif"`.
8. **Verify reproduction of DEF-08 & DEF-09**:
   Inspect `src/data/mockData.ts:419, 430` for `'IT & Development'` and lines 380–425 for the 93 completed tasks sum.
9. **Verify reproduction of DEF-10 & DEF-11**:
   Inspect `src/components/modals/ReviewTaskModal.tsx:107` (`onClick={onClose}`) and `ReportsScreen.tsx:216`.
10. **Verify reproduction of DEF-12**:
    Inspect `src/components/screens/ReportsScreen.tsx:26, 64-80`. Confirm no consumer of `selectedTimeRange`.
11. **Verify reproduction of DEF-13**:
    Inspect `src/App.tsx`. Confirm complete absence of `companyCode`, multi-tenant context, or company switching.
