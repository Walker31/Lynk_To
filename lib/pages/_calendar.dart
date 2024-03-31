import 'dart:async';
import 'package:flutter/material.dart';
import 'package:llm_noticeboard/components/calendar_card.dart';
import 'package:llm_noticeboard/database/database_connection.dart';
import 'package:llm_noticeboard/database/user_details.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late StreamController<String> _streamController;
  List<dynamic> events = [];
  final logger = Logger();
  String loginRollNo="108121001";

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    _streamController.stream.listen((date) {
      fetchEvents(date); // Listen to changes in selected date
    });
    fetchEvents(DateTime.now().toString());
    final userDetails =
        Provider.of<UserProvider>(context, listen: false).userDetails;
    if (userDetails != null) {
      loginRollNo = userDetails.rollNo;
    } // Initial fetch with current date
  }

  Future<void> fetchEvents(String selectedDate) async {
    try {
      final databaseConnection = DatabaseConnection();
      logger.d(selectedDate);
      DateTime dateTime = DateTime.parse(selectedDate);
      String date =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      final fetchedEvents =
          await databaseConnection.fetchEvents(date, loginRollNo);
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
            child: EventListPage(
              streamController: _streamController,
              events: events,
            ),
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

  const EventListPage({
    Key? key,
    required this.streamController,
    required this.events,
  }) : super(key: key);

  @override
  EventListPageState createState() => EventListPageState();
}

class EventListPageState extends State<EventListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: widget.events.isEmpty
          ? const Center(child: Text("You are Free Today"))
          : ListView.separated(
              itemCount: widget.events.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final event = widget.events[index];
                final eventTime = event['event_time'];
                final formattedTime = _formatTime(eventTime);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        event['subject_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event['event_type'],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
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