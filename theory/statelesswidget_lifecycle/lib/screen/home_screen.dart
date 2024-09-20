import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TestWidget(),
    );
  }
}

class TestWidget extends StatelessWidget {
  TestWidget({super.key}) {
    print('--- 생성자 ---');
  }

  @override
  Widget build(BuildContext context) {
    print('--- 빌드 ---');
    return Container(
      width: 50.0,
      height: 50.0,
      color: Colors.red,
    );
  }
}
