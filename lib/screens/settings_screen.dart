import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../api.dart';
import '../auth.dart'; // Make sure this import points to the correct location of the 'auth.dart' file.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/new_chat_related_models.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? idToken = await storage.read(key: 'authToken');

    if (idToken != null) {
      final auth = Auth();
      await auth.logout(); // Removed the check for logoutSuccessful

      // Remove the authToken from secure storage
      await storage.delete(key: 'authToken');
      // Navigate to the login screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      // Show an error message
      print('Logout failed');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    String? tempUserId = await Auth().getUserId();
    // Logger().d('tempUserId   $tempUserId');

    // Fetch user details and current chat from your backend
    User userDetails = await Api().getUserDetails(tempUserId!);
    Logger().i(userDetails.toJson());
    return userDetails.toJson();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final user = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user!['avatar_url'] != null)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user['avatar_url']),
                    ),
                  SizedBox(height: 10),
                  Text('Full Name: ${user!['full_name']}'),
                  Text('Username: ${user['username']}'),
                  Text('email: ${user['email_or_phone']}'),
                  // And so on for the rest of the user attributes...
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
