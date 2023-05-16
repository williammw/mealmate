class User {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.createdAt,
  });
}

class Chat {
  final String chatId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  Chat({
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });
}

class Message {
  final String messageId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String type;
  final String content;
  final String sender;
  final bool processed;
  final String chatId;

  Message({
    required this.messageId,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.content,
    required this.sender,
    required this.processed,
    required this.chatId,
  });
}

class Response {
  final String responseId;
  final String content;
  final DateTime createdAt;
  final String messageId;

  Response({
    required this.responseId,
    required this.content,
    required this.createdAt,
    required this.messageId,
  });
}

class Summary {
  final String summaryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final String chatId;

  Summary({
    required this.summaryId,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.chatId,
  });
}
