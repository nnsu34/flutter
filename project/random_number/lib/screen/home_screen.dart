import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> randomNumbers = [1, 2, 3, 4, 5]; // 기본값으로 1, 2, 3, 4, 5 표시
  List<int> selectedNumbers = []; // 사용자가 선택한 숫자 리스트 (List 타입으로 설정)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 배경 이미지 추가
          Positioned.fill(
            child: Image.asset(
              'asset/img/background_img.png', // 배경 이미지 경로 수정
              fit: BoxFit.cover, // 이미지를 화면에 맞게 조정
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 상단 영역 - 'Random Numbers' 텍스트와 생성된 숫자 표시
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Random Numbers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36.0, // 글자 크기 증가
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// 생성된 랜덤 번호들 표시 영역
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        alignment: WrapAlignment.center,
                        children: randomNumbers.map((number) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0), // 둥근 모서리 사각형
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              number.toString(),
                              style: const TextStyle(
                                fontSize: 28.0, // 숫자 크기
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B4B6D),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      /// 랜덤 번호 생성 버튼
                      ElevatedButton(
                        onPressed: _generateRandomNumbers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF645BC6),
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Generate Random Numbers',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 번호 선택 다이얼을 열 수 있는 영역
                Expanded(
                  child: _NumberPicker(
                    selectedNumbers: selectedNumbers, // List로 유지
                    onNumberSelected: _onNumberSelected,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 랜덤 숫자 생성 함수
  void _generateRandomNumbers() {
    final Random random = Random();
    List<int> numbers = List<int>.from(selectedNumbers); // 사용자가 선택한 숫자 포함

    // 6개의 숫자가 될 때까지 랜덤 숫자 추가
    while (numbers.length < 6) {
      int newNumber = random.nextInt(45) + 1;
      if (!numbers.contains(newNumber)) {
        numbers.add(newNumber); // 중복되지 않는 숫자 추가
      }
    }

    setState(() {
      randomNumbers = numbers; // 리스트 업데이트
      randomNumbers.sort(); // 숫자 정렬
    });
  }

  /// 숫자 선택/해제 로직
  void _onNumberSelected(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else if (selectedNumbers.length < 5) {
        selectedNumbers.add(number);
      }
    });
  }
}

/// 번호 선택을 위한 다이얼 그리드 표시 위젯
class _NumberPicker extends StatelessWidget {
  final List<int> selectedNumbers; // Set에서 List로 변경
  final Function(int) onNumberSelected;

  const _NumberPicker({
    required this.selectedNumbers,
    required this.onNumberSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 5,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        shrinkWrap: true,  // GridView가 부모의 제약에 맞게 축소되도록 설정
        children: List.generate(45, (index) {
          final number = index + 1;
          final isSelected = selectedNumbers.contains(number);

          return GestureDetector(
            onTap: () => onNumberSelected(number),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF85C60) : const Color(0xFFF4F5FC),
                borderRadius: BorderRadius.circular(10.0), // 모서리 둥근 사각형
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF4B4B6D),
                    fontSize: 20.0, // 숫자 크기
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
