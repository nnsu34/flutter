import 'package:flutter/material.dart';
import 'screens/building_selection_screen.dart'; // 건물 선택 화면 임포트

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BuildingSelectionScreen(), // 시작 화면으로 BuildingSelectionScreen 설정
    );
  }
}
