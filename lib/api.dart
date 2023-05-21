// Import required packages
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        Uri.parse('${dotenv.env['API_URL']}/verify_security_code'), // Replace with your API endpoint
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

  static Future<void> storeMessage(String userId, String chatId, Message message) async {
    print('UserId: $userId');
    print('ChatId: $chatId');
    print('Message: ${message.toJson()}');

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/store_message'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'chat_id': chatId,
        'message': message.toJson(), // Assuming your Message model has a method to convert it to JSON
      }),
    );

    if (response.statusCode != 200) {
      print('Server responded with status code: ${response.statusCode}');
      print('Server response body: ${response.body}');
      throw Exception('Failed to store message');
    }
  }

  Future<User> getUserDetails(String uid) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/get_user_details?uid=$uid'),
    );

    if (response.statusCode == 200) {
      print('getUserDetails Response data: ${response.body}');
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  static Future<Chat> getChat(String chatId, String userId) async {
    Logger().d('getChat $chatId   $userId');
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/get_chat?chat_id=$chatId&user_id=$userId'),
    );

    if (response.statusCode == 200) {
      return Chat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load chat');
    }
  }

  static Future<List<dynamic>> getChats(String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/get_user_chats?user_id=$userId'),
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
      Uri.parse('${dotenv.env['API_URL']}/create_new_chat'),
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
    var url = Uri.parse('${dotenv.env['API_URL']}/get_default_message');
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
      Uri.parse('${dotenv.env['API_URL']}/save_user_data'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email, 'security_code': securityCode},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user data');
    }
  }

  Future<List<Message>> getMessagesForChat(String chatId, int limit) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/get_messages_for_chat'),
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
  Future<Message> sendMessage(Message message, String languageCode) async {
    print('||sendMessage||');
    print(message.content);
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/send_message'),
      body: jsonEncode({'message': message.content, 'language_code': languageCode}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody['response']);
      // Create a new Message object for the bot's response.
      Message botMessage = Message(
        messageId: 'bot', // A placeholder ID.
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        type: 'text',
        content: responseBody['response'], // Get the response from the server.
        sender: 'bot', // A placeholder sender.
        processed: true,
        chatId: message.chatId,
      );

      return botMessage;
    } else {
      throw Exception('Failed to send message');
    }
  }

  static Future<void> updateUserDetails(String userId, User user) async {
    print('Starting to update user details...');

    final response = await http.put(
      Uri.parse('${dotenv.env['API_URL']}/update_user_details'),
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
