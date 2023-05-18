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
    Logger().d('Initializing user and chat...');

    String? tempUserId = await Auth().getUserId();
    Logger().d('tempUserId   $tempUserId');

    // Fetch user details and current chat from your backend
    var userDetails = await Api().getUserDetails(tempUserId!);
    Logger().d('userDetails $userDetails');

    // Assuming the User object contains the current chat ID.
    String currentChatId = userDetails.currentChatId;

    // Now get the current chat using the chat ID
    Logger().d('getChat pass $currentChatId $tempUserId');

    try {
      _currentChat = await Api.getChat(currentChatId, tempUserId);
      // You also need to load the chat messages for this chat
      await _loadMessages();
    } catch (e) {
      Logger().d('No chat found for this user, creating a new chat.');
      var newChatResponse = await Api.createNewChat(tempUserId);
      // Handle the new chat response. It should include chatId which you can use to set _currentChat.
      // You may need to modify your backend to return the created chatId in the response.
      // _currentChat = Chat.fromJson(newChatResponse);
    }
  }

  Future<void> _loadMessages() async {
    Api api = Api();
    var messages = await api.getMessagesForChat(_currentChat!.chatId, 20);
    setState(() {
      _chatHistory = messages;
    });
  }

  Future<void> _handleSubmitted(String text) async {
    Logger().i(text);
    if (_currentChat == null) {
      print("Error: _currentChat is null");
      // You might want to show an error message to the user or initialize the chat here.
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
