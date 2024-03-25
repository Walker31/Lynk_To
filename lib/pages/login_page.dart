import 'package:flutter/material.dart';
import 'package:llm_noticeboard/Api/auth.dart';
import 'package:llm_noticeboard/database/user_details.dart';
import 'package:llm_noticeboard/pages/_calendar.dart';
import 'package:llm_noticeboard/pages/home_page.dart';
import 'package:llm_noticeboard/pages/register_page.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart'; // Import the logger package

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController rollno = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscurePassword = true; // Initially password is obscured

  final Logger logger = Logger(); // Create an instance of the logger

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center, // Center the content vertically
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 40), // Increase spacing
              TextField(
                controller: rollno,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Roll No.",
                  prefixIcon: const Icon(Icons.person), // Add icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: password,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock), // Add icon
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    child: const Text(
                      'Register here.',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set button background color
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Set button padding
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Set button shape
                ),
                onPressed: () async {
                  if (rollno.text.isEmpty || password.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in all fields."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  logger.d('Logging in with Roll No.: ${rollno.text}'); // Log Roll No.
                  logger.d('Logging in with Password: ${password.text}'); // Log Password

                  int? response = await Auth().login(int.parse(rollno.text), password.text);
                  logger.d('Login Response Code: $response');

                  if (response == 200) {
                    const CalendarPage();
                    // ignore: use_build_context_synchronously
                    Provider.of<UserProvider>(context, listen: false).setUserDetails(
                    rollno.text,
                    password.text,
                    );
                    Navigator.push(
                      
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid Credentials"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text("Login", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
