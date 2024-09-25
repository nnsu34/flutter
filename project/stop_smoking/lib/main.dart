import 'package:flutter/material.dart';
import 'package:stop_smoking/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      theme: ThemeData(
        fontFamily: 'ubuntu', // 기본 글꼴 설정
        textTheme: TextTheme(

          displayLarge: TextStyle( //숫자
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Color(0xFF53736A),
          ),

          displayMedium: TextStyle( // day
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF53736A),
          ),

          bodyLarge: TextStyle( // stop smoking
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF53736A),
          ),

          bodyMedium: TextStyle( // 현재 날짜
            fontSize: 18.0,
            color: Color(0xFF53736A),
          ),
        ),
      ),
      home: HomeScreen(), // HomeScreen을 시작 화면으로 설정
    ),
  );
}
