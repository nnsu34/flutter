import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sunflower',
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontFamily: 'parisienne',
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'sunflower',
            fontSize: 50,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'sunflower',
            fontSize: 30,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'sunflower',
            fontSize: 20,
          ),
        ),
      ),
      home: HomeScreen(),
    ),
  );
}
