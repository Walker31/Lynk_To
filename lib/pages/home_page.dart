import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:llm_noticeboard/pages/_calendar.dart';
import 'package:llm_noticeboard/pages/_dashboard.dart';
import 'package:llm_noticeboard/pages/_groups.dart';
// ignore: unused_import
import 'package:llm_noticeboard/Api/auth.dart'; // Import your authentication API

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> pages = [
    const DashboardPage(key: PageStorageKey('Dashboard')),
    const GroupsPage(key: PageStorageKey('Groups')),
    const CalendarPage(key: PageStorageKey('Calendar')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  var _selectedIndex = 0;

  void _signOut() async {
    // Call your sign-out method from the authentication API
    //await Auth().signOut();
    // Navigate back to the login page
    Navigator.pop(context); // Remove the home page from the stack
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 0.7),
        child: AppBar(
          backgroundColor: Colors.blue.shade400, // Set the background color to blue shade 400
          elevation: 0, // Remove the shadow
          title: const Text(
            "Lynk To",
            style: TextStyle(
              color: Colors.white, // Set the text color to white
              fontSize: 20, // Adjust the font size
              fontWeight: FontWeight.bold, // Apply bold font weight
            ),
          ),
          centerTitle: true, // Center the title horizontally
          automaticallyImplyLeading: false, // Remove the back button
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white), // Set icon color to white
              onPressed: _signOut,
            ),
          ],
        ),
      ),

      body: PageStorage(bucket: bucket, child: pages[_selectedIndex]),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50,
        backgroundColor: Colors.blueAccent,
        color: Colors.black,
        buttonBackgroundColor: Colors.blueAccent,
        items: const [
          Icon(Icons.dashboard, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.calendar_today, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
