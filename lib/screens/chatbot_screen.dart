import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    Future.wait([
      _initializeUserData(),
      _initializeChatData(),
    ]);
  }

  Future<void> _loadMessages() async {
    var messages = await Api.getMessagesForChat(_currentChat!.chatId);
    setState(() {
      _chatHistory = messages;
    });
  }

  Future<void> _initializeChatData() async {
    List<Chat> userChats = await Auth().getChatsForUser(_userId);
    var chatData = await Api.createNewChat(_userId);

    if (chatData.containsKey('chat_id')) {
      _currentChat = Chat(
        chatId: chatData['chat_id'],
        createdAt: DateTime.parse(chatData['created_at']),
        updatedAt: DateTime.parse(chatData['updated_at']),
        userId: _userId,
      );
    } else {
      var userChats = await Auth().getChatsForUser(_userId);
      if (userChats.isNotEmpty) {
        _currentChat = userChats.first;
      }
    }
  }

  Future<void> _initializeUserData() async {
    String? tempUserId = await Auth().getUserId();
    if (tempUserId != null) {
      _userId = tempUserId;
    } else {
      // Handle the situation when userId is null. Maybe show a message to the user or redirect them to the login screen.
    }
    // defined and default was 'en'
    _userLanguage = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ChatBot Screen'),
        ),
        body: const Center(
          child: Text('ChatBot Screen'),
        ),
      ),
    );
  }
}
