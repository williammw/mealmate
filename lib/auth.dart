import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  final String apiUrl = 'https://starfish-app-rk6pn.ondigitalocean.app';
  // final String apiUrl = 'http://127.0.0.1:5000/';

  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String userId = responseBody['user'];
      print("/login ${userId}");
      if (userId != null) {
        await storage.write(key: 'authToken', value: userId);
        return true;
      }
    }

    return false;
  }

  Future<bool> signup(String emailOrPhone, String password, String displayName, String fullName, DateTime dob, int peopleDining) async {
    print("signUP!!");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'email_or_phone': emailOrPhone,
            'full_name': fullName,
            'username': displayName,
            'password': password,
            'date_of_birth': dob.toIso8601String(),
            'people_dining': peopleDining.toString(),
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        String userId = responseBody['user'];

        if (userId != null) {
          await storage.write(key: 'authToken', value: userId);
          return true;
        }
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
}
