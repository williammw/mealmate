import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class CustomSliverAppBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onAddPressed;
  final VoidCallback onBackButtonPressed;

  const CustomSliverAppBar({
    Key? key,
    required this.currentIndex,
    required this.onAddPressed,
    required this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // ... The rest of the SliverAppBar properties
      leading: Navigator.canPop(context) ? const BackButton() : null,
      title: const Text('MealMate'),
      centerTitle: true,
      backgroundColor: Colors.black,
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
      pinned: currentIndex == 1,
      actions: currentIndex == 1
          ? [
              IconButton(
                icon: const Icon(EvaIcons.heartOutline),
                onPressed: () {
                  // Implement favorite functionality here
                },
              ),
              IconButton(
                icon: const Icon(EvaIcons.menu2Outline),
                onPressed: () {
                  // R_scaffoldKey.currentState?.openEndDrawer();
                },
              ),
              // ... Other action buttons
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAddPressed,
              ),
            ]
          : [
              // ... Other action buttons
              IconButton(
                icon: const Icon(EvaIcons.heartOutline),
                onPressed: () {
                  // Implement favorite functionality here
                },
              ),
            ],
    );
  }
}
