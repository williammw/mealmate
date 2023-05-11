import 'package:flutter/material.dart';

import '../api.dart';
import '../auth.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<dynamic>> _chats;

  @override
  void initState() {
    super.initState();
    _chats = _getChats();
  }

  Future<List<dynamic>> _getChats() async {
    String? userId = await Auth().getUserId();
    if (userId != null) {
      return await Api.getChats(userId);
    } else {
      // Handle the case where the userId is null (e.g., user is not logged in)
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Chats'),
      //   backgroundColor: Color(0xFF5682A3), // Telegram color
      // ),
      body: FutureBuilder<List<dynamic>>(
        future: _chats,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((snapshot.data![index]['title'] as String? ?? 'U')[0]), // replace it with your chat avatar
                  ),
                  title: Text(snapshot.data![index]['title'] ?? 'Untitled Chat'), // replace it with your chat title
                  subtitle: Text('Last message...'), // replace it with your last message
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('11:11'), // replace it with your message time
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue,
                        child: Text(
                          '1',
                          style: TextStyle(color: Colors.white),
                        ), // replace it with your unread messages count
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chat',
                      arguments: snapshot.data![index]['chat_id'],
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('No chats found'));
        },
      ),
    );
  }
}
