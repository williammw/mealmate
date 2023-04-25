import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmate/widgets/bottom_navigation.dart';
import 'package:mealmate/screens/search_restaurant_chatbot_screen.dart';
import 'package:mealmate/screens/user_profile_screen.dart';
import 'package:mealmate/screens/settings_screen.dart';
import 'package:mealmate/widgets/chat_drawer.dart';

import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<Widget> _children = [
    const FeedScreen(),
    const SearchRestaurantChatbotScreen(),
    const UserProfileScreen(),
    const SettingsScreen(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
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
                pinned: _currentIndex == 1,
                actions: _currentIndex == 1
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
                        IconButton(
                          icon: const Icon(Icons.chat),
                          onPressed: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                        ),
                      ]
                    : [
                        IconButton(
                          icon: const Icon(EvaIcons.heartOutline),
                          onPressed: () {
                            // Implement favorite functionality here
                          },
                        ),
                        IconButton(
                          icon: const Icon(EvaIcons.menu2Outline),
                          onPressed: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                        ),
                      ],
              ),
            ];
          },
          body: _children[_currentIndex],
        ),
        endDrawer: ChatDrawer(
          onNewChat: () {},
        ), // Add the ChatDrawer widget here
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
        ),
      ),
    );
  }
}
