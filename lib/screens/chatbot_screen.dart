import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mealmate/providers/language_notifer.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../auth.dart';
import '../models/new_chat_related_models.dart';
import '../providers/userdetails_notifer.dart';
import 'package:http_parser/http_parser.dart';

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
    // final storage = const FlutterSecureStorage();
    // await storage.delete(key: 'authToken');
    Logger().d('Initializing user and chat...');

    String? tempUserId = await Auth().getUserId();
    Logger().d('tempUserId   $tempUserId');

    // Fetch user details and current chat from your backend
    // User userDetails = await Api().getUserDetails(tempUserId!);
    // User userDetails = User.fromJson(userDetailsMap);

    // switch fetch to using providor
    UserDetailsProvider userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    await userDetailsProvider.fetchUserDetails(tempUserId!);

    User? userDetails = userDetailsProvider.userDetails;
    if (userDetails != null) {
      // Use the user details
      Logger().d('UserDetailProvder object assessing ${userDetails.toJson()}');
      Logger().d('All User Details userDetails : ${userDetails.toJson()}');
      Logger().d('User Details currentChatId: ${userDetails.currentChatId.isEmpty}');

      if (userDetails.currentChatId.isNotEmpty) {
        print('inside curr chatID ${userDetails.currentChatId}');

        // _currentChat!.chatId = userDetails.currentChatId;
        String currentChatId = userDetails.currentChatId;

        // Now get the current chat using the chat ID
        Logger().d('getChat pass $currentChatId $tempUserId');

        // if (currentChatId != null) {
        //   print('inside111');
        //   try {
        //     print('insid22222');
        //     _currentChat = await Api.getChat(currentChatId, tempUserId);
        //   } catch (e) {
        //     print('insid333');
        //     Logger().d('No chat found for this user, creating a new chat.');
        //     _currentChat = await _createNewChat(tempUserId, userDetails);
        //   }
        // } else {
        //   print('inside444');
        //   Logger().d('No current chat for this user, creating a new chat.');
        //   _currentChat = await _createNewChat(tempUserId, userDetails);
        // }
        await _loadMessages();
      } else {
        Logger().i('No current chat for this user, creating a new chat.');
        _currentChat = await _createNewChat(tempUserId, userDetails);
      }
      // Assuming the User object contains the current chat ID.

      // You also need to load the chat messages for this chat, if any
    }
  }

  Future<Chat> _createNewChat(String tempUserId, User user) async {
    print('Getting UserId: $tempUserId');
    var newChatResponse = await Api.createNewChat(tempUserId);
    print('Created New Chat: $newChatResponse');
    Chat newChat = Chat(
      chatId: newChatResponse['chatId'],
      createdAt: HttpDate.parse(newChatResponse['chat']['createdAt']),
      updatedAt: HttpDate.parse(newChatResponse['chat']['updatedAt']),
      messages: [],
    );

    // update the user details with new chatId
    user.currentChatId = newChat.chatId;
    await Api.updateUserDetails(tempUserId, user);
    return newChat;
  }

  Future<void> _loadMessages() async {
    Logger().d('_loadMessages');
    String? tempUserId = await Auth().getUserId();
    UserDetailsProvider userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    await userDetailsProvider.fetchUserDetails(tempUserId!);
    User? userDetails = userDetailsProvider.userDetails;
    if (userDetails != null) {
      if (userDetails.currentChatId.isEmpty) {
        return;
      }

      Api api = Api();
      var messages = await api.getMessagesForChat(tempUserId, userDetails.currentChatId, 20);
      setState(() {
        _chatHistory = messages;
      });
    }
  }

  Future<void> _handleSubmitted(String text) async {
    Logger().i('_handleSubmitted $text');
    Logger().i('_handleSubmitted _currentChat $_currentChat');

    _textController.clear();

    String? tempUserId = await Auth().getUserId();
    UserDetailsProvider userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    await userDetailsProvider.fetchUserDetails(tempUserId!);
    User? userDetails = userDetailsProvider.userDetails;
    Logger().d('DUI la Sing ${userDetails?.toJson()}');
    // Step 1: Create a new Message object.
    Message newMessage = Message(
      messageId: '', // Placeholder, actual value should be provided by the server.
      createdAt: DateTime.now(), // Placeholder, actual value should be provided by the server.
      updatedAt: DateTime.now(), // Placeholder, actual value should be provided by the server.
      type: 'text', // Assuming a simple text message.
      content: text,
      sender: userDetails!.userId,
      processed: false, // Placeholder, actual value should be provided by the server.
      chatId: userDetails!.currentChatId,
    );

    // Step 2: Store the user's message to the server.
    print('Storing message to server...');
    await Api.storeMessage(userDetails!.userId, userDetails!.currentChatId, newMessage);
    print('Message stored.');

    // Step 3: Send the message to the server. to oppenAI API
    print('Sending message to server...');
    Message botResponse = await Api().sendMessage(newMessage, 'en');
    print('Received response from server.');

    // Step 4: Store the bot's message to the server.
    print('Storing bot message to server...');
    await Api.storeMessage(userDetails!.userId, userDetails!.currentChatId, botResponse);
    print('Bot message stored.');

    // Step 5: Add the new messages to the chat history.
    setState(() {
      print('Adding messages to chat history...');
      // Insert the user's message first.
      _chatHistory.insert(0, newMessage);
      // Then insert the bot's response.
      _chatHistory.insert(0, botResponse);
      print('Messages added to chat history.');
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
