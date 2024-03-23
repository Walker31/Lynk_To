import 'package:flutter/material.dart';
import 'package:llm_noticeboard/pages/home_page.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: const Home(),
    debugShowCheckedModeBanner: false,
  ));
}
