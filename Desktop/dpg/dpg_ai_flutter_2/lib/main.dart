import 'package:flutter/material.dart';
import 'screens/building_list_screen.dart';
import 'models/facility_model.dart';

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
      home: BuildingListScreen(
        facility: Facility(
          name: '한국폴리텍대학 진주캠퍼스',
          buildings: [
            '교육1관',
            '창의공학관',
          ],
        ),
      ),
    );
  }
}
