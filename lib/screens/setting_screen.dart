import 'package:flutter/material.dart';
import '../auth.dart'; // Make sure this import points to the correct location of the 'auth.dart' file.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    final storage = FlutterSecureStorage();
    String? idToken = await storage.read(key: 'authToken');

    if (idToken != null) {
      final auth = Auth();
      bool logoutSuccessful = await auth.logout(idToken);

      if (logoutSuccessful) {
        // Remove the authToken from secure storage
        await storage.delete(key: 'authToken');
        // Navigate to the login screen
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        // Show an error message
        print('Logout failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
