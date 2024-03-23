import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:llm_noticeboard/models/message_model.dart';
import 'package:logger/logger.dart';

class Message {
  final Logger logger = Logger();

  Future<List<MessageModel>?> getMessages() async {
    List<MessageModel> messages = [];
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/messages'));
      logger.d('GET Messages Request: ${response.request}');
      if (response.statusCode == 200) {
        List<dynamic> messageData = jsonDecode(response.body);
        messages = messageData.map((data) => MessageModel.fromJson(data)).toList();
        logger.d('GET Messages Response: ${response.body}');
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      logger.e('Error fetching messages: $e');
    }
    return messages;
  }

  Future<int> postMessage(String loginRollNo, String message, DateTime timestamp) async {
    logger.d("Entered post message");
    logger.d("rollno $loginRollNo, Message: $message, Timestamp: $timestamp");
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/messages'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "rollno": loginRollNo,
          "message": message,
          "timestamp": timestamp.toIso8601String(), // Convert timestamp to ISO 8601 string
        }),
      );
      logger.d('POST Message Response Status Code: ${response.statusCode}');
      return response.statusCode;
    } catch (e) {
      logger.d('Failed to post message: $e');
      return 0;
    }
  }
}
