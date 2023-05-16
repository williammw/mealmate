import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  final VoidCallback onNewChat;

  const ChatDrawer({Key? key, required this.onNewChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
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
            leading: const Icon(Icons.chat),
            title: const Text('Chat 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          // Add the "New Chat" button here
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Chat'),
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
