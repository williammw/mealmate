import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:mealmate/providers/userdetails_notifer.dart';
import 'providers/drag_state_notifer.dart';
import 'providers/language_notifer.dart';
import 'providers/tab_index_notifier.dart';
import 'screens/home_screen.dart';
import 'screens/search_restaurant_chatbot_screen.dart';
import 'screens/restaurant_details_screen.dart';
import 'screens/signup_birthdate_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signup_securitycode_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env.prod');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TabIndexNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => DragState(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserDetailsProvider(),
        ),
      ],
      child: const MealMateApp(),
    ),
  );
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
        '/search_restaurant': (context) {
          final chatId = ModalRoute.of(context)?.settings.arguments as String;
          return SearchRestaurantChatbotScreen(
            chatId: chatId,
            onBack: () {
              final tabIndexNotifier = Provider.of<TabIndexNotifier>(context, listen: false);
              tabIndexNotifier.setTabIndex(1); // Set the index of the Chat List tab
            },
          );
        },
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
    Logger().d('_checkLoginStatus authToken $storage');
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
