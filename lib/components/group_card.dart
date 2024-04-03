import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
var Name;

class GroupCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final name;
  GroupCard(this.name, {super.key}) {
    Name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.grey.shade200),
      child: Row(children: [
        const CircleAvatar(
          child: Icon(Icons.group),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: Text(
            name,
            style:
                const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis , fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}
