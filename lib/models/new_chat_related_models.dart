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

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userId: json['userId'],
    );
  }
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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      type: json['type'],
      content: json['content'],
      sender: json['sender'],
      processed: json['processed'],
      chatId: json['chat_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'type': type,
      'content': content,
      'sender': sender,
      'processed': processed,
      'chat_id': chatId,
    };
  }
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

class UserDetails {
  final String userId;
  final Chat currentChat;

  UserDetails({
    required this.userId,
    required this.currentChat,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['user_id'],
      currentChat: Chat.fromJson(json['current_chat']),
    );
  }
}
