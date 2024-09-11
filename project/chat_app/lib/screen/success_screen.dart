import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('성공 화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign in Successful!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 18),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/login');
            },
                child: Text('Sign out'))
          ],
        ),
      ),
    )
  }
}
