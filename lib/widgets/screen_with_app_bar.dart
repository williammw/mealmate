// import 'package:flutter/material.dart';
// import 'package:mealmate/widgets/custom_sliver_app_bar.dart';

// class ScreenWithAppBar extends StatelessWidget {
//   final String title;
//   final Widget body;

//   const ScreenWithAppBar({required this.title, required this.body, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: <Widget>[
//         CustomSliverAppBar(title: title),
//         SliverPadding(
//           padding: EdgeInsets.all(0),
//           sliver: SliverList(
//             delegate: SliverChildListDelegate(
//               [body],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
