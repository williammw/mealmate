// import 'package:flutter/material.dart';
// import '../models/restaurant.dart';
// import '../screens/restaurant_details_screen.dart';

// class RestaurantCard extends StatelessWidget {
//   final Restaurant restaurant;

//   const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RestaurantDetailsScreen(restaurant: restaurant),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 4,
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               restaurant.imageUrl.isNotEmpty
//                   ? Image.network(
//                       restaurant.imageUrl,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     )
//                   : const SizedBox(width: 80, height: 80),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       restaurant.name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       restaurant.address,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${restaurant.distance} km',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const Icon(
//                           Icons.arrow_forward_ios,
//                           size: 14,
//                           color: Colors.grey,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
