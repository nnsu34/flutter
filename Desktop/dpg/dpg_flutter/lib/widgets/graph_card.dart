import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GraphCard extends StatelessWidget {
  final String floorName; // 층 이름
  final int currentPeople;
  final int totalPeople;
  final bool isSelected;
  final double ratio; // 비율 추가

  GraphCard({
    required this.floorName,
    required this.currentPeople,
    required this.totalPeople,
    this.isSelected = false,
    required this.ratio, // 비율 매개변수 추가
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor = isSelected ? Color(0xFFFF6346).withOpacity(0.85) : Color(0xFF121212).withOpacity(0.85); // 선택 여부에 따라 색상 결정

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white, // 위젯 배경색 #F7F7F7
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(5, 5), // 오른쪽과 아래에만 그림자
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          // 층 이름과 화살표 아이콘에 여백 추가
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0), // 상단과 좌우 여백 추가
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  floorName, // 층 이름
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF121212).withOpacity(0.85),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans', // 글씨체 적용
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16), // 화살표 아이콘
              ],
            ),
          ),
          SizedBox(height: 15), // 여백 추가

          // 그래프를 하단으로 배치하고 크기를 키움
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120, // 그래프 크기
                    height: 120, // 그래프 크기
                    padding: const EdgeInsets.all(6), // 그래프 테두리 흰색 여백
                    decoration: BoxDecoration(
                      color: Colors.white, // 그래프 배경 흰색
                      borderRadius: BorderRadius.circular(60), // 둥근 모서리
                    ),
                    child: CustomPaint(
                      size: Size(120, 120),
                      painter: DonutGraphPainter(ratio, progressColor),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentPeople',
                              style: TextStyle(
                                fontSize: 24, // 명수 숫자 크기 증가
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans', // 글씨체 적용
                                color: Color(0xFF121212).withOpacity(0.85), // 색상 변경
                              ),
                            ),
                            TextSpan(
                              text: '명',
                              style: TextStyle(
                                fontSize: 16, // "명" 크기는 그대로 유지
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans', // 글씨체 적용
                                color: Color(0xFF121212).withOpacity(0.85), // 색상 변경
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '인원수',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'sans', // 글씨체 적용
                          color: Color(0xFF121212).withOpacity(0.4), // 옅은 "인원수" 텍스트
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10), // 하단에 여백 추가
        ],
      ),
    );
  }
}

class DonutGraphPainter extends CustomPainter {
  final double ratio;
  final Color progressColor;

  DonutGraphPainter(this.ratio, this.progressColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12  // 그래프 선 두께
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = progressColor // 선택 여부에 따라 색상 설정
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12  // 진행률 선 두께
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(20)); // 둥근 모서리 유지
    canvas.drawRRect(rrect, backgroundPaint); // 배경 경로 그리기

    double perimeter = 2 * (size.width + size.height - 24); // 전체 둘레 계산
    double progress = ratio * perimeter; // 비율에 따른 진행 길이

    Path path = Path();
    path.addRRect(rrect); // 둥근 사각형 경로 추가

    ui.PathMetrics pathMetrics = path.computeMetrics();

    for (ui.PathMetric metric in pathMetrics) {
      // 시작점을 오른쪽 변에 해당하는 위치로 설정 (사각형의 둘레의 25% 지점)
      double startOffset = metric.length * 0.15; // 오른쪽 변에서 시작

      // 진행 비율을 적용하여 경로를 추출, 시작점에서 progress만큼 이동
      Path extractPath = metric.extractPath(startOffset, startOffset + progress);
      canvas.drawPath(extractPath, progressPaint); // 경로 그리기
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
