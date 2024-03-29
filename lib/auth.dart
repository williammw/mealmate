import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'models/new_chat_related_models.dart';

class Auth {
  final String? apiUrl = dotenv.env['API_URL'];
  // final String apiUrl = 'http://127.0.0.1:5000/';

  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/appauth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String userId = responseBody['user'];
      print('responseBody $responseBody');
      print('/login $userId');
      await storage.write(key: 'authToken', value: userId);
      return true;
    }

    return false;
  }

  Future<String?> getUserId() async {
    return await storage.read(key: 'authToken');
  }

  Future<bool> signup(String emailOrPhone, String password, String username, String fullName, DateTime dob, int peopleDining) async {
    Logger().i('/signup $emailOrPhone , $password, $username, $fullName, $dob, $peopleDining');
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/appauth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'email_or_phone': emailOrPhone,
            'full_name': fullName,
            'username': username,
            'password': password,
            'date_of_birth': dob.toIso8601String(),
            'people_dining': peopleDining.toString(),
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        String userId = responseBody['user_id'] ?? '';
        Logger().d('signup responseBody[user_id] $userId');
        await storage.write(key: 'authToken', value: userId);
        return true;
      } else {
        print('signup Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception in signup method: $e');
    }

    return false;
  }

  Future<void> logout() async {
    await storage.delete(key: 'authToken');
  }

  Future<List<Chat>> getChatsForUser(String userId) async {
    // Fetch the chats for the user from Firebase
    // This might involve a query to the 'chats' subcollection under the user document
    // For each chat document, create a new Chat object and add it to a list
    // Finally, return the list of chats
    return [];
  }
}
