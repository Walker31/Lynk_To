import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import the curved navigation bar package
import 'package:flutter/material.dart';
import 'package:llm_noticeboard/pages/_calendar.dart';
import 'package:llm_noticeboard/pages/_dashboard.dart';
import 'package:llm_noticeboard/pages/_groups.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> pages = const [
    DashboardPage(key: PageStorageKey('Dashboard')),
    GroupsPage(key: PageStorageKey('Groups')),
    CalendarPage(key: PageStorageKey('Calendar'), rollno: '108121009',),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link To"),
        automaticallyImplyLeading: false,
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
          Icon(Icons.group, size: 30),
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
