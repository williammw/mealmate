import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmate/widgets/bottom_navigation.dart';
import 'package:mealmate/screens/search_restaurant_chatbot_screen.dart';
import 'package:mealmate/screens/user_profile_screen.dart';
import 'package:mealmate/screens/settings_screen.dart';
import 'package:mealmate/widgets/custom_sliver_app_bar.dart';
import 'package:mealmate/widgets/chat_drawer.dart';

import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<Widget> _children = [
    const FeedScreen(),
    const SearchRestaurantChatbotScreen(),
    const UserProfileScreen(),
    const SettingsScreen(),
  ];
  void _handleNewChat() {
    setState(() {
      _currentIndex = 1;
    });
  }

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
        body: _currentIndex == 0 || _currentIndex == 1
            ? NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    CustomSliverAppBar(
                      title: 'MealMate',
                      showChatIcon: _currentIndex == 1,
                    ),
                  ];
                },
                body: _children[_currentIndex],
              )
            : CustomScrollView(
                slivers: <Widget>[
                  const CustomSliverAppBar(title: 'MealMate'),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _children[_currentIndex],
                  ),
                ],
              ),
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
        ),
        endDrawer: _currentIndex == 1
            ? ChatDrawer(
                onNewChat: _handleNewChat,
              )
            : null,
      ),
    );
  }
}
