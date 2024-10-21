import 'package:flutter/material.dart';

class FloorList extends StatelessWidget {
  final List<String> floors;
  final List<int> peopleCounts;
  final Function(BuildContext, String) onFloorTap; // onFloorTap 콜백

  const FloorList({
    super.key,
    required this.floors,
    required this.peopleCounts,
    required this.onFloorTap, // 필수로 콜백 받음
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // 카드 그림자 높이
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        child: Column(
          children: floors.asMap().entries.map(
                (entry) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 층을 클릭 시 onFloorTap 콜백 호출
                      onFloorTap(context, entry.value);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 층수 표시
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            '${entry.key + 1}F',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'manru',
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 층 이름 표시
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'manru',
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                        // 인원수 아이콘
                        Container(
                          width: 45,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F0F7),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '${peopleCounts[entry.key]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'manru',
                              color: Color(0xFF4B4F87),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 항목 간 구분선
                  if (entry.key < floors.length - 1)
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                      thickness: 1,
                      height: 24,
                    ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}