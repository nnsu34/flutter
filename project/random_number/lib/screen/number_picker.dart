import 'package:flutter/material.dart';

class NumberPickerScreen extends StatefulWidget {
  const NumberPickerScreen({super.key});

  @override
  State<NumberPickerScreen> createState() => _NumberPickerScreenState();
}

class _NumberPickerScreenState extends State<NumberPickerScreen> {
  List<int> selectedNumbers = [];

  // 숫자 선택 함수
  void selectNumber(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else if (selectedNumbers.length < 5) {
        selectedNumbers.add(number);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF443BC8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF443BC8),
        title: const Text('Choose 5 numbers'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // 선택된 숫자를 보여주는 UI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: index < selectedNumbers.length
                          ? Colors.redAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        index < selectedNumbers.length
                            ? selectedNumbers[index].toString()
                            : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 번호 선택을 위한 그리드 뷰
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5개의 숫자가 한 줄에
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 45, // 1부터 45까지의 숫자
                itemBuilder: (context, index) {
                  final number = index + 1;
                  final isSelected = selectedNumbers.contains(number);
                  return GestureDetector(
                    onTap: () {
                      selectNumber(number);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.redAccent
                            : const Color(0xFFe4e5f6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          number.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF443BC8),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // 결제 버튼
            ElevatedButton(
              onPressed: () {
                // 결제 처리 로직 또는 다음 화면으로 이동
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: const Color(0xFF443BC8),
              ),
              child: const Text(
                'Make a Payment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
