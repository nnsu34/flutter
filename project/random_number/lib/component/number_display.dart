import 'package:flutter/material.dart';

class NumberDisplay extends StatelessWidget {
  final int number;

  const NumberDisplay({
    required this.number,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      number.toString(),
      style: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
