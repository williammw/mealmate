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
import 'package:timeago/timeago.dart' as timeago;

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
  final botAvatarUrl = 'https://i.pravatar.cc/300?u=a042581f4e2902670';
  final userAvatarUrl = 'https://i.pravatar.cc/300?u=n0283oji';
  bool _isComposing = false; // Added to track whether the user has input
  bool _isProcessing = false; // Add this to your state variables.

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
      messages: [
        Message(
          messageId: '', // Placeholder, actual value should be provided by the server.
          createdAt: DateTime.now(), // Placeholder, actual value should be provided by the server.
          updatedAt: DateTime.now(), // Place`holder, actual value should be provided by the server.
          type: 'text', // Assuming a simple text message.
          content: '',
          sender: tempUserId,
          processed: false, // Placeholder, actual value should be provided by the server.
          chatId: newChatResponse['chatId'],
        )
      ],
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
      Logger().d('message length ${messages.length}');
      setState(() {
        _chatHistory = messages;
      });
    }
  }

  Future<void> _handleSubmitted(String text) async {
    Logger().i('_handleSubmitted $text');
    Logger().i('_handleSubmitted _currentChat $_currentChat');
    _isProcessing = true;
    setState(() => {});
    // _textController.clear();

    String? tempUserId = await Auth().getUserId();
    UserDetailsProvider userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    await userDetailsProvider.fetchUserDetails(tempUserId!);
    User? userDetails = userDetailsProvider.userDetails;
    Logger().d('DUI la Sing ${userDetails?.toJson()}');
    Logger().e('tempUserId $tempUserId');
    // Step 1: Create a new Message object.
    Message newMessage = Message(
      messageId: '', // Placeholder, actual value should be provided by the server.
      createdAt: DateTime.now(), // Placeholder, actual value should be provided by the server.
      updatedAt: DateTime.now(), // Place`holder, actual value should be provided by the server.
      type: 'text', // Assuming a simple text message.
      content: text,
      sender: tempUserId,
      processed: false, // Placeholder, actual value should be provided by the server.
      chatId: userDetails!.currentChatId,
    );
    // setState(() {
    //   _chatHistory.insert(0, newMessage);
    // });
    setState(() {
      _isComposing = false; // Reset _isComposing when the message is submitted
      _chatHistory.insert(0, newMessage);
    });
    _textController.clear();

    // Step 2: Store the user's message to the server.
    print('Storing message to server...');
    await Api.storeMessage(tempUserId, userDetails!.currentChatId, newMessage);
    print('Message stored.');

    // Step 3: Send the message to the server. to oppenAI API
    print('Sending message to server...');
    Message botResponse = await Api().sendMessage(newMessage, 'zh-hk');
    print('Received response from server.');

    // Step 4: Store the bot's message to the server.
    print('Storing bot message to server...');
    await Api.storeMessage(tempUserId, userDetails!.currentChatId, botResponse);
    print('Bot message stored.');

    _isProcessing = false;
    // Step 5: Add the new messages to the chat history.
    setState(() {
      print('Adding messages to chat history...');
      // Insert the user's message first.
      // _chatHistory.insert(0, newMessage);
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
          title: const Text('Chatbot'),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: Stack(
                children: [
                  ListView.builder(
                    // padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: _chatHistory.length + (_isProcessing ? 1 : 0),
                    itemBuilder: (_, int index) {
                      if (_isProcessing && index == 0) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }
                      var message = _chatHistory[index];
                      bool isBot = message.sender == 'bot' ? true : false;
                      final messageTime = timeago.format(message.createdAt, locale: 'en_short');
                      return Container(
                        color: isBot ? Colors.grey[400] : Colors.grey[300],
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: isBot ? CircleAvatar(backgroundImage: NetworkImage(botAvatarUrl)) : null,
                          trailing: isBot ? null : CircleAvatar(backgroundImage: NetworkImage(userAvatarUrl)),
                          title: Align(
                            alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                            child: Text(message.content),
                          ),
                          subtitle: Align(
                            alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                            child: Text(messageTime),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.paperPlane),
                onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
