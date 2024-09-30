import 'package:flutter/material.dart';
import 'dart:math';
import 'package:number/constant/color.dart';
import 'package:number/component/number_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> selectedNumbers = [];
  List<int> randomNumbers = [];
  final int maxNumber = 45;

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    Set<int> selectedSet = Set.from(selectedNumbers);
    while (selectedSet.length < 6) {
      int randomNumber = Random().nextInt(maxNumber) + 1;
      if (!selectedSet.contains(randomNumber)) {
        selectedSet.add(randomNumber);
      }
    }
    setState(() {
      randomNumbers = selectedSet.toList();
      randomNumbers.shuffle();
    });
  }

  void selectNumber(int number) {
    if (selectedNumbers.contains(number)) {
      setState(() {
        selectedNumbers.remove(number);
      });
    } else {
      if (selectedNumbers.length < 5) {
        setState(() {
          selectedNumbers.add(number);
        });
      }
    }
    generateRandomNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF443BC8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50), // 상단 여백 추가
            const Text(
              'Random Number Generator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x3D34B3).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Selected Numbers',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        selectedNumbers.isNotEmpty
                            ? selectedNumbers.map((e) => e.toString()).join(', ')
                            : 'No Numbers Selected',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Random Numbers',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: randomNumbers
                            .map((number) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: selectedNumbers.contains(number)
                                  ? const Color(0xF85C60).withOpacity(0.9)
                                  : const Color(0xFF645BC6).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10), // 타원형
                            ),
                            child: Center(
                              child: Text(
                                number.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: generateRandomNumbers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF443BC8),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Generate Random Numbers'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => NumberPickerScreen(
                    onNumberSelected: selectNumber,
                    selectedNumbers: selectedNumbers,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF443BC8),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Pick Numbers'),
            ),
          ],
        ),
      ),
    );
  }
}
