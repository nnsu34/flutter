import 'package:flutter/material.dart';

class AlertHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alert History',
          style: TextStyle(color: Colors.white),  // 앱바가 빨간색일 때 글자색을 흰색으로 설정
        ),
        backgroundColor: Color(0xFFE43022),  // #E43022
        iconTheme: IconThemeData(color: Colors.white),  // 아이콘 색상도 흰색으로 설정
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: 10,  // 임시로 10개의 알림 기록을 표시
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Alert $index - Event occurred at 12:30 PM'),
                leading: Icon(Icons.warning, color: Color(0xFFE43022)),  // 경고 아이콘 색상도 빨간색
              );
            },
          ),
        ),
      ),
    );
  }
}
