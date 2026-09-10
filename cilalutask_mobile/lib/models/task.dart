import 'employee.dart';

enum PriorityType {
  high('Prioritas Tinggi'),
  medium('Prioritas Sedang'),
  low('Prioritas Rendah');

  final String label;
  const PriorityType(this.label);

  static PriorityType fromString(String value) {
    switch (value) {
      case 'Prioritas Tinggi':
        return PriorityType.high;
      case 'Prioritas Rendah':
        return PriorityType.low;
      case 'Prioritas Sedang':
      default:
        return PriorityType.medium;
    }
  }
}

enum TaskStatus {
  notStarted('Belum Dimulai'),
  inProgress('Dalam Proses'),
  completed('Selesai');

  final String label;
  const TaskStatus(this.label);

  static TaskStatus fromString(String value) {
    switch (value) {
      case 'Belum Dimulai':
        return TaskStatus.notStarted;
      case 'Selesai':
        return TaskStatus.completed;
      case 'Dalam Proses':
      default:
        return TaskStatus.inProgress;
    }
  }
}

class Subtask {
  final String id;
  final String title;
  final bool completed;

  const Subtask({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Subtask copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String division;
  final PriorityType priority;
  final TaskStatus status;
  final String deadlineLabel;
  final bool isUrgentDeadline;
  final bool isToday;
  final List<Subtask> subtasks;
  final Assignee assignee;
  final int progressPercent;
  final String? updatedAt;
  final bool needsReview;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.division,
    required this.priority,
    required this.status,
    required this.deadlineLabel,
    this.isUrgentDeadline = false,
    this.isToday = false,
    required this.subtasks,
    required this.assignee,
    required this.progressPercent,
    this.updatedAt,
    this.needsReview = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? division,
    PriorityType? priority,
    TaskStatus? status,
    String? deadlineLabel,
    bool? isUrgentDeadline,
    bool? isToday,
    List<Subtask>? subtasks,
    Assignee? assignee,
    int? progressPercent,
    String? updatedAt,
    bool? needsReview,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      division: division ?? this.division,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      deadlineLabel: deadlineLabel ?? this.deadlineLabel,
      isUrgentDeadline: isUrgentDeadline ?? this.isUrgentDeadline,
      isToday: isToday ?? this.isToday,
      subtasks: subtasks ?? this.subtasks,
      assignee: assignee ?? this.assignee,
      progressPercent: progressPercent ?? this.progressPercent,
      updatedAt: updatedAt ?? this.updatedAt,
      needsReview: needsReview ?? this.needsReview,
    );
  }
}
