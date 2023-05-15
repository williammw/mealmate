import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigation({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedLabelStyle: const TextStyle(fontSize: 12.0),
      unselectedLabelStyle: const TextStyle(fontSize: 12.0),
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.house),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.mapLocationDot),
          label: 'Chat List',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.squarePlus),
          label: 'Chat List',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.newspaper),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.idBadge),
          label: 'Settings',
        ),
      ],
    );
  }
}
