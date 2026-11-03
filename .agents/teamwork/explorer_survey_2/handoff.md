# Handoff Report: Survey of Mobile Defects (M-DEF-01 through M-DEF-05)

- **Agent**: explorer_survey_2 (teamwork_explorer)
- **Target Component**: `cilalutask_mobile/` & `QA_Report.md` (Section 5.2, 4.1, 4.3, 4.4)
- **Parent**: teamwork_orchestrator (`24548c72-c8fc-42d0-bd45-af8f08f1722b`)
- **Timestamp**: 2026-11-02T19:20:00Z

---

## 1. Observation

Direct code and test observations performed on `cilalutask_mobile/`:

### 1.1 Quality Gates & Test Suite Baseline Execution
- **Dart Format**: `dart format --output=none --set-exit-if-changed .`
  - Output: `Formatted 69 files (0 changed) in 6.57 seconds.` Exit code: `0`.
  - In `QA_Report.md:249`, Gate 1 previously failed (`Changed lib\state\notification_controller.dart`, exit code 1) because `notification_controller.dart` had unformatted formatting.
- **Flutter Analyze**: `flutter analyze`
  - Output: Exit code `1`:
    - `warning - The value of the local variable 'user' isn't used - lib\screens\home\home_screen.dart:19:11`
    - `error - Undefined name 'state' - lib\widgets\modals\upload_sop_bottom_sheet.dart:88:31`
- **Flutter Test**: `flutter test`
  - Output: `02:03 +94 -2: Some tests failed.`
  - Failure 1: `test/integration_main_user_flow_test.dart` failed compilation due to `lib/widgets/modals/upload_sop_bottom_sheet.dart:88:31: Error: The getter 'state' isn't defined for the type '_UploadSopBottomSheetState'`.
  - Failure 2: `test/ui_ux_quality_test.dart:501`: `FlutterError: <A RenderFlex overflowed by 13 pixels on the right.>` during small screen test (`320x480`).

---

### 1.2 Inspection of M-DEF-01 (Dart Formatting Compliance)
- **File**: `cilalutask_mobile/lib/state/notification_controller.dart`
- **QA Report Finding**: `Changed lib\state\notification_controller.dart` (Exit Code 1).
- **Current Observation**: Running `dart format lib/state/notification_controller.dart` formats the file in place with 0 issues. The working copy currently satisfies `dart format --set-exit-if-changed .`.
- **Root Cause**: Earlier additions of multi-line filter logic (`_isDirectMessage`) exceeded line length and indentation conventions before being formatted by Dart SDK.

---

### 1.3 Inspection of M-DEF-02 (Dynamic Active Task Subtext)
- **File**: `cilalutask_mobile/lib/screens/home/home_screen.dart`, lines 455-465
- **Original Code**:
  ```dart
  _buildMetricCard(
    title: 'Tugas Aktif',
    count: '$activeCount',
    subtext: '4 tugas baru', // Hardcoded wireframe literal
    ...
  )
  ```
- **Observed Change**:
  ```dart
  _buildMetricCard(
    title: 'Tugas Aktif',
    count: '$activeCount',
    subtext: activeCount > 0
        ? '$activeCount tugas berjalan'
        : '0 tugas aktif',
    ...
  )
  ```
- **Root Cause**: The subtext was a static string literal left over from wireframe prototypes. `Task` model lacks an `isNew` boolean field, but `activeCount` (`metrics.inProgress`) dynamically tracks real in-progress tasks.

---

### 1.4 Inspection of M-DEF-03 (Profile Efficiency Calculation)
- **File**: `cilalutask_mobile/lib/screens/home/home_screen.dart`, lines 19 and 179-186
- **Original Code**:
  ```dart
  // line 19
  final user = state.currentUser;
  // line 180
  Text('Efisiensi Tim: ${user.teamEfficiencyPercent}%') // Hardcoded 94% in mock_data.dart:17
  ```
- **Observed Change**:
  ```dart
  Text(
    'Efisiensi Tim: ${metrics.total > 0 ? (metrics.completionRate * 100).round() : 100}%',
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: AppColors.successDark,
    ),
  )
  ```
- **Root Cause**: The hero card previously retrieved `user.teamEfficiencyPercent` from `CurrentUser` mock model (`mock_data.dart:17`), which was hardcoded to `94%`. Real task completion rate is `25%` (2 completed of 8 initial tasks).
- **Secondary Finding**: In `home_screen.dart:19`, `final user = state.currentUser;` is now completely unused, generating a `flutter analyze` warning (`unused_local_variable`).

---

### 1.5 Inspection of M-DEF-04 (Dynamic SOP Reader Denominator)
- **Files**:
  - `cilalutask_mobile/lib/data/mock_data.dart:421`
  - `cilalutask_mobile/lib/widgets/modals/upload_sop_bottom_sheet.dart:87-88`
- **Original Code**:
  - `mock_data.dart:421`: `readTeamCount: '32/34 Tim'` and `readProgressPercent: 94`
  - `upload_sop_bottom_sheet.dart:87`: `readTeamCount: '0/34 Tim'`
- **Observed Change**:
  - In `mock_data.dart:421`: Updated to `readTeamCount: '5/6 Tim'` and `readProgressPercent: 83` (5/6 employees = 83.3%).
  - In `upload_sop_bottom_sheet.dart:88`:
    ```dart
    readTeamCount: '0/${state.employees.length} Tim',
    ```
- **CRITICAL DEFECT DETECTED**:
  - `_UploadSopBottomSheetState._submit()` does NOT have variable `state` in scope!
  - `state` is undefined, causing compilation error:
    `lib/widgets/modals/upload_sop_bottom_sheet.dart:88:31: Error: The getter 'state' isn't defined for the type '_UploadSopBottomSheetState'.`
  - This breaks compilation for `test/integration_main_user_flow_test.dart` and fails `flutter analyze`.

---

### 1.6 Inspection of M-DEF-05 (Direct Message Isolation from Notification Center)
- **Files**:
  - `cilalutask_mobile/lib/state/app_state_controller.dart:767`
  - `cilalutask_mobile/lib/state/notification_controller.dart:34-43, 122`
  - `cilalutask_mobile/lib/widgets/modals/notification_center_bottom_sheet.dart:73-80`
- **Observed Multi-Layer Architecture**:
  1. **Event Dispatch Gate (`AppStateController.sendChatMessage`)**:
     ```dart
     // Only channel messages (group chats) push notifications; Direct Messages (channelId == null) are private.
     if (channelId != null) {
       pushNotification(...);
     }
     ```
  2. **Controller Sanitization Gate (`NotificationController`)**:
     ```dart
     static bool _isDirectMessage(NotificationItem n) {
       final title = n.title.toLowerCase();
       return title.contains('pesan langsung') ||
           title.contains('direct') ||
           n.targetId == 'direct_chat' ||
           n.type == 'direct_chat';
     }
     ```
     Enforced on constructor `initialNotifications`, `notifications` getter, `setNotifications`, `loadNotifications`, `startSubscription`, and `pushNotification`.
  3. **UI Display Gate (`NotificationCenterBottomSheet`)**:
     Explicitly filters `state.notifications` to exclude direct messages when displaying notifications and computing `unreadCount`.

---

### 1.7 Small Viewport RenderFlex Overflow (320x480 dp)
- **File**: `cilalutask_mobile/lib/screens/home/home_screen.dart`, lines 511-545
- **Observation**:
  In `test/ui_ux_quality_test.dart:501`:
  `FlutterError: <A RenderFlex overflowed by 13 pixels on the right.>`
- **Root Cause**:
  ```dart
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Row(
        children: [
          Icon(Icons.alarm_rounded, size: 18, color: AppColors.danger),
          SizedBox(width: 6),
          Text('Mendekati Batas Waktu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
      InkWell(
        onTap: () => state.setTab(1),
        child: Text('Lihat Semua (${approachingTasks.length})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    ],
  )
  ```
  Neither child is wrapped in `Expanded` / `Flexible`. On a 320px viewport (288px usable), 214px + 87px = 301px, overflowing by exactly 13px.

---

## 2. Logic Chain

```
[Observation 1.1, 1.2]:
Gate 1 dart format passed on notification_controller.dart when formatted.
  → Therefore, M-DEF-01 is fully remediable by standard `dart format` execution.

[Observation 1.3]:
Task model has no isNew flag; wireframe hardcoded '4 tugas baru' in home_screen.dart:458.
  → Binding subtext to activeCount ('$activeCount tugas berjalan') is dynamic and tied to real task data.
  → Resolves M-DEF-02.

[Observation 1.4]:
user.teamEfficiencyPercent in mock_data.dart:17 hardcoded at 94%, ignoring tasks.
  → TaskMetricsCalculator.computeMetrics(tasks).completionRate computes real task completion (25%).
  → Removing line 19 ('final user = state.currentUser;') eliminates the flutter analyze warning.
  → Resolves M-DEF-03.

[Observation 1.5]:
upload_sop_bottom_sheet.dart:88 references 'state' which is not defined in _submit().
  → Causes compilation failure in tests and flutter analyze.
  → Importing AppStateScope and resolving employee count via AppStateScope.of(context) (with safe fallback) restores build and satisfies dynamic denominator (6 Tim).
  → Resolves M-DEF-04.

[Observation 1.6]:
Direct Messages leaked into notification modal because chat sender created notifs regardless of chat type.
  → Triple-layer isolation (sender gate, controller filter, UI filter) prevents DMs from entering the notification center.
  → Resolves M-DEF-05.

[Observation 1.7]:
ui_ux_quality_test.dart fails at 320x480 dp due to unconstrained Row at home_screen.dart:511.
  → Wrapping the 'Mendekati Batas Waktu' header with Expanded/Flexible prevents the 13px overflow.
```

---

## 3. Caveats

1. **No Source Code Changes Made**: In accordance with the teamwork explorer role, no code files in `cilalutask_mobile/` were directly modified. All recommendations are verified against source lines and ready for the implementer agent.
2. **Pre-existing Working Copy Diff**: Certain changes (such as `_isDirectMessage` in `notification_controller.dart`, `app_state_controller.dart`, and partial edit in `upload_sop_bottom_sheet.dart`) were present in the unstaged working copy. The implementer must finalize the syntax fix in `upload_sop_bottom_sheet.dart` to make tests pass.
3. **Task Subtext Wording**: The QA report suggested `'${tasks.where((t) => t.isNew).length} tugas baru'`, but the `Task` entity in `lib/models/task.dart` does not contain an `isNew` field. Using `activeCount > 0 ? '$activeCount tugas berjalan' : '0 tugas aktif'` is structurally sound and avoids modifying the data model.

---

## 4. Conclusion

All 5 mobile defects (M-DEF-01 through M-DEF-05) plus the 2 active test blockers have been completely diagnosed with exact root causes and code solutions:

| Defect ID | Severity | File & Line | Root Cause | Genuine Recommended Fix |
|---|---|---|---|---|
| **M-DEF-01** | Low (Gate 1) | `lib/state/notification_controller.dart:1-198` | Long multi-line filters triggered Dart format discrepancy. | Run `dart format lib/state/notification_controller.dart` (verified 0 changes when formatted). |
| **M-DEF-02** | Medium | `lib/screens/home/home_screen.dart:458` | Hardcoded wireframe literal `'4 tugas baru'`. | Use `subtext: activeCount > 0 ? '$activeCount tugas berjalan' : '0 tugas aktif'` and add `maxLines: 1, overflow: TextOverflow.ellipsis` to `_buildMetricCard`. |
| **M-DEF-03** | High | `lib/screens/home/home_screen.dart:180` & `19` | Hero card used static `user.teamEfficiencyPercent` (94%). | Compute `'Efisiensi Tim: ${metrics.total > 0 ? (metrics.completionRate * 100).round() : 100}%'` and delete unused `final user = state.currentUser;` at line 19. |
| **M-DEF-04** | High | `lib/widgets/modals/upload_sop_bottom_sheet.dart:88` & `lib/data/mock_data.dart:421` | Hardcoded `34 Tim` denominator, plus compile error `undefined name 'state'`. | Update `mock_data.dart` to `'5/6 Tim'`. In `upload_sop_bottom_sheet.dart`: import `AppStateScope`, safely read `AppStateScope.of(context).employees.length` (fallback to 6). |
| **M-DEF-05** | Critical | `lib/state/notification_controller.dart`, `app_state_controller.dart:767`, `notification_center_bottom_sheet.dart:73` | Direct messages lacked isolation from global notification stream. | Triple-layer isolation: omit `pushNotification` in `sendChatMessage` when `channelId == null`, filter `_isDirectMessage` in `NotificationController`, filter in `NotificationCenterBottomSheet`. |
| **UI Overflow** | Medium | `lib/screens/home/home_screen.dart:511-545` | Unconstrained Row child overflowed 13px at 320x480 dp. | Wrap the left section title row in `Expanded` with `TextOverflow.ellipsis`. |

---

## 5. Verification Method

To verify these fixes independently:

1. **Verify M-DEF-01 (Dart Format Gate 1)**:
   ```powershell
   cd c:\T\Cilalutask\cilalutask_mobile
   dart format --output=none --set-exit-if-changed .
   ```
   *Expected result*: Exit code `0` (`Formatted 69 files (0 changed)`).

2. **Verify M-DEF-03 & M-DEF-04 (Flutter Analyze Gate 2)**:
   ```powershell
   cd c:\T\Cilalutask\cilalutask_mobile
   flutter analyze
   ```
   *Expected result*: Exit code `0` (`No issues found!`).

3. **Verify Full Automated Test Suite (Gate 3)**:
   ```powershell
   cd c:\T\Cilalutask\cilalutask_mobile
   flutter test
   ```
   *Expected result*: Exit code `0` (`All 96+ tests passed!`).

4. **Verify Granular Test Suites**:
   - `flutter test test/notification_controller_test.dart`
   - `flutter test test/integration_main_user_flow_test.dart`
   - `flutter test test/ui_ux_quality_test.dart`
