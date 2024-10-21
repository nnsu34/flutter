import 'package:flutter/material.dart';
import 'screens/facility_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '현장 인원 관리 시스템',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FacilityListScreen(), // 시설 목록 화면
    );
  }
}
