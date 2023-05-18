import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mealmate/providers/language_notifer.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../auth.dart';
import '../models/new_chat_related_models.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  String _userId = '';
  String _userLanguage = '';
  List<Message> _chatHistory = [];
  String _currentInput = '';
  Chat? _currentChat;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _initializeUserAndChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _initializeUserAndChat() async {
    // Fetch user details and current chat from your backend
    var userDetails = await Api().getUserDetails();

    if (userDetails != null) {
      setState(() {
        _userId = userDetails.userId;
        _currentChat = Chat(
          chatId: userDetails.currentChat.chatId,
          createdAt: userDetails.currentChat.createdAt,
          updatedAt: userDetails.currentChat.updatedAt,
          userId: _userId,
        );
      });
    }
  }

  Future<void> _loadMessages() async {
    Api api = Api();
    var messages = await api.getMessagesForChat(_currentChat!.chatId, 20);
    setState(() {
      _chatHistory = messages;
    });
  }

  // Future<void> _initializeChatData() async {
  //   List<Chat> userChats = await Auth().getChatsForUser(_userId);
  //   var chatData = await Api.createNewChat(_userId);

  //   if (chatData.containsKey('chat_id')) {
  //     _currentChat = Chat(
  //       chatId: chatData['chat_id'],
  //       createdAt: DateTime.parse(chatData['created_at']),
  //       updatedAt: DateTime.parse(chatData['updated_at']),
  //       userId: _userId,
  //     );
  //   } else {
  //     var userChats = await Auth().getChatsForUser(_userId);
  //     if (userChats.isNotEmpty) {
  //       _currentChat = userChats.first;
  //     }
  //   }
  // }

  // Future<void> _initializeUserData() async {
  //   String? tempUserId = await Auth().getUserId();
  //   print(tempUserId);
  //   if (tempUserId != null) {
  //     _userId = tempUserId;
  //   } else {
  //     // Handle the situation when userId is null. Maybe show a message to the user or redirect them to the login screen.
  //   }
  //   // defined and default was 'en'R
  //   _userLanguage = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
  // }

  Future<void> _handleSubmitted(String text) async {
    if (_currentChat == null) {
      print("Error: _currentChat is null");
      return;
    }

    _textController.clear();

    // Do something with the text message
    // For example, you can send the message to the server
    // and add the message to the chat history.

    // Step 1: Create a new Message object.
    Message newMessage = Message(
      messageId: '', // Placeholder, actual value should be provided by the server.
      createdAt: DateTime.now(), // Placeholder, actual value should be provided by the server.
      updatedAt: DateTime.now(), // Placeholder, actual value should be provided by the server.
      type: 'text', // Assuming a simple text message.
      content: text,
      sender: _userId,
      processed: false, // Placeholder, actual value should be provided by the server.
      chatId: _currentChat!.chatId,
    );

    // Step 2: Send the message to the server.
    // Replace this with your actual function to send the message to your server.
    await Api().sendMessage(newMessage);

    // Step 3: Add the new message to the chat history.
    setState(() {
      _chatHistory.insert(0, newMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chatbot'),
        ),
        body: Column(
          children: <Widget>[
            // This Flexible widget contains the ListView for chat messages.
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true, // To keep the latest messages at the bottom
                itemCount: _chatHistory.length,
                itemBuilder: (_, int index) {
                  var message = _chatHistory[index];
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text('Sent at ${message.createdAt}'),
                  );
                },
              ),
            ),
            // A divider to separate the chat area and the text input field.
            Divider(height: 1.0),
            // The container for the text input field.
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

// Returns the widget for text input field.
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // The text input field.
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            // The send button.
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.paperPlane),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
