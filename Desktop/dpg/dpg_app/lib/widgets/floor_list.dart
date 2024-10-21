
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'graph_card.dart'; // GraphCard 위젯 import

class FloorList extends StatefulWidget {
  final int building; // 건물 정보
  final String selectedFloor; // 선택된 층
  final Function(String) onFloorSelected; // 선택 이벤트 처리 함수

  FloorList({
    required this.building,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

  @override
  _FloorListState createState() => _FloorListState();
}

class _FloorListState extends State<FloorList> {
  List<Map<String, dynamic>> floors = [];
  int totalPeople = 0;
  bool isLoading = true;
  String selectedFloor = '1F'; // 처음에 1F 자동 선택

  @override
  void initState() {
    super.initState();
    fetchFloorData(); // API 데이터 가져오기
  }

  // 층별 사용자 정보를 가져오는 함수
  Future<void> fetchFloorData() async {
    try {
      List<Map<String, dynamic>> loadedFloors = [];

      // 1층 사용자 정보 가져오기
      var response1 = await fetchUserDataForFloor(1);
      if (response1 != null) {
        loadedFloors.add({
          'zone_name': '1F',
          'current_occupancy': response1.length,
          'users': response1,
        });
      }

      // 2층 사용자 정보 가져오기
      var response2 = await fetchUserDataForFloor(2);
      if (response2 != null) {
        loadedFloors.add({
          'zone_name': '2F',
          'current_occupancy': response2.length,
          'users': response2,
        });
      }

      // 총 인원 계산
      int total = (response1?.length ?? 0) + (response2?.length ?? 0);

      setState(() {
        floors = loadedFloors;
        totalPeople = total;
        isLoading = false; // 데이터 로딩 완료
        selectedFloor = '1F'; // 1F 자동 선택
      });
    } catch (error) {
      print("Error: $error");
      setState(() {
        isLoading = false; // 오류 발생 시 로딩 상태 해제
      });
    }
  }

  // 특정 층의 사용자 정보를 가져오는 함수
  Future<List<dynamic>?> fetchUserDataForFloor(int floorNumber) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.10.23:8000/zones/floor/$floorNumber/users'));
      if (response.statusCode == 200) {
        List<dynamic> userData = jsonDecode(utf8.decode(response.bodyBytes));
        return userData;
      } else {
        print("Failed to load user data for floor $floorNumber.");
        return [];
      }
    } catch (error) {
      print("Error fetching user data for floor $floorNumber: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.3)),
        ),
      );
    }

    if (floors.isEmpty) {
      return Center(child: Text("층별 정보가 없습니다.")); // 데이터가 없을 경우 표시
    }

    return Container(
      height: 200, // 고정된 높이 설정
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로로 스크롤
        physics: AlwaysScrollableScrollPhysics(), // 항상 스크롤 가능하도록 설정
        itemCount: floors.length,
        itemBuilder: (context, index) {
          String floorName = floors[index]['zone_name'];
          int currentPeople = floors[index]['current_occupancy'];
          double ratio = totalPeople > 0 ? currentPeople / totalPeople : 0; // 각 층의 비율 계산

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFloor = floorName; // 선택된 층 업데이트
              });
              widget.onFloorSelected(floorName); // 층 선택 시 콜백 호출
            },
            child: Container(
              width: 150, // 각 아이템의 너비
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GraphCard(
                floorName: floorName, // 층 이름 전달
                currentPeople: currentPeople,
                totalPeople: totalPeople, // 건물의 총 인원수 전달
                isSelected: selectedFloor == floorName, // 선택 여부 전달
                ratio: ratio, // 층의 비율 전달
              ),
            ),
          );
        },
      ),
    );
  }
}