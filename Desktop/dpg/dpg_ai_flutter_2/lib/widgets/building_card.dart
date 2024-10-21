import 'package:flutter/material.dart';

class BuildingCard extends StatelessWidget {
  final String buildingName;
  final bool isExpanded;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final double elevation; // 카드 그림자 높이

  const BuildingCard({
    super.key,
    required this.buildingName,
    required this.isExpanded,
    required this.onTap,
    this.backgroundColor = Colors.white, // 기본 배경 색상은 흰색
    this.textColor = Colors.black, // 기본 텍스트 색상은 검정색
    this.elevation = 0.0, // 기본 elevation 값
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 클릭 시 이벤트 처리
      child: Card(
        elevation: elevation, // 카드 그림자 높이 설정
        color: backgroundColor, // 배경 색상 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 건물 이름 표시
              Text(
                buildingName,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'manru',
                  color: textColor, // 텍스트 색상 설정
                ),
              ),
              // 확장 여부에 따른 화살표 아이콘
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down // 확장 상태 아이콘
                    : Icons.keyboard_arrow_right, // 기본 상태 아이콘
                color: textColor, // 아이콘 색상 설정
              ),
            ],
          ),
        ),
      ),
    );
  }
}