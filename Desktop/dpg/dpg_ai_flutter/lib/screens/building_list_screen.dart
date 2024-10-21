import 'package:flutter/material.dart';
import '../widgets/building_card.dart';
import '../widgets/floor_list.dart';
import '../models/facility_model.dart';
import 'facility_list_screen.dart';

class BuildingListScreen extends StatefulWidget {
  final Facility facility;

  BuildingListScreen({required this.facility});

  @override
  _BuildingListScreenState createState() => _BuildingListScreenState();
}

class _BuildingListScreenState extends State<BuildingListScreen> {
  bool isExpandedBuilding1 = false;
  bool isExpandedBuilding2 = false;

  // 각 건물의 층 및 인원 정보
  List<String> floorsBuilding1 = ['AI소프트웨어과', '자동화시스템과', '스마트전기과'];
  List<int> peopleCountsBuilding1 = [10, 25, 20];

  List<String> floorsBuilding2 = ['컴퓨터응용기계과', '공용컴퓨터실', '광고디자인과'];
  List<int> peopleCountsBuilding2 = [40, 15, 35];

  // 건물 클릭 시 확장/축소 상태 전환
  void toggleBuilding(String building) {
    setState(() {
      if (building == '교육1관') {
        isExpandedBuilding1 = !isExpandedBuilding1;
      } else if (building == '창의공학관') {
        isExpandedBuilding2 = !isExpandedBuilding2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F7FA), Color(0xFFE6E9F0)], // 배경 그라디언트
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 네비게이션 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FacilityListScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 타이틀 텍스트
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '건물 목록',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'manru',
                      color: Color(0xFF121212).withOpacity(0.85),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // 캠퍼스 이름
                Opacity(
                  opacity: 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.facility.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF121212).withOpacity(0.5),
                        fontFamily: 'manru',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // 건물 리스트
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    children: [
                      // 교육1관 카드
                      BuildingCard(
                        buildingName: '교육1관',
                        isExpanded: isExpandedBuilding1,
                        backgroundColor: isExpandedBuilding1
                            ? Color(0xFF4B4F87) // 선택된 경우 강조
                            : Colors.white,
                        textColor: isExpandedBuilding1 ? Colors.white : Color(0xFF121212).withOpacity(0.85),
                        elevation: 4.0, // 그림자 효과
                        onTap: () => toggleBuilding('교육1관'),
                      ),
                      if (isExpandedBuilding1)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: FloorList(floors: floorsBuilding1, peopleCounts: peopleCountsBuilding1), // 교육1관 층 리스트
                        ),

                      SizedBox(height: 10),

                      // 창의공학관 카드
                      BuildingCard(
                        buildingName: '창의공학관',
                        isExpanded: isExpandedBuilding2,
                        backgroundColor: isExpandedBuilding2
                            ? Color(0xFF4B4F87)
                            : Colors.white,
                        textColor: isExpandedBuilding2 ? Colors.white : Color(0xFF121212).withOpacity(0.85),
                        elevation: 4.0,
                        onTap: () => toggleBuilding('창의공학관'),
                      ),
                      if (isExpandedBuilding2)
                        FloorList(floors: floorsBuilding2, peopleCounts: peopleCountsBuilding2), // 창의공학관 층 리스트
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
