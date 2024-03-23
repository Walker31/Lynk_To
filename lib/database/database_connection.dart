import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class DatabaseConnection {
  final Logger _logger = Logger();

  Future<List<dynamic>> fetchEvents(String selectedDate) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/events/108121009/$selectedDate'),
      );

      // Log the request URL and response status code
      _logger.d('Request URL: ${response.request?.url}');
      _logger.d('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final events = json.decode(response.body);
        // Log the fetched events
        _logger.i('Fetched Events: $events');
        return events;
      } else {
        // Log the error message if the response status code is not 200
        _logger.e('Failed to load events: ${response.body}');
        throw Exception('Failed to load events');
      }
    } catch (e) {
      // Log any other errors that occur during the request
      _logger.e('Error fetching events: $e');
      throw Exception('Failed to load events');
    }
  }
}
