import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/floor_list.dart';
import '../widgets/personnel_list.dart';

class BuildingSelectionScreen extends StatefulWidget {
  @override
  _BuildingSelectionScreenState createState() =>
      _BuildingSelectionScreenState();
}

class _BuildingSelectionScreenState extends State<BuildingSelectionScreen> {
  int selectedBuilding = 1;
  String selectedFloorName = '1F';

  @override
  void initState() {
    super.initState();
    // 투명한 상태바와 다크 아이콘 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTitle(), // 메인 타이틀 '한국폴리텍대학'
              _buildCampusTitle(), // 캠퍼스 이름 '진주캠퍼스'
              SizedBox(height: 10),
              _buildBuildingSelection(), // 건물 선택 영역
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: FloorList(
                  building: selectedBuilding,
                  selectedFloor: selectedFloorName,
                  onFloorSelected: (floorName) {
                    setState(() {
                      selectedFloorName = floorName; // 층 선택 시 상태 업데이트
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: PersonnelList(floorName: selectedFloorName), // 선택된 층의 인원 리스트 표시
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 메인 타이틀 생성
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '한국폴리텍대학',
        style: TextStyle(
          fontSize: 40,
          fontFamily: 'sans',
          fontWeight: FontWeight.w700,
          color: Color(0xFF121212).withOpacity(0.85),
        ),
      ),
    );
  }

  // 캠퍼스 이름 생성
  Widget _buildCampusTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 16.0),
      child: Text(
        '진주캠퍼스',
        style: TextStyle(
          fontSize: 22,
          fontFamily: 'sans',
          fontWeight: FontWeight.w400,
          color: Color(0xFF828282),
        ),
      ),
    );
  }

  // 건물 선택 위젯 생성
  Widget _buildBuildingSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 200,
          height: 60,
          padding: EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedBuilding = 1; // '교육1관' 선택 시 빌딩 설정
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.apps, color: Color(0xFF121212).withOpacity(0.85)),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '교육1관',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121212).withOpacity(0.85),
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
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