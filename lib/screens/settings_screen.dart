import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../api.dart';
import '../auth.dart'; // Make sure this import points to the correct location of the 'auth.dart' file.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/new_chat_related_models.dart';
import '../providers/userdetails_notifer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> languages = ['en', 'zh-cn', 'zh-tw', 'zh-hk', 'ja'];

  void _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? idToken = await storage.read(key: 'authToken');

    if (idToken != null) {
      final auth = Auth();
      await auth.logout(); // Removed the check for logoutSuccessful

      // Remove the authToken from secure storage
      await storage.delete(key: 'authToken');

      // Clear the user details from UserDetailsProvider
      UserDetailsProvider userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
      userDetailsProvider.clearUserDetails();

      // Navigate to the login screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      // Show an error message
      print('Logout failed');
    }
  }

  Future<void> _updatePreferredLanguage(String language) async {
    // final api = Api();
    UserDetailsProvider userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    User? userDetails = userDetailsProvider.userDetails;

    if (userDetails != null) {
      // Update the User model with the new preferred language
      userDetails.preferredLanguage = language;
      // Update the user details in the backend

      await Api.updateUserDetails(userDetails.userId, userDetails);
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
    UserDetailsProvider userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    User? userDetails = userDetailsProvider.userDetails;

    List<String> languages = ['en', 'zh-cn', 'zh-tw', 'zh-hk', 'ja']; // Define the languages

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
            if (user != null) {
              // Return widgets
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user['avatar_url'] != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user['avatar_url']),
                      ),
                    SizedBox(height: 10),
                    Text('Full Name: ${user['full_name']}'),
                    Text('Username: ${user['username']}'),
                    Text('Email: ${user['email_or_phone']}'),
                    DropdownButton<String>(
                      value: user['preferred_language'],
                      onChanged: (String? newValue) {
                        if (userDetails != null) {
                          setState(() {
                            userDetails.preferredLanguage = newValue!;
                            _updatePreferredLanguage(newValue);
                          });
                        }
                      },
                      items: languages.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            } else {
              // Return a widget when the user is null
              return Text('User data not found');
            }
          }
        },
      ),
    );
  }
}
