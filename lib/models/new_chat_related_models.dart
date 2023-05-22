class User {
  final String userId;
  final String fullName;
  final String username;
  final String emailOrPhone;
  final String dateOfBirth;
  final String bio;
  final String peopleDining;
  final String? securityCode;
  final String avatarURL; // New field for avatar
  String currentChatId;
  String preferredLanguage;

  User({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.emailOrPhone,
    required this.dateOfBirth,
    required this.bio,
    required this.peopleDining,
    this.securityCode,
    required this.avatarURL, // New field for avatar
    required this.currentChatId,
    this.preferredLanguage = 'en',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      fullName: json['full_name'],
      username: json['username'],
      emailOrPhone: json['email_or_phone'],
      dateOfBirth: json['date_of_birth'],
      bio: json['bio'],
      peopleDining: json['people_dining'],
      securityCode: json['security_code'],
      avatarURL: json['avatar_url'], // New field for avatar
      currentChatId: json['current_chat_id'],
      preferredLanguage: json['preferred_language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'full_name': fullName,
      'username': username,
      'email_or_phone': emailOrPhone,
      'date_of_birth': dateOfBirth,
      'bio': bio,
      'people_dining': peopleDining,
      'security_code': securityCode,
      'avatar_url': avatarURL, // New field for avatar
      'current_chat_id': currentChatId,
      'preferred_language': preferredLanguage,
    };
  }
}

class Chat {
  late final String chatId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;

  Chat({
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    var messagesFromJson = json['messages'] as List;
    List<Message> messageList = messagesFromJson.map((i) => Message.fromJson(i)).toList();

    return Chat(
      chatId: json['chatId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      messages: messageList,
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

  Map<String, dynamic> toJson() {
    return {
      'user_id': this.userId,
      'current_chat_id': this.currentChat.chatId,
    };
  }
}
