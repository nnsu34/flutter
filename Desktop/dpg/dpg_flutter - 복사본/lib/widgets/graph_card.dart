import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GraphCard extends StatelessWidget {
  final String floorName;
  final int currentPeople;
  final int totalPeople;
  final bool isSelected;
  final double ratio;

  GraphCard({
    required this.floorName,
    required this.currentPeople,
    required this.totalPeople,
    this.isSelected = false,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    // 선택된 상태에 따른 색상 설정
    Color progressColor = isSelected ? Color(0xFFFF6346) : Colors.black;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // 그림자 효과 제거
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  floorName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans', // 폰트 적용
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16), // 화살표 아이콘
            ],
          ),
          SizedBox(height: 16),
          _buildDonutGraph(currentPeople / (totalPeople > 0 ? totalPeople : 1), currentPeople, progressColor), // 0으로 나눔 방지
        ],
      ),
    );
  }

  // 둥근 사각형 그래프 위젯
  Widget _buildDonutGraph(double ratio, int currentPeople, Color progressColor) {
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DonutGraphPainter(ratio, progressColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row( // 명수와 '명'을 한 줄에 배치
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$currentPeople',
                    style: TextStyle(
                      fontSize: 24, // 명수 숫자 크기
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sans', // 폰트 적용
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 2), // 명수와 '명' 사이에 여백 추가
                  Baseline(
                    baseline: 22.0, // '명' 텍스트의 기준선을 아래로 조정
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      '명',
                      style: TextStyle(
                        fontSize: 18, // "명" 텍스트 크기
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sans', // 폰트 적용
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    // 배경 원 그리기
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // 진행 그래프 그리기
    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // 사각형 경로 생성
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(20)); // 둥근 사각형 경로

    // 배경 경로 그리기
    canvas.drawRRect(rrect, backgroundPaint);

    // 전체 둘레 및 진행 비율에 따른 길이 계산
    double perimeter = 2 * (size.width + size.height - 24); // 전체 둘레 계산
    double progress = ratio * perimeter; // 비율에 따른 진행 길이

    Path path = Path();
    path.addRRect(rrect); // 둥근 사각형 경로 추가

    // 경로 계산 및 그리기
    ui.PathMetrics pathMetrics = path.computeMetrics();
    for (ui.PathMetric metric in pathMetrics) {
      double startOffset = metric.length * 0.15; // 오른쪽에서 시작
      Path extractPath = metric.extractPath(startOffset, startOffset + progress);
      canvas.drawPath(extractPath, progressPaint); // 진행 경로 그리기
    }
  }

  @override
  bool shouldRepaint(DonutGraphPainter oldDelegate) {
    return oldDelegate.ratio != ratio || oldDelegate.progressColor != progressColor;
  }
}