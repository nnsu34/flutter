import 'package:flutter/material.dart';
import 'package:stop_smoking/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      theme: ThemeData(
        fontFamily: 'ubuntu', // 기본 글꼴 설정
        textTheme: TextTheme(
          displayLarge: TextStyle(
            //숫자
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Color(0xFF53736A).withOpacity(0.9),
          ),
          displayMedium: TextStyle(
            // day
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF53736A).withOpacity(0.7),
          ),
          bodyLarge: TextStyle(
            // stop smoking
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF53736A).withOpacity(1),
          ),
          bodyMedium: TextStyle(
            // 현재 날짜
            fontSize: 20.0,
            color: Color(0xFF53736A).withOpacity(0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: HomeScreen(),
    ),
  );
}
