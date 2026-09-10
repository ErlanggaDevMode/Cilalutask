import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/sop.dart';
import '../models/activity.dart';
import '../models/employee.dart';
import '../models/notification_item.dart';
import '../data/mock_data.dart';

class AppStateController extends ChangeNotifier {
  int _currentTabIndex = 0;
  List<Task> _tasks = List.from(kInitialTasks);
  List<SOPDocument> _sops = List.from(kInitialSops);
  List<ActivityItem> _activities = List.from(kInitialActivities);
  List<NotificationItem> _notifications = List.from(kNotificationsData);
  final CurrentUser _currentUser = kCurrentUser;
  final List<Assignee> _employees = List.from(kEmployees);

  // Getters
  int get currentTabIndex => _currentTabIndex;
  List<Task> get tasks => List.unmodifiable(_tasks);
  List<SOPDocument> get sops => List.unmodifiable(_sops);
  List<ActivityItem> get activities => List.unmodifiable(_activities);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  CurrentUser get currentUser => _currentUser;
  List<Assignee> get employees => List.unmodifiable(_employees);

  int get activeReviewCount => _tasks.where((t) => t.needsReview).length;
  int get unreadNotificationsCount => _notifications.where((n) => n.unread).length;

  void setTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void createTask(Task newTask) {
    _tasks = [newTask, ..._tasks];

    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: _currentUser.name,
      userAvatar: _currentUser.avatar,
      actionPrefix: 'menerbitkan tugas baru',
      targetObject: newTask.title,
      timeAgo: 'Baru saja',
      department: newTask.division,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
  }

  void saveProgress(String taskId, List<Subtask> updatedSubtasks, int progressPercent) {
    _tasks = _tasks.map((t) {
      if (t.id == taskId) {
        final isDone = progressPercent == 100;
        return t.copyWith(
          subtasks: updatedSubtasks,
          progressPercent: progressPercent,
          status: isDone ? TaskStatus.completed : TaskStatus.inProgress,
        );
      }
      return t;
    }).toList();

    final target = _tasks.firstWhere((t) => t.id == taskId);
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: target.assignee.name,
      userAvatar: target.assignee.avatar,
      actionPrefix: 'memperbarui progres tugas',
      targetObject: target.title,
      actionSuffix: 'ke $progressPercent%.',
      timeAgo: 'Baru saja',
      department: target.division,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
  }

  void approveTask(String taskId) {
    _tasks = _tasks.map((t) {
      if (t.id == taskId) {
        return t.copyWith(
          status: TaskStatus.completed,
          progressPercent: 100,
          subtasks: t.subtasks.map((st) => st.copyWith(completed: true)).toList(),
          needsReview: false,
        );
      }
      return t;
    }).toList();

    final target = _tasks.firstWhere((t) => t.id == taskId);
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: _currentUser.name,
      userAvatar: _currentUser.avatar,
      actionPrefix: 'menyetujui & menyelesaikan tugas',
      targetObject: target.title,
      timeAgo: 'Baru saja',
      department: target.division,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
  }

  void addSop(SOPDocument newSop) {
    _sops = [newSop, ..._sops];

    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: _currentUser.name,
      userAvatar: _currentUser.avatar,
      actionPrefix: 'menerbitkan SOP baru',
      targetObject: newSop.title,
      timeAgo: 'Baru saja',
      department: newSop.category,
      type: 'sop',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
  }

  void confirmReadSop(String sopId) {
    _sops = _sops.map((s) {
      if (s.id == sopId) {
        final currentPct = s.readProgressPercent ?? 94;
        final nextPct = (currentPct + 6).clamp(0, 100);
        return s.copyWith(
          isReadByMe: true,
          readProgressPercent: nextPct,
          isUrgentMandatory: false,
        );
      }
      return s;
    }).toList();

    final targetSop = _sops.firstWhere((s) => s.id == sopId);
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: _currentUser.name,
      userAvatar: _currentUser.avatar,
      actionPrefix: 'memverifikasi kepatuhan SOP',
      targetObject: targetSop.title,
      timeAgo: 'Baru saja',
      department: targetSop.category,
      type: 'sop',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
  }

  void toggleBookmarkSop(String sopId) {
    _sops = _sops.map((s) {
      if (s.id == sopId) {
        return s.copyWith(isBookmarked: !s.isBookmarked);
      }
      return s;
    }).toList();

    notifyListeners();
  }

  void sendBroadcast(String message, String targetDivision) {
    final preview = message.length > 35 ? '${message.substring(0, 35)}...' : message;
    final newActivity = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      userName: _currentUser.name,
      userAvatar: _currentUser.avatar,
      actionPrefix: 'mengirim broadcast ($targetDivision):',
      targetObject: '"$preview"',
      timeAgo: 'Baru saja',
      department: targetDivision,
      type: 'task',
    );
    _activities = [newActivity, ..._activities];

    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(unread: false)).toList();
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    _notifications = _notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(unread: false);
      }
      return n;
    }).toList();
    notifyListeners();
  }
}
