import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/floor_list.dart'; // FloorList 위젯 임포트
import '../widgets/personnel_list.dart'; // PersonnelList 위젯 임포트

class BuildingSelectionScreen extends StatefulWidget {
  @override
  _BuildingSelectionScreenState createState() =>
      _BuildingSelectionScreenState();
}

class _BuildingSelectionScreenState extends State<BuildingSelectionScreen> {
  int selectedBuilding = 1; // 기본 선택된 건물
  String selectedFloorName = '1F'; // 기본 선택된 층을 '1F'로 변경

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F5F5), // 더 밝은 회색 (상단)
              Color(0xFFE8E8E8), // 밝은 회색 (하단)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTitle(),
              _buildCampusTitle(),
              SizedBox(height: 20),
              _buildBuildingSelection(),
              SizedBox(height: 0),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: FloorList(
                        building: selectedBuilding,
                        selectedFloor: selectedFloorName,
                        onFloorSelected: (floorName) {
                          setState(() {
                            selectedFloorName = floorName;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0), // 하단 여백 추가
                        child: PersonnelList(
                          floorName: selectedFloorName,
                          building: selectedBuilding, // building 값을 넘겨줍니다.
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '한국폴리텍대학',
        style: TextStyle(
          fontSize: 40,
          fontFamily: 'sans',
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

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

  Widget _buildBuildingSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Align(
        alignment: Alignment.centerLeft, // 왼쪽 정렬
        child: Container(
          width: 200, // 너비를 좀 더 넓게 조정
          height: 60, // 높이 설정
          padding: EdgeInsets.only(left: 20), // 왼쪽 여백 추가
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedBuilding = 1; // 건물 선택 로직
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // 아이템들을 왼쪽 정렬
              children: [
                Icon(Icons.apps, color: Colors.black), // 'apps' 아이콘 사용
                SizedBox(width: 10), // 아이콘과 텍스트 사이 여백
                Flexible( // 텍스트가 잘리지 않게 Flexible 사용
                  child: Text(
                    '교육1관',
                    style: TextStyle(
                      fontSize: 18, // 글씨 크기 증가
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w500, // 굵기를 조금 얇게
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트 넘칠 때 생략
                    softWrap: false, // 텍스트가 잘리지 않도록 설정
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