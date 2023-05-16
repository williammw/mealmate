// import 'package:flutter/material.dart';

// class ChatMessage extends StatelessWidget {
//   final String text;
//   final AnimationController animationController;

//   const ChatMessage({
//     required this.text,
//     required this.animationController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizeTransition(
//       sizeFactor: CurvedAnimation(
//         parent: animationController,
//         curve: Curves.easeInOut,
//       ),
//       axisAlignment: 0.0,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(right: 16.0),
//               child: const CircleAvatar(child: Text('A')),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('User', style: Theme.of(context).textTheme.subtitle1),
//                   Container(
//                     margin: const EdgeInsets.only(top: 5.0),
//                     child: Text(text),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
