// class ChatMessage {
//   final String id; // Unique ID for this message
//   final String chatId; // ID of the conversation this message belongs to
//   final String senderId; // ID of the user who sent this message // 0 = user, 1 = bot
//   final String content; // Content of the message
//   final MessageType type; // Type of the message (text, image, video, etc.)
//   final MessageStatus status; // Status of the message (sent, delivered, read)
//   final List<Attachment> attachments; // Any attachments included with this message
//   final DateTime timestamp; // When the message was sent

//   ChatMessage({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.content,
//     required this.type,
//     required this.status,
//     this.attachments = const [],
//     required this.timestamp,
//   });

//   // Add methods for serialization/deserialization as needed
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'chatId': chatId,
//       'senderId': senderId,
//       'content': content,
//       'type': type.index,
//       'status': status.index,
//       'attachments': attachments.map((a) => a.toMap()).toList(),
//       'timestamp': timestamp.toIso8601String(),
//     };
//   }

//   ChatMessage.fromMap(Map<String, dynamic> map)
//       : id = map['id'],
//         chatId = map['chatId'],
//         senderId = map['senderId'],
//         content = map['content'],
//         type = MessageType.values[map['type']],
//         status = MessageStatus.values[map['status']],
//         attachments = (map['attachments'] as List).map((a) => Attachment.fromMap(a)).toList(),
//         timestamp = DateTime.parse(map['timestamp']);
// }

// enum MessageType {
//   text,
//   image,
//   video,
//   url,
//   // Add more as needed
// }

// enum MessageStatus {
//   sent,
//   delivered,
//   read,
// }

// class Attachment {
//   final String id; // Unique ID for this attachment
//   final String url; // Where the attachment file is stored
//   final AttachmentType type; // Type of the attachment (image, video, etc.)

//   Attachment({
//     required this.id,
//     required this.url,
//     required this.type,
//   });

//   // Add methods for serialization/deserialization as needed
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'url': url,
//       'type': type.index,
//     };
//   }

//   Attachment.fromMap(Map<String, dynamic> map)
//       : id = map['id'],
//         url = map['url'],
//         type = AttachmentType.values[map['type']];
// }

// enum AttachmentType {
//   image,
//   video,
//   // Add more as needed
// }

// class Response {
//   final String content;
//   final DateTime? createdAt;

//   const Response({required this.content, this.createdAt});
// }
