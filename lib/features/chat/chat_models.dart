class ChatMessage {
  final String sender; // "user" | "bot"
  final String text;
  final DateTime timestamp;

  ChatMessage({required this.sender, required this.text, required this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: (json['sender'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      timestamp: DateTime.tryParse((json['timestamp'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}

class ChatModel {
  final String id;
  final String title;
  final DateTime updatedAt;
  final List<ChatMessage> messages;

  ChatModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = (json['messages'] as List?) ?? const [];
    final messages = rawMessages
        .whereType<Map<String, dynamic>>()
        .map((m) => ChatMessage.fromJson(m))
        .toList();
    return ChatModel(
      id: (json['_id'] ?? '').toString(),
      title: (json['title'] ?? 'Новый чат').toString(),
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? '').toString()) ?? DateTime.now(),
      messages: messages,
    );
  }
}

