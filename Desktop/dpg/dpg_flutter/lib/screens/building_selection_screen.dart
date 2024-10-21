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
          padding: const EdgeInsets.all(12.0), // PersonDetailsScreen과 동일한 여백
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // 여백 추가
              _buildTitle(), // 한국폴리텍대학 텍스트 상단 배치
              SizedBox(height: 0), // 여백 추가
              _buildCampusTitle(),
              SizedBox(height: 10),
              _buildBuildingSelection(),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
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
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: PersonnelList(floorName: selectedFloorName),
                ),
              ),
              SizedBox(height: 30),
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
        '한국폴리텍대학', // 상단에 위치
        style: TextStyle(
          fontSize: 40,
          fontFamily: 'sans',
          fontWeight: FontWeight.w700,
          color: Color(0xFF121212).withOpacity(0.85), // 변경된 색상
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
        alignment: Alignment.centerLeft,
        child: Container(
          width: 200,
          height: 60,
          padding: EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedBuilding = 1;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.apps, color: Color(0xFF121212).withOpacity(0.85)), // 변경된 색상
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '교육1관',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121212).withOpacity(0.85), // 변경된 색상
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
