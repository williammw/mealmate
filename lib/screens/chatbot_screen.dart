import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../auth.dart';
import '../models/chat_message.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  String? _userId;
  late Map<String, PreviewData> _previewDataMap = {};
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    _userId = await Auth().getUserId();
  }

  Widget _buildMessageItem(ChatMessage message) {
    return ListTile(
      leading: Text(message.senderId),
      title: Text(message.content),
      subtitle: Text(message.timestamp.toString()),
    );
  }

  final _textController = TextEditingController();

  List<ChatMessage> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isUserMessage = message.senderId == _userId;

                late Widget messageWidget;
                switch (message.type) {
                  case MessageType.text:
                    messageWidget = Text(message.content);
                    break;
                  case MessageType.image:
                    messageWidget = Image.network(message.content);
                    break;
                  case MessageType.url:
                    messageWidget = LinkPreview(
                      enableAnimation: true,
                      onPreviewDataFetched: (data) {
                        setState(() {
                          _previewDataMap = {
                            ..._previewDataMap,
                            message.content: data,
                          };
                        });
                      },
                      previewData: _previewDataMap[message.content],
                      text: message.content,
                      width: MediaQuery.of(context).size.width * 0.9,
                    );
                    break;
                }

                // ...
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      final newMessage = ChatMessage(
                        id: Uuid().v4(),
                        chatId: _userId ?? '0', // Use _userId as chatId if _userId is not null
                        senderId: _userId ?? '0',
                        content: _textController.text,
                        type: MessageType.text,
                        status: MessageStatus.sent,
                        timestamp: DateTime.now(),
                      );
                      setState(() {
                        _messages.add(newMessage);
                      });
                      _textController.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
