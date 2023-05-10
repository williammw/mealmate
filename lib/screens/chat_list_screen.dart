import 'package:flutter/material.dart';

import '../api.dart';
import '../auth.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<dynamic>> _chats;

  @override
  void initState() {
    super.initState();
    _chats = _getChats();
  }

  Future<List<dynamic>> _getChats() async {
    String userId = await Auth().getUserId();
    return await Api.getChats(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
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
                  title: Text(snapshot.data![index]['title']),
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
