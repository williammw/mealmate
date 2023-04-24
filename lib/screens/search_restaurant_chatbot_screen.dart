import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:url_launcher/link.dart';

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

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) {
      return;
    }
    setState(() {
      _messages.add(text);
      _isUserMessage.add(true);
    });
    _textController.clear();
    _simulateBotResponse(text);
  }

  void _simulateBotResponse(String userMessage) {
    // Simulate a delay and add a dummy response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add('Dummy response to: $userMessage');
        _isUserMessage.add(false);
      });
    });
  }

  Widget _buildMessageList() {
    return ListView.builder(
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
                      style: TextStyle(color: textColor),
                    ),
                  ),
          ),
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
              style: const TextStyle(
                height: 1.5,
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
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Search Restaurants'),
      // ),
      body: Column(
        children: [
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
    );
  }
}
