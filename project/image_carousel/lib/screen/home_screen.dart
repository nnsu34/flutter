import 'package:flutter/material.dart'; // Flutter 패키지 임포트
import 'dart:async'; // Timer를 사용하기 위한 dart:async 패키지 임포트

// StatefulWidget을 사용해 상태를 관리하는 HomeScreen 클래스
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// _HomeScreenState에서 상태 관리
class _HomeScreenState extends State<HomeScreen> {
  Timer? timer; // 타이머 변수 선언
  PageController controller = PageController(); // PageView를 제어하기 위한 PageController 선언

  @override
  void initState() {
    super.initState();

    // Timer.periodic을 사용해 2초마다 자동으로 페이지 전환
    timer = Timer.periodic(
      Duration(seconds: 2), // 2초 간격으로 실행
          (timer) {
        // 현재 페이지 인덱스 가져오기
        int currentPage = controller.page!.toInt();
        // 다음 페이지 계산, 마지막 페이지 이후 첫 페이지로 돌아가게 설정
        int nextPage = currentPage + 1;

        if (nextPage > 4) { // 이미지가 5개이므로 인덱스 4 이상이면 0으로 설정
          nextPage = 0;
        }
        // 페이지 전환 시 애니메이션 효과 적용
        controller.animateToPage(
          nextPage, // 이동할 페이지
          duration: Duration(milliseconds: 500), // 애니메이션 전환 속도 (500ms)
          curve: Curves.linear, // 직선으로 부드럽게 이동
        );
      },
    );
  }

  @override
  void dispose() {
    // 타이머가 null이 아니면 취소하여 불필요한 메모리 소모 방지
    if (timer != null) {
      timer!.cancel();
    }
    // PageController도 해제
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView를 사용해 여러 이미지를 슬라이드로 표시
      body: PageView(
        controller: controller, // PageController로 페이지 제어
        children: [1, 2, 3, 4, 5]  // 5개의 이미지를 슬라이드
            .map(
              (e) => Image.asset(
            'asset/img/image_$e.jpg', // 등록한 이미지를 사용
            fit: BoxFit.cover, // 이미지를 화면에 맞게 채우기
          ),
        )
            .toList(),
      ),
    );
  }
}