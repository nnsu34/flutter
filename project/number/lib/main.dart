import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> selectedNumbers = [];
  List<int> randomNumbers = [];
  final int maxNumber = 45; // 고를 수 있는 숫자를 45로 제한

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
  }

  // 랜덤 숫자 생성, 사용자가 선택한 숫자는 무조건 포함
  void generateRandomNumbers() {
    Set<int> selectedSet = Set.from(selectedNumbers); // 선택된 숫자를 세트로 변환
    while (selectedSet.length < 6) {
      int randomNumber = Random().nextInt(maxNumber) + 1;
      if (!selectedSet.contains(randomNumber)) {
        selectedSet.add(randomNumber); // 중복되지 않게 숫자 추가
      }
    }
    setState(() {
      randomNumbers = selectedSet.toList();
      randomNumbers.shuffle(); // 숫자 섞기
    });
  }

  // 숫자 선택 핸들러
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
    generateRandomNumbers(); // 선택된 숫자를 기반으로 다시 랜덤 숫자 생성
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF443BC8), // 배경색 적용
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40), // 상단 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60), // Random Number Generator 위에 더 많은 공간 추가
            const Text(
              'Random Number\nGenerator',
              style: TextStyle(
                fontFamily: 'Paperlogy', // 폰트 설정
                fontSize: 28, // 글씨 크기 증가
                fontWeight: FontWeight.bold,
                color: Colors.white, // 흰색 글자
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // 선택된 숫자와 랜덤 숫자를 같은 사각형에 표시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0x3D34B3).withOpacity(0.8), // 짙은 파란색 배경에 투명도 적용
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
                children: [
                  const Text(
                    'Selected Numbers',
                    style: TextStyle(
                      fontFamily: 'Paperlogy', // 폰트 설정
                      color: Colors.white70, // 흰색 텍스트에 약간의 투명도 적용
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // 글씨 크기 증가
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 선택된 숫자를 텍스트로 표시
                  Text(
                    selectedNumbers.isNotEmpty
                        ? selectedNumbers.map((e) => e.toString()).join(', ')
                        : 'No Numbers Selected',
                    style: TextStyle(
                      fontFamily: 'Paperlogy', // 폰트 설정
                      color: Colors.white.withOpacity(0.8), // 약간의 투명도 적용
                      fontSize: 18, // 글씨 크기 증가
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Random Numbers',
                    style: TextStyle(
                      fontFamily: 'Paperlogy', // 폰트 설정
                      color: Colors.white70, // 흰색 텍스트에 약간의 투명도 적용
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // 글씨 크기 증가
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 랜덤 숫자 표시, 선택된 숫자는 강조
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: randomNumbers
                        .map((number) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 50, // 숫자 배경의 크기 증가
                        height: 50, // 숫자 배경의 크기 증가
                        decoration: BoxDecoration(
                          color: selectedNumbers.contains(number)
                              ? const Color(0xF85C60).withOpacity(0.9) // 강조된 색상에 투명도 적용
                              : const Color(0xFF645BC6).withOpacity(0.8), // 랜덤 숫자 배경색에 투명도 적용
                          borderRadius: BorderRadius.circular(15), // 둥근 사각형 느낌
                        ),
                        child: Center(
                          child: Text(
                            number.toString(),
                            style: const TextStyle(
                              fontFamily: 'Paperlogy', // 폰트 설정
                              fontSize: 20, // 숫자 글씨 크기 증가
                              color: Colors.white,
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
            const Spacer(), // 아래 위젯들을 하단으로 밀기 위한 Spacer 추가

            // 랜덤 번호 생성 버튼
            ElevatedButton(
              onPressed: generateRandomNumbers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 흰 배경 적용
                foregroundColor: const Color(0xFF443BC8), // 파란색 텍스트
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Generate Random Numbers',
                style: TextStyle(
                  fontFamily: 'Paperlogy', // 폰트 설정
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // 버튼 글씨 크기 증가
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 숫자 선택 버튼
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
                backgroundColor: Colors.white, // 흰색 배경
                foregroundColor: const Color(0xFF443BC8), // 진한 파란색 텍스트
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Pick Numbers',
                style: TextStyle(
                  fontFamily: 'Paperlogy', // 폰트 설정
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // 버튼 글씨 크기 증가
                ),
              ),
            ),
            const SizedBox(height: 30), // 하단 여백 추가
          ],
        ),
      ),
    );
  }
}

// 숫자 선택 화면 (모달 다이얼로그)
class NumberPickerScreen extends StatelessWidget {
  final Function(int) onNumberSelected;
  final List<int> selectedNumbers;

  const NumberPickerScreen({
    required this.onNumberSelected,
    required this.selectedNumbers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400, // 화면 절반 크기
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // 한 줄에 5개씩 숫자
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: 45, // 1부터 45까지 숫자
        itemBuilder: (context, index) {
          int number = index + 1;
          return GestureDetector(
            onTap: () => onNumberSelected(number),
            child: Container(
              decoration: BoxDecoration(
                color: selectedNumbers.contains(number)
                    ? const Color(0xF85C60).withOpacity(0.9) // 강조된 색상에 투명도 적용
                    : const Color(0xFF645BC6).withOpacity(0.8), // 선택 가능한 숫자의 배경색
                borderRadius: BorderRadius.circular(15), // 둥근 사각형 느낌
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    fontFamily: 'Paperlogy', // 폰트 설정
                    fontSize: 20, // 숫자 글씨 크기 증가
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
