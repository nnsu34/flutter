import 'package:flutter/material.dart';

class NumberDisplay extends StatelessWidget {
  final List<int> numbers;
  final bool isRandom;

  const NumberDisplay({
    required this.numbers,
    this.isRandom = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((number) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isRandom ? Colors.blue : Colors.grey, // 임의로 구분
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}
