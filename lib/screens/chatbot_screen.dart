import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../auth.dart';
import '../models/new_chat_related_models.dart';
import '../providers/userdetails_notifer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<Message> _chatHistory = [];
  Chat? _currentChat;
  late TextEditingController _textController;
  final botAvatarUrl = 'https://i.pravatar.cc/300?u=a042581f4e2902670';
  final userAvatarUrl = 'https://i.pravatar.cc/300?u=n0283oji';
  bool _isComposing = false; // Added to track whether the user has input
  bool _isProcessing = false; // Add this to your state variables.
  late String tempUserId;
  late UserDetailsProvider userDetailsProvider;
  late User userDetails;
  // Create a focus node
  final FocusNode _focusNode = FocusNode();
  PopupMenuButton<String>? popupButton;
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

    tempUserId = (await Auth().getUserId())!;
    Logger().d('tempUserId   $tempUserId');

    // switch fetch to using providor
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    await userDetailsProvider.fetchUserDetails(tempUserId);
    userDetails = userDetailsProvider.userDetails!;
    Logger().d('UserDetailProvder object assessing ${userDetails.toJson()}');
    Logger().d('All User Details userDetails : ${userDetails.toJson()}');
    Logger().d('User Details currentChatId: ${userDetails.currentChatId.isEmpty}');

    if (userDetails.currentChatId.isNotEmpty) {
      Logger().i('inside curr chatID ${userDetails.currentChatId}');

      // _currentChat!.chatId = userDetails.currentChatId;
      String currentChatId = userDetails.currentChatId;

      // Now get the current chat using the chat ID
      Logger().d('getChat pass $currentChatId $tempUserId');

      await _loadMessages();
    } else {
      Logger().i('No current chat for this user, creating a new chat.');
      _currentChat = await _createNewChat(tempUserId, userDetails);
    }
  }

  Future<Chat> _createNewChat(String tempUserId, User user) async {
    Logger().i('Getting UserId: $tempUserId');
    var newChatResponse = await Api.createNewChat(tempUserId);
    Logger().i('Created New Chat: $newChatResponse');
    Chat newChat = Chat(
      chatId: newChatResponse['chatId'],
      createdAt: DateTime.parse(newChatResponse['chat']['createdAt']),
      updatedAt: DateTime.parse(newChatResponse['chat']['updatedAt']),
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
    Logger().d('DUI la Sing ${userDetails.toJson()}');
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
      chatId: userDetails.currentChatId,
    );
    setState(() {
      _isComposing = false; // Reset _isComposing when the message is submitted
      _chatHistory.insert(0, newMessage);
    });
    _textController.clear();

    // Step 2: Store the user's message to the server.
    Logger().i('Storing message to server...');
    await Api.storeMessage(tempUserId, userDetails.currentChatId, newMessage);
    Logger().i('Message stored.');

    // Step 3: Send the message to the server. to oppenAI API
    Logger().i('Sending message to server...');
    Message botResponse = await Api().sendMessage(newMessage, 'zh-hk');
    Logger().i('Received response from server.');

    // Step 4: Store the bot's message to the server.
    Logger().i('Storing bot message to server...');
    await Api.storeMessage(tempUserId, userDetails.currentChatId, botResponse);
    Logger().i('Bot message stored.');

    _isProcessing = false;
    // Step 5: Add the new messages to the chat history.
    setState(() {
      Logger().i('Adding messages to chat history...');
      _chatHistory.insert(0, botResponse);
      Logger().i('Messages added to chat history.');
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            const IconButton(
              icon: FaIcon(FontAwesomeIcons.plus),
              onPressed: null,
            ),
            Flexible(
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Send a message',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ),
            _isComposing
                ? Container()
                : const IconButton(
                    icon: FaIcon(FontAwesomeIcons.camera),
                    onPressed: null,
                  ),
            _isComposing
                ? Container()
                : const IconButton(
                    icon: FaIcon(FontAwesomeIcons.microphone),
                    onPressed: null,
                  ),
            _isComposing
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.paperPlane),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(Message message) {
    bool isMine = message.sender != 'bot';
    final currentTime = DateTime.now();
    final timezoneOffset = currentTime.timeZoneOffset;
    final localTime = message.createdAt.add(timezoneOffset);
    final messageTime = timeago.format(localTime, locale: 'en_short');

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isMine ? null : Colors.grey[800], // Use white for all messages
          borderRadius: BorderRadius.circular(15), // Rounded rectangle
        ),
        padding: EdgeInsets.only(bottom: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
            children: <Widget>[
              CircleAvatar(
                // Always show avatar
                backgroundImage: NetworkImage(isMine ? userAvatarUrl : botAvatarUrl),
                radius: 20,
              ),
              SizedBox(width: 10), // spacing between avatar and message
              Expanded(
                // Use Expanded instead of Flexible
                child: GestureDetector(
                  onLongPressStart: (LongPressStartDetails details) async {
                    HapticFeedback.heavyImpact();
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset localPosition = box.globalToLocal(details.globalPosition);

                    final double bubbleHeight = box.size.height;
                    final double bubbleWidth = box.size.width;

                    await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          localPosition.dx, localPosition.dy + bubbleHeight, localPosition.dx + bubbleWidth, localPosition.dy + bubbleHeight),
                      items: <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'copy',
                          child: Text('Copy'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                        // TODO: Add more menu items here if needed
                      ],
                      elevation: 8.0,
                    ).then((value) {
                      // TODO: Handle menu selection here
                      switch (value) {
                        case 'copy':
                          // TODO: Implement copying to clipboard
                          break;
                        case 'delete':
                          // TODO: Implement deletion
                          break;
                      }
                    });
                  },
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: Colors.white, // Use white for all messages
                    //   borderRadius: BorderRadius.circular(15), // Rounded rectangle
                    // ),
                    padding: EdgeInsets.all(10.0), // Provide some padding within the bubble
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(color: Colors.black, fontSize: 16), // Use black text
                        ),
                        SizedBox(height: 5), // spacing between message and timestamp
                        Text(
                          messageTime,
                          style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 10), // Use black text for timestamp
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // If popupButton is null, it means it's not open, so unfocus text field.
        if (popupButton == null) {
          _focusNode.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[600],
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Chatbot'),
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Logger().d('ARROW CICKED POP');
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _chatHistory.length + (_isProcessing ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (_isProcessing && index == 0) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    }
                    var messageIndex = _isProcessing ? index - 1 : index;
                    Message message = _chatHistory[messageIndex];
                    bool isBot = message.sender == 'bot' ? true : false;
                    return _buildMessageCard(message);
                  },
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
      ),
    );
  }
}
