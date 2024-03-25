import 'package:flutter/material.dart';
import 'package:llm_noticeboard/database/user_details.dart';
import 'package:llm_noticeboard/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(_) => UserProvider(),
      child: MaterialApp(
    theme: ThemeData.dark(),
    home: const Login(),
    debugShowCheckedModeBanner: false,
  )
    );
  }
}