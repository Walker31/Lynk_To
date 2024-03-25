import 'dart:async';
import 'package:flutter/material.dart';
import 'package:llm_noticeboard/components/calendar_card.dart';
import 'package:llm_noticeboard/database/database_connection.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';


class CalendarPage extends StatefulWidget {

  final String rollno;
  const CalendarPage({Key? key, required this.rollno}) : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late StreamController<String> _streamController;
  List<dynamic> events = [];
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    _streamController.stream.listen((date) {
      fetchEvents(date); // Listen to changes in selected date
    });
    fetchEvents(DateTime.now().toString()); // Initial fetch with current date
  }

  Future<void> fetchEvents(String selectedDate) async {
    try {
      final databaseConnection = DatabaseConnection();
      logger.d(selectedDate);
      DateTime dateTime = DateTime.parse(selectedDate);
      String date = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      final fetchedEvents = await databaseConnection.fetchEvents(date,widget.rollno);
      setState(() {
        events = fetchedEvents;
      });
      logger.i('Fetched events: $events'); // Log fetched events
    } catch (e) {
      logger.e('Error fetching events: $e'); // Log error if fetching events fails
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CalendarCard(streamController: _streamController),
          const SizedBox(height: 20),
          Expanded(
            child: EventListPage(streamController: _streamController, events: events),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

class EventListPage extends StatefulWidget {
  final StreamController<String> streamController;
  final List<dynamic> events;

  const EventListPage({Key? key, required this.streamController, required this.events}) : super(key: key);

  @override
  EventListPageState createState() => EventListPageState();
}

class EventListPageState extends State<EventListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button from AppBar
      ),
      body: ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (context, index) {
      final event = widget.events[index];
      final eventTime = event['event_time'];
      final formattedTime = _formatTime(eventTime); // Format the time
      return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding
      child: Card(
        elevation: 2, // Add elevation for a shadow effect
        child: ListTile(
          title: Text(
            event['subject_name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Add bold font weight
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event['event_type'],
                style: const TextStyle(
                  fontStyle: FontStyle.italic, // Italicize event type
                ),
              ),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontStyle: FontStyle.italic, // Italicize formatted time
                ),
              ),
            ],
          ),// Use the formatted time
          ), // Add trailing icon
        ),
    );
  },
),

    );
  }
}

String _formatTime(String time) {
  final parsedTime = TimeOfDay.fromDateTime(DateTime.parse('2024-03-21 $time'));
  return DateFormat.jm().format(DateTime(2024, 3, 21, parsedTime.hour, parsedTime.minute));
}