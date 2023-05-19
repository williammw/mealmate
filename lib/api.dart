// Import required packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'models/new_chat_related_models.dart';

class Api {
  // Other methods and variables...

// default language is English

  static void changeLanguage(String newLanguage) {}

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
        if (result['message'] == 'Security code verified successfully') {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Failed to verify security code');
      }
    } catch (e) {
      print('Exception in verifySecurityCode: $e');
      rethrow;
    }
  }

  Future<User> getUserDetails(String uid) async {
    final response = await http.get(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/get_user_details?uid=$uid'),
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  static Future<Chat> getChat(String chatId, String userId) async {
    Logger().d('getChat $chatId   $userId');
    final response = await http.get(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/get_chat?chat_id=$chatId&user_id=$userId'),
    );

    if (response.statusCode == 200) {
      return Chat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load chat');
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
    print('createNewChat userId: $userId');
    final response = await http.post(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/create_new_chat'),
      body: jsonEncode({'user_id': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('createNewChar in Flutter response in 200 code');
      return jsonDecode(response.body);
    } else {
      // Log or handle the error message here
      print('Server responded with status code: ${response.statusCode}');
      print('Server response body: ${response.body}');
      throw Exception('Failed to create a new chat');
    }
  }

  static Future<String> getDefaultMessage(String languageCode) async {
    print('languageCode: $languageCode');
    var url = Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/get_default_message');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'language_code': languageCode,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      return jsonDecode(response.body)['default_message'];
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load default message');
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

  Future<List<Message>> getMessagesForChat(String chatId, int limit) async {
    final response = await http.post(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/get_messages_for_chat'),
      body: jsonEncode({
        'chat_id': chatId,
        'limit': limit,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Message.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages for chat');
    }
  }

  //
  Future<Message> sendMessage(Message message) async {
    final response = await http.post(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/send_message'),
      body: jsonEncode(message.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return Message(
        messageId: responseBody['message_id'],
        createdAt: DateTime.parse(responseBody['created_at']),
        updatedAt: DateTime.parse(responseBody['updated_at']),
        type: message.type, // assuming you have these fields in the response
        content: message.content,
        sender: message.sender,
        processed: responseBody['processed'],
        chatId: message.chatId,
      );
    } else {
      throw Exception('Failed to send message');
    }
  }

  static Future<void> updateUserDetails(String userId, User user) async {
    print('Starting to update user details...');

    final response = await http.put(
      Uri.parse('https://starfish-app-rk6pn.ondigitalocean.app/update_user_details'),
      body: jsonEncode({
        'user_id': userId,
        'user_details': user.toJson(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print('Update response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response body: ${response.body}');
      throw Exception('Failed to update user details');
    }

    print('User details updated successfully');
  }
}
