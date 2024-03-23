import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Auth {
  final Logger logger = Logger();

  Future<int?> login(int rollno, String password) async {
    logger.d("Entered login func");
    try {

      logger.d("enterterd try");
      logger.d(password);
      logger.d(rollno);
      http.Response response = await http.post(
        Uri.parse('http://localhost:3000/login'),
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
        Uri.parse('http://localhost:3000/create_user'),
        body: {
          "name": name,
          "rollno": rollno.toString(),
          "password": password,
        },
      );
      return response.statusCode;
    } catch (e) {
      logger.e(e);
      return null; // Return null in case of an error
    }
  }
}
