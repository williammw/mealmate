import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmate/widgets/bottom_navigation.dart';
import 'package:mealmate/screens/search_restaurant_chatbot_screen.dart';
import 'package:mealmate/screens/user_profile_screen.dart';
import 'package:mealmate/screens/settings_screen.dart';
import 'package:mealmate/widgets/custom_sliver_app_bar.dart';

import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
        body: _currentIndex == 0 || _currentIndex == 1
            ? NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    const CustomSliverAppBar(title: 'MealMate'),
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
      ),
    );
  }
}
