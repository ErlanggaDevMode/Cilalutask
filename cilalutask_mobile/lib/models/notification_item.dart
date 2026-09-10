class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final bool unread;
  final String type; // 'sop' | 'task' | 'deadline' | 'urgent'

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.unread = true,
    required this.type,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    bool? unread,
    String? type,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      unread: unread ?? this.unread,
      type: type ?? this.type,
    );
  }
}
