class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final bool unread;
  final String type; // 'sop' | 'task' | 'deadline' | 'urgent' | 'chat' | 'review' | 'system'
  final String? senderName;
  final String? senderAvatar;
  final int? targetTab; // 0: Beranda, 1: Tugas, 2: SOP, 3: Laporan, 4: Chat, 5: Tim & Notif
  final String? targetId; // taskId, sopId, channelId
  final DateTime? timestamp;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.unread = true,
    required this.type,
    this.senderName,
    this.senderAvatar,
    this.targetTab,
    this.targetId,
    this.timestamp,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    bool? unread,
    String? type,
    String? senderName,
    String? senderAvatar,
    int? targetTab,
    String? targetId,
    DateTime? timestamp,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      unread: unread ?? this.unread,
      type: type ?? this.type,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      targetTab: targetTab ?? this.targetTab,
      targetId: targetId ?? this.targetId,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
