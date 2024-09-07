import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '로그인 성공! ${user?.email}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<LoginProvider>(context, listen: false)
                    .signOut();
                Navigator.pushNamed(context, '/login');
              },
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}