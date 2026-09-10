class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String senderRole;
  final String content;
  final String time;
  final DateTime timestamp;
  final String? channelId;
  final String? receiverId;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.senderRole,
    required this.content,
    required this.time,
    required this.timestamp,
    this.channelId,
    this.receiverId,
  });
}

class ChatChannel {
  final String id;
  final String name;
  final String description;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  const ChatChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  ChatChannel copyWith({
    String? id,
    String? name,
    String? description,
    String? lastMessage,
    String? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatChannel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
