// import 'package:flutter/material.dart';
// import 'package:your_app_name/models/conversation_model.dart';
// import 'package:your_app_name/screens/search_restaurant_chatbot_screen.dart';

// class ConversationsScreen extends StatelessWidget {
//   final List<ConversationModel> conversations = [
//     ConversationModel(id: '1', title: 'Restaurant search', latestMessage: 'What are some good restaurants nearby?'),
//     ConversationModel(id: '2', title: 'Weather chat', latestMessage: 'What's the weather like today?'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Conversations'),
//       ),
//       body: ListView.builder(
//         itemCount: conversations.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             title: Text(conversations[index].title),
//             subtitle: Text(conversations[index].latestMessage),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SearchRestaurantChatbotScreen(conversationId: conversations[index].id),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => SearchRestaurantChatbotScreen(conversationId: '3'), // Pass a new unique conversation id
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
