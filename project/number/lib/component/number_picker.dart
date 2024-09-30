import 'package:flutter/material.dart';
import 'package:number/constant/color.dart';

class NumberPickerScreen extends StatefulWidget {
  const NumberPickerScreen({Key? key}) : super(key: key);

  @override
  _NumberPickerScreenState createState() => _NumberPickerScreenState();
}

class _NumberPickerScreenState extends State<NumberPickerScreen> {
  List<int> pickedNumbers = [];

  void onNumberSelected(int number) {
    setState(() {
      if (pickedNumbers.contains(number)) {
        pickedNumbers.remove(number);
      } else if (pickedNumbers.length < 5) {
        pickedNumbers.add(number);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, pickedNumbers);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Choose\nNumbers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 20),
            // Picked Numbers Display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: randomNumberBackgroundColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pickedNumbers.isNotEmpty
                    ? pickedNumbers
                    .map(
                      (num) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '$num',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                    .toList()
                    : [
                  Text(
                    'Pick 5 numbers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(50, (index) {
                final number = index + 1;
                final isSelected = pickedNumbers.contains(number);
                return GestureDetector(
                  onTap: () => onNumberSelected(number),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : randomNumberBackgroundColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20), // 타원형 디자인
                    ),
                    child: Center(
                      child: Text(
                        '$number',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : textColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
