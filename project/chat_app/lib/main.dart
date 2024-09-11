import 'package:chat_app/screen/signup_screen.dart';
import 'package:chat_app/screen/success_screen.dart';
import 'package:flutter/material.dart';
import 'screen/login_screen.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/success': (context) => SuccessScreen(),
      },
    );
  }
}
