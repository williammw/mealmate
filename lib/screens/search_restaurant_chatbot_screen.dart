import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:logger/logger.dart';
import 'package:url_launcher/link.dart';
import 'package:dart_openai/openai.dart';
import 'dart:async';
import 'package:mealmate/env/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchRestaurantChatbotScreen extends StatefulWidget {
  const SearchRestaurantChatbotScreen({Key? key}) : super(key: key);

  @override
  State<SearchRestaurantChatbotScreen> createState() => _SearchRestaurantChatbotScreenState();
}

class _SearchRestaurantChatbotScreenState extends State<SearchRestaurantChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  Map<String, PreviewData> datas = {};
  final List<String> _messages = [];
  final List<bool> _isUserMessage = [];
  ScrollController _scrollController = ScrollController();
  static const double appBarHeight = 56.0;
  String _response = '';
  String _language = 'en';
  String _currentLanguage = 'en';
  bool _isLoading = false; // Add this line

  @override
  void initState() {
    super.initState();
    OpenAI.apiKey = Env.apiKey;
  }

  Future<void> _sendMessage(String message, String languageCode) async {
    setState(() {
      _isLoading = true; // Start showing the loading indicator
    });

    final response = await http.post(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/send_message'),
      body: json.encode({
        'message': message,
        'language_code': languageCode,
      }),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': 'mj-JNOG*&FT&3fijoognu408978J*I',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final aiResponse = jsonResponse['response'];

      setState(() {
        _response = aiResponse;
        Logger().d(_response);
        Logger().e(jsonResponse);
        _messages.add(_response);
        _isUserMessage.add(false);
        _isLoading = false; // Stop showing the loading indicator
      });
    } else {
      setState(() {
        _isLoading = false; // Stop showing the loading indicator
      });
      throw Exception('Failed to load AI response');
    }
  }

  DropdownButton<String> _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: _currentLanguage,
      icon: const Icon(Icons.arrow_drop_down),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _changeLanguage(newValue);
        }
      },
      items: <String>['en', 'zh-cn', 'zh-tw', 'zh-hk', 'ja'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) {
      return;
    }
    setState(() {
      _messages.add(text);
      _isUserMessage.add(true);
    });
    _textController.clear();
    _sendMessage(text, _language); // Replace _currentLanguage with _language
    _scrollToBottom();
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
      _language = languageCode; // Add this line to update the _language variable
    });
  }
  // void _simulateBotResponse(String userMessage) {
  //   // Simulate a delay and add a dummy response
  //   Future.delayed(const Duration(seconds: 1), () {
  //     setState(() {
  //       _messages.add('Dummy response to: $userMessage');
  //       _isUserMessage.add(false);
  //     });
  //   });
  // }

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
            final bool isUserMessage = _isUserMessage[index];
            final String message = _messages[index];
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
                          );
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
            child: TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(
                height: 1.5,
                fontSize: 14.0,
              ), // Adjust the height of the TextField by changing the value
              decoration: InputDecoration(
                hintText: 'Ask a question',
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15), // Adjust the padding inside the TextField
                border: InputBorder.none, // Remove the border
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Change the value to adjust the roundness of the edges
                  borderSide: BorderSide.none, // Remove the border
                ),
                fillColor: Colors.grey[200], // Set a light background color
                filled: true,
                isDense: true,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _isLoading
                ? CircularProgressIndicator() // Show the loading indicator when waiting for a response
                : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => () {
                      _handleSubmitted(_textController.text);
                    }(),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => {FocusScope.of(context).unfocus()},
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
    );
  }
}
