import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Auth {
  final Logger logger = Logger();

  Future<int?> login(int rollno, String password) async {
    logger.d("Entered login function");
    try {
      http.Response response = await http.post(
        Uri.https('link-to-backend.azurewebsites.net','/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'rollno': rollno,
          'password': password,
        }),
      );
      logger.d(response.body);
      return response.statusCode;
    } catch (e) {
      logger.e(e);
      return null; // Return null in case of an error
    }
  }

  Future<int?> signup(String name, int rollno, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://link-to-backend.azurewebsites.net/create_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'rollno': rollno,
          'password': password,
        }),
      );
      return response.statusCode;
    } catch (e) {
      logger.e(e);
      return null; // Return null in case of an error
    }
  }
}
