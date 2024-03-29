import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mealmate/screens/chatbot_screen.dart';
import '../providers/tab_index_notifier.dart';
import '../widgets/bottom_navigation.dart';
import 'search_restaurant_chatbot_screen.dart';
import 'user_profile_screen.dart';
import 'settings_screen.dart';
import '../widgets/chat_drawer.dart';
import '../api.dart';
import '../auth.dart';
import '../providers/drag_state_notifer.dart';
import '../widgets/custom_sliver_app_bar.dart';
import 'chat_list_screen.dart';
import 'feed_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAnimated = false;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _currentScreen = 0;

  final List<Widget> _children = [
    const FeedScreen(),
    const ChatListScreen(),
    const UserProfileScreen(),
    const ChatbotScreen(), // for backup only
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

  void _onBackButtonPressed() {
    Navigator.pop(context);
  }

  void _animate() {
    setState(() {
      _isAnimated = !_isAnimated;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    void _showBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent, // set background to transparent
        builder: (context) {
          // Get screen height using MediaQuery
          double screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

          return SizedBox(
            // Set container height to 90% of screen height
            height: screenHeight * 0.95,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor, // set a color for your BottomSheet
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), // give it a radius to make it rounded
                  topRight: Radius.circular(10), // same as above
                ),
              ),
              child: const ChatbotScreen(),
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CustomSliverAppBar(
                currentIndex: _currentIndex,
                onAddPressed: _createNewChatAndNavigate,
                onBackButtonPressed: _onBackButtonPressed,
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
        floatingActionButton: DragTarget(
          builder: (context, candidateData, rejectedData) {
            return Consumer<DragState>(
              builder: (context, dragState, child) {
                return FloatingActionButton(
                  onPressed: dragState.dragging ? _showBottomSheet : _showBottomSheet,
                  tooltip: 'Show Bottom Sheet',
                  child: const FaIcon(FontAwesomeIcons.paperclip),
                );
              },
            );
          },
          onWillAccept: (data) {
            return true; // When you want the data/check data
          },
          onAccept: (data) {
            _showBottomSheet(); // Same action as pressing the FloatingActionButton
          },
        ),
      ),
    );
  }
}
