// Import required packages
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // Other methods and variables...

  // Modify the verifySecurityCode method to return a boolean value
  static Future<bool> verifySecurityCode(String email, String securityCode) async {
    print('Email: $email');
    print('Security Code: $securityCode');
    try {
      final response = await http.post(
        Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/verify_security_code'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'security_code': securityCode},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['message'] == "Security code verified successfully") {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Failed to verify security code');
      }
    } catch (e) {
      print('Exception in verifySecurityCode: $e');
      throw e;
    }
  }

  static Future<List<dynamic>> getChats(String userId) async {
    String apiUrl = 'https://starfish-app-rk6pn.ondigitalocean.app';
    final response = await http.post(
      Uri.parse('$apiUrl/get_chats'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'user_id': userId},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get chats');
    }
  }

  // Save user data using the API
  static Future<void> saveUserData(String email, String securityCode) async {
    final response = await http.post(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/save_user_data'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email, 'security_code': securityCode},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user data');
    }
  }
}
