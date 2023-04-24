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
  List<String> get urls => const [
        'github.com/flyerhq',
        'https://u24.gov.ua',
        'https://twitter.com/SpaceX/status/1564975288655630338',
      ];

  void _handleSubmitted(String text) {
    setState(() {
      _messages.add(text);
      _isUserMessage.add(true);
    });
    _textController.clear();
    _simulateBotResponse(text);
  }

  void _simulateBotResponse(String userMessage) {
    // Simulate a delay and add a dummy response
    Future.delayed(Duration(seconds: 1), () {
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

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: isUrl
              ? Link(
                  uri: Uri.parse(message),
                  target: LinkTarget.blank,
                  builder: (BuildContext context, FollowLink? followLink) {
                    return GestureDetector(
                      onTap: followLink,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
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
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isUserMessage ? Colors.blueAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
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
              decoration: const InputDecoration.collapsed(hintText: 'Ask a question'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
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
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
