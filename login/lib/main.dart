import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screen/login_screen.dart';
import 'screen/chat_screen.dart';
import 'screen/signup_screen.dart';
import 'screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/login_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (_) => LoginProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}