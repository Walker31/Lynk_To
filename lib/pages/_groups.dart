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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (
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
    );
  }
}
