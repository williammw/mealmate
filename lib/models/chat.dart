// class Chat {
//   final String id;
//   final List<Message> messages;
//   final DateTime timestamp;

//   Chat({required this.id, required this.messages, required this.timestamp});

//   factory Chat.fromJson(Map<String, dynamic> json) {
//     return Chat(
//       id: json['id'],
//       messages: (json['messages'] as List<dynamic>).map((e) => Message.fromJson(e as Map<String, dynamic>)).toList(),
//       timestamp: DateTime.parse(json['timestamp']),
//     );
//   }
// }

// class Message {
//   final String senderId;
//   final String content;
//   final DateTime timestamp;

//   Message({required this.senderId, required this.content, required this.timestamp});

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       senderId: json['senderId'],
//       content: json['content'],
//       timestamp: DateTime.parse(json['timestamp']),
//     );
//   }
// }
