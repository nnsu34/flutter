import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> selectedNumbers = []; // 사용자가 선택한 번호 리스트
  List<int> randomNumbers = [1, 2, 3, 4, 5, 6]; // 기본 랜덤 숫자
  Random random = Random(); // 랜덤 함수 사용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(), // 배경 이미지 설정
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24), // 상단 여백
                  _buildHeader(), // Header
                  const SizedBox(height: 30), // Header와 Body 사이 여백
                  _buildBody(), // Body
                  const Spacer(),
                  _buildFooter(), // Footer
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 배경 이미지 빌드 함수
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'asset/img/background_img.png', // 배경 이미지 경로
        fit: BoxFit.cover,
      ),
    );
  }

  // Header 부분
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        ' Random\n Numbers',
        style: TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  // Body 부분
  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF3D34B3), // 배경색
        borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNumberSection( // 선택된 번호 섹션
            'Selected Numbers',
            selectedNumbers,
            const Color(0xFF625CBF), // 선택된 번호 배경색
            Colors.white, // 선택된 번호 글자색
          ),
          const SizedBox(height: 60), // 간격 추가
          _buildGeneratedNumberSection(), // 생성된 난수 섹션
        ],
      ),
    );
  }

  // Footer 부분
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 33.0),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton('Pick', _showNumberPicker), // Pick 버튼
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildActionButton('Generate', _generateRandomNumbers), // Generate 버튼
          ),
        ],
      ),
    );
  }

  // Action Button 빌드 함수
  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'safety',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4C49A6),
        ),
      ),
    );
  }

  // 선택된 번호 섹션 빌드 함수
  Widget _buildNumberSection(
      String title, List<int> numbers, Color backgroundColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) {
            bool isInRange = index < numbers.length;
            return Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isInRange ? backgroundColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text(
                    isInRange ? numbers[index].toString() : '',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 생성된 난수 섹션 빌드 함수
  Widget _buildGeneratedNumberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Generated Numbers',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) {
            bool isSelected = selectedNumbers.contains(randomNumbers[index]);
            return Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xe6FF5B56) // 선택된 번호 색상
                      : const Color(0xFF635EF2), // 기본 생성된 번호 색상
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text(
                    randomNumbers[index].toString(),
                    style: const TextStyle(
                      color: Colors.white, // 글자색 흰색
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 랜덤 숫자 생성 함수
  void _generateRandomNumbers() {
    setState(() {
      final Set<int> generatedNumbers = {...selectedNumbers};
      while (generatedNumbers.length < 6) {
        generatedNumbers.add(random.nextInt(45) + 1); // 1부터 45까지 랜덤 숫자 생성
      }
      randomNumbers = generatedNumbers.toList()..sort(); // 오름차순 정렬
    });
  }

  // 숫자 선택 다이얼로그
  void _showNumberPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        List<int> tempSelectedNumbers = [...selectedNumbers]; // 임시 선택 리스트

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(25.0),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ' Choose Numbers',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B4B6D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: GridView.count(
                        crossAxisCount: 5,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        children: List.generate(45, (index) {
                          final number = index + 1;
                          final isSelected =
                          tempSelectedNumbers.contains(number);

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  tempSelectedNumbers.remove(number); // 선택 해제
                                } else if (tempSelectedNumbers.length < 6) {
                                  tempSelectedNumbers.add(number); // 선택
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF85C60)
                                    : const Color(0xFFF4F5FC),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  number.toString(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF4B4B6D),
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16.0), // 상하 여백 추가
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setModalState(() {
                                tempSelectedNumbers.clear(); // 임시 선택 초기화
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF645BC6),
                              padding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontFamily: 'safety',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20), // 두 버튼 사이에 여백 추가
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedNumbers = [...tempSelectedNumbers]
                                  ..sort(); // 선택된 번호 적용 및 정렬
                              });
                              Navigator.pop(context); // 다이얼로그 닫기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF645BC6),
                              padding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                fontFamily: 'safety',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
