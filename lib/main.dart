import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mealmate/screens/home_screen.dart';
import 'package:mealmate/screens/search_restaurant_chatbot_screen.dart';
import 'package:mealmate/screens/restaurant_details_screen.dart';
import 'package:mealmate/screens/user_profile_screen.dart';
import 'package:mealmate/screens/settings_screen.dart';
import 'package:mealmate/screens/conversations_screen.dart';

void main() {
  Platform.environment['CG_NUMERICS_SHOW_BACKTRACE'] = '1';

  runApp(const MealMateApp());
}

class MealMateApp extends StatelessWidget {
  const MealMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/search_restaurant': (context) => const SearchRestaurantChatbotScreen(),
        '/restaurant_details': (context) => const RestaurantDetailsScreen(),
        '/user_profile': (context) => const UserProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
