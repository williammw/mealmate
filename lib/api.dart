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
    final response = await http.get(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/get_user_chats?user_id=$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['chats'];
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<Map<String, dynamic>> createNewChat(String userId) async {
    final response = await http.post(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/create_new_chat'),
      body: jsonEncode({'user_id': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create a new chat');
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
