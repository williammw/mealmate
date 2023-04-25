import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:logger/logger.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final bool showChatIcon;

  const CustomSliverAppBar({super.key, required this.title, this.showChatIcon = false});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SliverAppBar(
      leading: GestureDetector(
        onTap: () {
          // Implement dropdown menu functionality here
          showMenu(
            context: context,
            position: const RelativeRect.fromLTRB(0, 100, 0, 0),
            items: [
              const PopupMenuItem(
                value: 'following',
                child: Text(
                  'Following',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const PopupMenuItem(
                value: 'favorites',
                child: Text(
                  'Favorites',
                  style: TextStyle(color: Colors.black),
                ),
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
        if (showChatIcon)
          IconButton(
            // Add this IconButton
            icon: const Icon(EvaIcons.messageCircleOutline),
            onPressed: () {
              Logger().d("click click");
              Scaffold.of(context).openEndDrawer();
            },
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
      // forceElevated: false,
      pinned: false,
      floating: true,
    );
  }
}



// my requirenment is, there would be a long List to scroll,when scroll down Appbar hide, when i scroll up, i dont want scroll to the top then show the Appbar, i want when i scrollup the appbar will show like instgram...do you understand my requirenmnet?