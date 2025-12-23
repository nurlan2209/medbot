class SavedItem {
  final String id;
  final String type;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? chatId;

  const SavedItem({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.chatId,
  });

  factory SavedItem.fromJson(Map<String, dynamic> json) {
    return SavedItem(
      id: (json['_id'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      chatId: json['chatId']?.toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}

