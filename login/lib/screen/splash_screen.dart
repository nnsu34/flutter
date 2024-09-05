import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    await Future.delayed(Duration(seconds: 3));
    context.read<LoginProvider>().currentUser();
    User? user = context.read<LoginProvider>().user;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/chat');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // 노란색 배경
      body: Center(
        child: Text(
          'CHAT',
          style: TextStyle(
            fontSize: 36,

            color: Colors.black, // 텍스트 색상
          ),
        ),
      ),
    );
  }
}
