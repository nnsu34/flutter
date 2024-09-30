import 'package:flutter/material.dart';
import 'package:dpg/screen/login_page.dart';
import 'package:dpg/screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Safety System',
      theme: ThemeData(
        primaryColor: Color(0xFFE43022),  // #E43022
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFFE43022),  // #E43022
          secondary: Colors.white,
          background: Color(0xFFF7F7F7),  // #F7F7F7
        ),
        fontFamily: 'Arial',
      ),
      home: AuthenticationChecker(),
    );
  }
}

class AuthenticationChecker extends StatelessWidget {
  final bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return isAuthenticated ? HomeScreen() : LoginPage();
  }
}
