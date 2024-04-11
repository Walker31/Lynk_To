import 'package:flutter/material.dart';
import 'package:llm_noticeboard/components/group_card.dart';
import 'package:llm_noticeboard/pages/chat_page.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});
  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {

  List<String> groups = [
    "ECE A",
    "ECE B",
  ];

  final _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (
        ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            child: GroupCard(groups[index]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(groups[index])));
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 2,
          );
        },
        itemCount: groups.length,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewGroup,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Group'),
          content: TextField(
            controller: _groupNameController, // Assign controller to text field
            decoration: const InputDecoration(
              hintText: 'Enter Group Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newGroupName = _groupNameController.text;
                if (newGroupName.isNotEmpty) {
                  // Add group logic (e.g., update groups list, server interaction)
                  setState(() {
                    groups.add(newGroupName);
                  });
                  _groupNameController.clear(); // Clear text field after adding
                }
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }



}
