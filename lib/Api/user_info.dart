import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UserInfo {
  final Logger logger = Logger();

  Future<Map<String, dynamic>?> getUserInfo(String rollNo) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/user_info?user_id=$rollNo'));
      logger.d('GET User Info Request: ${response.request}');
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = jsonDecode(response.body);
        logger.d('GET User Info Response: $userData');
        return userData;
      } else {
        logger.e('Failed to load user info');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching user info: $e');
      return null;
    }
  }
}
