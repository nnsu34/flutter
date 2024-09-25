import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식 변환을 위한 intl 패키지

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now(); // 기본 날짜를 현재 날짜로 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/img/background_img.png'), // 배경 이미지 설정
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _Top(
                selectedDate: selectedDate, // 선택된 날짜 전달
                onDateChanged: (newDate) {
                  setState(() {
                    selectedDate = newDate; // 선택된 날짜 갱신
                  });
                },
              ), // 상단 UI
              _Bottom(selectedDate: selectedDate), // 하단 UI
            ],
          ),
        ),
      ),
    );
  }
}

// 상단 UI 컴포넌트 (날짜 선택과 타이틀 포함)
class _Top extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _Top({
    required this.selectedDate,
    required this.onDateChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme; // 텍스트 테마 사용

    // 날짜 형식 변환 (년.월(영어).일)
    String formattedDate = DateFormat('yyyy.MMM.dd').format(selectedDate);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stop\nSmoking',
                style: textTheme.bodyLarge?.copyWith(
                  height: 1, // 줄 간격 조정
                ),
              ), // 타이틀
              IconButton(
                icon: Icon(Icons.circle, color: Color(0xFF53736A).withOpacity(1), size: 60.0),
                onPressed: () {
                  _selectDate(context); // 날짜 선택 다이얼로그 열기
                },
              ),
            ],
          ),
          SizedBox(height: 9.0),
          // 선택된 날짜 표시
          Text(
            formattedDate, // 형식 변환된 날짜 표시
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // 날짜 선택 다이얼로그 구현
  void _selectDate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = selectedDate; // 임시로 선택된 날짜

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF53736A), // 선택된 날짜 색상
              onPrimary: Colors.white, // 선택된 날짜 텍스트 색상
              onSurface: Colors.black, // 기본 텍스트 색상
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyle(fontSize: 14.0), // 월/연도 텍스트 크기
              titleSmall: TextStyle(fontSize: 12.0), // 요일 텍스트 크기
              bodyMedium: TextStyle(fontSize: 10.0), // 날짜 숫자 크기
            ),
          ),
          child: AlertDialog(
            title: Text(
              "Select Date", // 다이얼로그 제목
              style: TextStyle(
                fontSize: 25, // 제목 크기
                fontFamily: 'ubuntu', // 제목 글꼴 유지
                fontWeight: FontWeight.bold,
                color: Color(0xFF53736A),
              ),
            ),
            content: SizedBox(
              width: 300,
              height: 300,
              child: CalendarDatePicker(
                initialDate: tempPickedDate, // 초기 날짜
                firstDate: DateTime(2000), // 선택 가능한 첫 날짜
                lastDate: DateTime.now(), // 선택 가능한 마지막 날짜
                onDateChanged: (DateTime date) {
                  tempPickedDate = date; // 선택된 날짜 임시 저장
                },
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ubuntu',
                    color: Color(0xFF515252),
                  ),
                ), // 취소 버튼
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
              TextButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ubuntu',
                    color: Color(0xFF515252),
                  ),
                ), // 확인 버튼
                onPressed: () {
                  onDateChanged(tempPickedDate); // 날짜 갱신
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// 하단 UI 컴포넌트 (D-Day 표시)
class _Bottom extends StatelessWidget {
  final DateTime selectedDate;

  const _Bottom({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now(); // 현재 날짜
    final int diffDays = now.difference(selectedDate).inDays + 1; // D-Day 계산
    final textTheme = Theme.of(context).textTheme; // 텍스트 테마 사용

    // D-Day를 3자리 숫자로 표시
    String formattedDiffDays;
    if (diffDays < 1000) {
      formattedDiffDays = diffDays.toString().padLeft(3, '0'); // 3자리로 패딩
    } else {
      formattedDiffDays = diffDays.toString(); // 1000부터는 그대로 표시
    }

    return Expanded(
      child: Align(
        alignment: Alignment.bottomLeft, // 왼쪽 하단 정렬
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, bottom: 50.0), // 여백 추가
          child: Column(
            mainAxisSize: MainAxisSize.min, // 필요한 공간만 차지
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Text(
                'day',
                style: textTheme.displayMedium?.copyWith(
                  fontFamily: 'ubuntu',
                ),
              ),
              Text(
                formattedDiffDays, // D-Day 숫자 표시
                style: textTheme.displayLarge?.copyWith(
                  fontFamily: 'ubuntu',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
