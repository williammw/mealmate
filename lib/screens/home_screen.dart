import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmate/widgets/bottom_navigation.dart';
import 'package:mealmate/screens/search_restaurant_chatbot_screen.dart';
import 'package:mealmate/screens/user_profile_screen.dart';
import 'package:mealmate/screens/settings_screen.dart';
import 'package:mealmate/widgets/chat_drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api.dart';
import '../auth.dart';
import '../models/chat.dart';
import '../widgets/custom_sliver_app_bar.dart';
import 'chat_list_screen.dart';
import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _currentScreen = 0;

  final List<Widget> _children = [
    const FeedScreen(),
    const ChatListScreen(),
    const UserProfileScreen(),
    const SettingsScreen(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      _currentScreen = index; // Add this line
    });
  }

  @override
  void initState() {
    super.initState();
    _currentScreen = _currentIndex;
  }

  Future<void> _createNewChatAndNavigate() async {
    String? userId = await Auth().getUserId();
    if (userId != null) {
      try {
        final result = await Api.createNewChat(userId);
        String chatId = result['chat']['id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchRestaurantChatbotScreen(
              chatId: chatId,
              onBack: () {
                setState(() {
                  _currentIndex = 1; // Show the ChatListScreen when the back button is pressed
                });
              },
            ),
          ),
        );
      } catch (e) {
        print('Error creating a new chat: $e');
      }
    } else {
      print('User is not logged in');
    }
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
              CustomSliverAppBar(
                currentIndex: _currentIndex,
                onAddPressed: _createNewChatAndNavigate,
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
