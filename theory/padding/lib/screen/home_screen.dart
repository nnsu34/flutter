import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            32,
            64,
            16,
            8,
          ),
          child: Container(
            color: Colors.blue,
            width: 50,
            height: 50,
          ),
        ),
      ),
    ));
  }
}
