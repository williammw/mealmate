import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;

  const CustomSliverAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SliverAppBar(
      leading: GestureDetector(
        onTap: () {
          // Implement dropdown menu functionality here
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(0, 100, 0, 0),
            items: [
              PopupMenuItem(
                child: const Text(
                  'Following',
                  style: TextStyle(color: Colors.black),
                ),
                value: 'following',
              ),
              PopupMenuItem(
                child: const Text(
                  'Favorites',
                  style: TextStyle(color: Colors.black),
                ),
                value: 'favorites',
              ),
            ],
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white.withOpacity(0.9),
          ).then((value) {
            if (value == 'following') {
              // Implement following functionality here
            } else if (value == 'favorites') {
              // Implement favorites functionality here
            }
          });
        },
        child: const Icon(
          EvaIcons.arrowDownOutline,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(EvaIcons.heartOutline),
          onPressed: () {
            // Implement favorite functionality here
          },
        ),
        IconButton(
          icon: const Icon(EvaIcons.menu2Outline),
          onPressed: () {},
        ),
      ],
      backgroundColor: Colors.blue,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      forceElevated: true,
      // pinned: false,
      floating: true,
    );
  }
}
