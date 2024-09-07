import 'package:flutter/material.dart';
import 'package:web_view/screen/home_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

