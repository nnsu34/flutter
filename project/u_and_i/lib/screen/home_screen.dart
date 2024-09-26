import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now(); // 기본 날짜는 현재 날짜

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100], // 배경색 설정
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // 화면 크기 설정
          child: Column(
            children: [
              _Top(
                selectedDate: selectedDate, // 선택된 날짜 전달
                onPressed: onHeartPressed, // 하트 버튼 클릭 시 이벤트
              ),
              _Bottom(), // 하단 이미지
            ],
          ),
        ),
      ),
    );
  }

  // 하트 버튼 클릭 시 날짜 선택 다이얼로그 표시
  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white, // 다이얼로그 배경
            height: 300.0,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date, // 날짜만 선택
              initialDateTime: selectedDate, // 선택된 날짜 설정
              maximumDate: DateTime.now(), // 오늘까지 선택 가능
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  selectedDate = date; // 선택된 날짜 업데이트
                });
              },
              dateOrder: DatePickerDateOrder.ymd, // 날짜 형식 (년.월.일)
            ),
          ),
        );
      },
    );
  }
}

class _Top extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback? onPressed;

  const _Top({
    required this.selectedDate,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now(); // 현재 날짜
    final textTheme = Theme.of(context).textTheme; // 텍스트 스타일

    return Expanded(
      child: Container(
        child: Column(
          children: [
            Text(
              'U&I',
              style: textTheme.displayLarge,
            ),
            Text(
              '우리 처음 만난날',
              style: textTheme.bodyLarge,
            ),
            Text(
              '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}', // 선택된 날짜 표시
              style: textTheme.bodyMedium,
            ),
            IconButton(
              iconSize: 60.0,
              color: Colors.red,
              onPressed: onPressed,
              icon: Icon(Icons.favorite), // 하트 아이콘
            ),
            Text(
              'D+${now.difference(selectedDate).inDays + 1}', // D-Day 계산
              style: textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Image.asset(
          'asset/img/middle_image.png', // 하단 이미지
        ),
      ),
    );
  }
}
