import 'package:flutter/material.dart';

class ProfileManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Management'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 프로필 사진 변경 기능
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,),
              child: Text('Change Profile Picture'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 비밀번호 변경 페이지로 이동
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,),
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
