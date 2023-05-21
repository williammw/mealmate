import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:dart_openai/openai.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../env/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api.dart';
import '../auth.dart';
import '../models/chat_message.dart';
import '../providers/language_notifer.dart';
import '../widgets/custom_sliver_app_bar.dart';

class SearchRestaurantChatbotScreen extends StatefulWidget {
  final String chatId;
  final VoidCallback onBack;
  const SearchRestaurantChatbotScreen({Key? key, required this.chatId, required this.onBack}) : super(key: key);

  @override
  State<SearchRestaurantChatbotScreen> createState() => _SearchRestaurantChatbotScreenState();
}

class _SearchRestaurantChatbotScreenState extends State<SearchRestaurantChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  Map<String, PreviewData> datas = {};
  // Map<String, String> _headers = {'Content-Type': 'application/json'};
  final List<ChatMessage> _messages = [];
  final String currentChatId = const Uuid().v4(); // Generate a unique ID for the current chat
  final List<bool> _isUserMessage = [];
  final ScrollController _scrollController = ScrollController();
  String _response = '';
  final String _language = 'en';
  String _currentLanguage = 'en';

  bool _isLoading = false; // Add this line

  @override
  void initState() {
    super.initState();
    OpenAI.apiKey = Env.apiKey;
    // Add default message
    String languageCode = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;

    // _messages.add('Hello! How can I assist you today?');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getDefaultMessage(languageCode);
    });

    _isUserMessage.add(false);
    // _initializeHeaders();
  }

  Future<void> _getDefaultMessage(String langeCode) async {
    try {
      // String languageCode = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
      // print('_getDefaultMessage: $languageCode');
      final String defaultMessage = await Api.getDefaultMessage(langeCode);
      String? userId = await Auth().getUserId();
      if (userId != null) {
        setState(() {
          _messages.add(
            ChatMessage(
              id: const Uuid().v4(),
              chatId: userId,
              senderId: '1',
              content: defaultMessage,
              type: MessageType.text,
              status: MessageStatus.sent,
              attachments: [],
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      // Handle the exception as needed
      print('Failed to load default message: $e');
    }
  }

  Future<void> _sendMessage(String message, String languageCode) async {
    setState(() {
      _isLoading = true; // Start showing the loading indicator
    });

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/send_message'),
      body: json.encode({
        'message': message,
        'language_code': languageCode,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    var uuid = const Uuid().v4();
    var uuid2 = const Uuid().v4();
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final aiResponse = jsonResponse['response'];

      String? userId = await Auth().getUserId();

      _storeAiResponse(aiResponse, uuid).catchError((error) {
        // Handle errors when storing the AI response
        Logger().e('Failed to store AI response', error);
      });

      if (userId != null) {
        setState(() {
          _response = aiResponse;
          Logger().d(_response);
          Logger().e(jsonResponse);

          _messages.add(
            ChatMessage(
              id: uuid2,
              chatId: userId,
              senderId: '1',
              content: _response,
              type: MessageType.text,
              status: MessageStatus.sent,
              attachments: [],
              timestamp: DateTime.now(),
            ),
          );

          _isUserMessage.add(false);
          _isLoading = false; // Stop showing the loading indicator
        });

        // Store the message after successfully receiving the AI response
        _storeMessage(message, uuid2).catchError((error) {
          // Handle errors when storing the message
          Logger().e('Failed to store AI response', error);
        });
      }
    } else {
      setState(() {
        _isLoading = false; // Stop showing the loading indicator
      });
      throw Exception('Failed to load AI response');
    }
  }

  Future<void> _storeAiResponse(String aiResponse, String uuid) async {
    print('Flutter _storeAiResponse called');
    String? userId = await Auth().getUserId();
    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse('${dotenv.env['API_URL']}/store_message'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'id': uuid, // replace with actual message id
            'chatId': userId, // replace with actual chat id
            'senderId': '1',
            'content': aiResponse,
            'type': 'text', // replace with actual type
            'status': 'sent', // replace with actual status
            'timestamp': DateTime.now().toIso8601String(), // replace with actual timestamp
          }),
        );

        if (response.statusCode != 200) {
          // Handle error
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          throw Exception('Failed to store AI response');
        }
      } catch (e) {
        Logger().e('Failed to store AI response', e);
      }
    } else {
      // Handle case where user is not logged in
    }
  }

  Future<void> _storeMessage(String message, String uuid) async {
    print('Flutter _storeMessage called');
    String? userId = await Auth().getUserId();
    if (userId != null) {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/store_message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': uuid, // replace with actual message id
          'chatId': userId, // replace with actual chat id
          'senderId': '0',
          'content': message,
          'type': 'text', // replace with actual type
          'status': 'sent', // replace with actual status
          'timestamp': DateTime.now().toIso8601String(), // replace with actual timestamp
        }),
      );

      if (response.statusCode != 200) {
        // Handle error
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to store message');
      }
    } else {
      // Handle case where user is not logged in
    }
  }

  Future<void> _changeLanguage(String newLanguage) async {
    print('_changeLanguage newLanguage $newLanguage');
    Api.changeLanguage(newLanguage);
    var defaultMessage = await _getDefaultMessage(newLanguage);

    setState(() {
      _currentLanguage = newLanguage;
      // Assuming _getDefaultMessage() returns a value you want to store in your state
      defaultMessage = defaultMessage;
    });
  }

  Material _buildLanguageDropdown() {
    return Material(
      child: DropdownButton<String>(
        value: _currentLanguage,
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: (String? newValue) {
          if (newValue != null) {
            _changeLanguage(newValue);
          }
        },
        items: <Map<String, String>>[
          {'code': 'en', 'name': 'English'},
          {'code': 'zh-cn', 'name': '简体中文'},
          {'code': 'zh-tw', 'name': '繁體中文'},
          {'code': 'zh-hk', 'name': '繁體中文 (香港)'},
          {'code': 'ja', 'name': '日本語'},
        ].map<DropdownMenuItem<String>>((Map<String, String> value) {
          return DropdownMenuItem<String>(
            value: value['code']!,
            child: Text(value['name']!),
          );
        }).toList(),
      ),
    );
  }

  void _handleSubmitted(String text) async {
    // describe this function
    print('Flutter _handleSubmitted called $text');
    if (text.trim().isEmpty) {
      return;
    }
    String? userId = await Auth().getUserId();
    if (userId != null) {
      setState(() {
        // _messages.add(text);
        _messages.add(
          ChatMessage(
            id: const Uuid().v4(),
            chatId: userId,
            senderId: '0',
            content: text,
            type: MessageType.text,
            status: MessageStatus.sent,
            attachments: [],
            timestamp: DateTime.now(),
          ),
        );

        _isUserMessage.add(true);
      });
    }

    _textController.clear();
    _sendMessage(text, _language); // Replace _currentLanguage with _language
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageList() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int index) {
            final ChatMessage messageObj = _messages[index];
            final bool isUserMessage = messageObj.senderId == '0' ? true : false;
            final String message = messageObj.content;
            final bool isUrl = Uri.tryParse(message)?.hasAbsolutePath ?? false;
            final bool isLatestMessage = index == _messages.length - 1;
            final bool isMessageRead = isLatestMessage && !isUserMessage;

            Color? messageColor = isUserMessage ? Colors.blueAccent : Colors.grey[300];
            Color textColor = isUserMessage ? Colors.white : Colors.black;

            BorderRadius borderRadius = BorderRadius.circular(12.0);
            BorderRadius messageSentBorderRadius = const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            );
            BorderRadius messageReadBorderRadius = const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            );

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
              child: IntrinsicWidth(
                child: isUrl
                    ? Link(
                        uri: Uri.parse(message),
                        target: LinkTarget.blank,
                        builder: (BuildContext context, FollowLink? followLink) {
                          return GestureDetector(
                            onTap: followLink,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: messageColor,
                                borderRadius: isMessageRead ? messageReadBorderRadius : messageSentBorderRadius,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth * 0.9,
                                ),
                                child: LinkPreview(
                                  enableAnimation: true,
                                  onPreviewDataFetched: (data) {
                                    setState(() {
                                      datas = {
                                        ...datas,
                                        message: data,
                                      };
                                    });
                                  },
                                  previewData: datas[message],
                                  text: message,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                ),
                              ),
                            ),
                          ); // Remove extra return
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: messageColor,
                          borderRadius: isMessageRead ? messageReadBorderRadius : messageSentBorderRadius,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(color: textColor, fontSize: 16.0),
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: Material(
              // Wrap TextField with Material
              type: MaterialType.transparency,
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask a question',
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  isDense: true,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _isLoading
                ? const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  )
                : Material(
                    // Wrap IconButton with Material
                    type: MaterialType.transparency,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => () {
                        _handleSubmitted(_textController.text);
                      }(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CustomSliverAppBar(
                currentIndex: 1, // Or any other value based on your logic
                onAddPressed: () {
                  setState(() {
                    // _messages.add('This is the default message!');
                    _isUserMessage.add(false); // false indicates this is a bot message
                  });
                  _scrollToBottom(); // Scroll to the bottom to show the new message
                },
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
              ),
            ];
          },
          body: GestureDetector(
            onTap: () => {FocusScope.of(context).unfocus()},
            child: Container(
              color: Colors.white, // Set the background color to white
              child: Column(
                children: [
                  _buildLanguageDropdown(),
                  Flexible(
                    child: _buildMessageList(),
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
        ),
      ),
    );
  }
}
