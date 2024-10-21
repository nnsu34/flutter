import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GraphCard extends StatelessWidget {
  final String floorName; // 층 이름
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
    Color progressColor = isSelected ? Color(0xFFFF6346).withOpacity(0.85) : Color(0xFF121212).withOpacity(0.85);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  floorName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF121212).withOpacity(0.85),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Icon(
                    Icons.sync,
                    size: 25,
                    color: Color(0xFF121212).withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans',
                                color: Color(0xFF121212).withOpacity(0.85),
                              ),
                            ),
                            TextSpan(
                              text: '명',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans',
                                color: Color(0xFF121212).withOpacity(0.85),
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
                          fontFamily: 'sans',
                          color: Color(0xFF121212).withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class DonutGraphPainter extends CustomPainter {
  final double ratio; // 진행률을 나타내는 비율
  final Color progressColor; // 진행 그래프 색상

  DonutGraphPainter(this.ratio, this.progressColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(20));
    canvas.drawRRect(rrect, backgroundPaint); // 배경 경로 그리기

    double perimeter = 2 * (size.width + size.height - 24); // 경로 둘레 계산
    double progress = ratio * perimeter; // 비율에 따른 진행 길이

    Path path = Path();
    path.addRRect(rrect); // 경로에 둥근 사각형 추가

    ui.PathMetrics pathMetrics = path.computeMetrics();

    for (ui.PathMetric metric in pathMetrics) {
      double startOffset = metric.length * 0.15; // 오른쪽에서 시작
      Path extractPath = metric.extractPath(startOffset, startOffset + progress); // 진행 경로 추출
      canvas.drawPath(extractPath, progressPaint); // 진행 경로 그리기
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 항상 다시 그리기
  }
}
