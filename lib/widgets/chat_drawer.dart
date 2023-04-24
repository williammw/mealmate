import 'package:flutter/material.dart';
import 'package:mealmate/screens/search_restaurant_chatbot_screen.dart';

class ChatDrawer extends StatelessWidget {
  final VoidCallback onNewChat;

  const ChatDrawer({Key? key, required this.onNewChat}) : super(key: key);

  void _handleNewChatButton(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    onNewChat();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 120.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Chats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          // Add the "New Chat" button here
          ListTile(
            leading: Icon(Icons.add),
            title: Text('New Chat'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              onNewChat();
            },
          ),
        ],
      ),
    );
  }
}
