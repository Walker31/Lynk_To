import 'package:flutter/material.dart';
import 'package:llm_noticeboard/Api/user_info.dart';
import 'package:llm_noticeboard/database/database_connection.dart';
import 'package:llm_noticeboard/database/user_details.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';



class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<dynamic> events = []; // List to store fetched events
  Logger logger= Logger();

  String loginRollNo="108121001";
  late String userName="";


  @override
  void initState() {
    super.initState();
    final userDetails = Provider.of<UserProvider>(context, listen: false).userDetails;
    if (userDetails != null) {
      loginRollNo = userDetails.rollNo;
    }
    _fetchUserInfo();
    fetchEvents(DateTime.now().toString());
     // Initial fetch with current date
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            loginRollNo,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

            // Display fetched events
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  // Customize the display of each event according to your needs
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      title: Text(
                        event['subject_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                            event['event_type'],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Time: ${event['event_time']}',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // Add any additional customization or functionality as needed
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _fetchUserInfo() async {
    try {
      Map<String, dynamic>? userInfo = await UserInfo().getUserInfo(loginRollNo);
      if (userInfo != null) {
        setState(() {
          userName = userInfo['user_name'];
        });
        logger.i('User Info: Roll No: $loginRollNo, Name: $userName');
      } else {
        logger.e('User details not found');
      }
    } catch (e) {
      logger.e('Error fetching user info: $e');
    }
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

}

