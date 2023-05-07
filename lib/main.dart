import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:mealmate/screens/home_screen.dart';
import 'package:mealmate/screens/search_restaurant_chatbot_screen.dart';
import 'package:mealmate/screens/restaurant_details_screen.dart';
import 'package:mealmate/screens/signup_birthdate_screen.dart';
import 'package:mealmate/screens/signup_screen.dart';
import 'package:mealmate/screens/signup_securitycode_screen.dart';
import 'package:mealmate/screens/user_profile_screen.dart';
import 'package:mealmate/screens/settings_screen.dart';
import 'package:mealmate/screens/conversations_screen.dart';
import 'package:mealmate/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/signup_birthdate': (context) => SignupBirthdateScreen(),
        '/signup_securitycode': (context) => SignupSecurityCodeScreen(),
        '/home': (context) => const HomeScreen(),
        '/search_restaurant': (context) => const SearchRestaurantChatbotScreen(),
        '/restaurant_details': (context) => const RestaurantDetailsScreen(),
        '/user_profile': (context) => const UserProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    const storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'authToken'); // Changed the key here
    Logger().d("_checkLoginStatus authToken ${storage}");
    if (authToken == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
