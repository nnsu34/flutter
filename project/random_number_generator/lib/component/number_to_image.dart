import 'package:flutter/material.dart';

class NumberToImage extends StatelessWidget {
  final int number;

  const NumberToImage({
    required this.number,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: number
          .toInt()
          .toString()
          .split('')
          .map(
            (number) => Image.asset(
              'asset/img/$number.png',
              width: 60,
              height: 80,
            ),
          )
          .toList(),
    );
  }
}
