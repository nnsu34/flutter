import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f7f7),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 130.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/flutter_logo.png',
              ),
              SizedBox(height: 30.0),
              CircularProgressIndicator(
                color: Color(0xFFe0e0e0)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
