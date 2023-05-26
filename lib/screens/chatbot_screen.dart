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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Chatbot'),
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowLeft), // FaIcon back arrow
            onPressed: () {
              Logger().d("ARROW CICKED POP");
              Navigator.pop(context); // On pressed, this will pop the Chatbot screen
            },
          ),
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

                      // Subtracts 1 from the index when _isProcessing is true
                      var messageIndex = _isProcessing ? index - 1 : index;
                      var message = _chatHistory[messageIndex];
                      bool isBot = message.sender == 'bot' ? true : false;
                      final messageTime = timeago.format(message.createdAt, locale: 'en_short');
                      GlobalKey _listTileKey = GlobalKey();

                      return Container(
                        color: isBot ? Colors.grey[400] : Colors.grey[300],
                        child: ListTile(
                          key: _listTileKey,
                          contentPadding: const EdgeInsets.all(10),
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
                          onLongPress: () {
                            final RenderBox? overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox?;
                            final RenderBox? listTile = _listTileKey.currentContext?.findRenderObject() as RenderBox?;
                            if (overlay != null && listTile != null) {
                              showMenu(
                                context: context,
                                position: RelativeRect.fromRect(
                                  listTile.localToGlobal(listTile.size.topCenter(Offset.zero), ancestor: overlay) & Size(40, 40),
                                  Offset.zero & overlay.size,
                                ),
                                items: <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: message.content,
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(Icons.content_copy),
                                        const SizedBox(width: 10),
                                        Text('Copy text'),
                                      ],
                                    ),
                                  ),
                                ],
                              ).then<void>((String? value) {
                                if (value != null) {
                                  Clipboard.setData(ClipboardData(text: value));
                                }
                              });
                            }
                          },
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
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.plus),
              onPressed: null, // You need to handle what happens when the plus button is pressed
            ),
            Flexible(
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: TextField(
                    controller: _textController,
                    minLines: 1, // Set minLines property
                    maxLines: 4, // Set maxLines property
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration(
                      hintText: "Send a message",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), //adjust the padding as needed
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true, // add this line
                      fillColor: Colors.grey[200], // add this line for the filled color
                    ),
                  ),
                ),
              ),
            ),
            _isComposing
                ? Container()
                : const IconButton(
                    icon: FaIcon(FontAwesomeIcons.camera),
                    onPressed: null, // You need to handle what happens when the camera button is pressed
                  ),
            _isComposing
                ? Container()
                : const IconButton(
                    icon: FaIcon(FontAwesomeIcons.microphone),
                    onPressed: null, // You need to handle what happens when the microphone button is pressed
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
}
