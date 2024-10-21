import 'package:flutter/material.dart';
import 'graph_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FloorList extends StatefulWidget {
  final int building;
  final String selectedFloor;
  final Function(String) onFloorSelected;

  FloorList({
    required this.building,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

  @override
  _FloorListState createState() => _FloorListState();
}

class _FloorListState extends State<FloorList> {
  Map<String, int> occupancyData = {};

  @override
  void initState() {
    super.initState();
    fetchOccupancyData(); // 층별 인원 데이터를 가져오는 함수 호출
  }

  Future<void> fetchOccupancyData() async {
    for (var i = 1; i <= 3; i++) {
      final occupancy = await fetchOccupancy(i);
      setState(() {
        occupancyData['${i}F'] = occupancy;
      });
    }
  }

  Future<int> fetchOccupancy(int floorNumber) async {
    final url = 'http://192.168.10.23:8000/zones/floor/$floorNumber';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['occupancy'];
    } else {
      throw Exception('Failed to load occupancy data');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPeople = occupancyData.values.fold(0, (a, b) => a + b); // 총 인원 계산

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20.0), // 바깥쪽 여백
      padding: const EdgeInsets.only(left: 8.0, right: 6.0), // 내부 여백
      decoration: BoxDecoration(
        color: Colors.white, // 흰색 배경
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), // 오른쪽 위 둥근 모서리
          bottomRight: Radius.circular(20), // 오른쪽 아래 둥근 모서리
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // 그림자 색상
            blurRadius: 10, // 그림자 흐림 정도
            offset: Offset(3, 3), // 그림자의 위치
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.33, // 화면의 3분의 1 너비 설정
      child: ListView.separated(
        itemCount: occupancyData.length,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey.withOpacity(0.4), // 더 연한 실선 색상
            thickness: 1, // 실선 두께
          );
        },
        itemBuilder: (context, index) {
          String floorName = '${index + 1}F';
          int currentPeople = occupancyData[floorName] ?? 0;

          return GestureDetector(
            onTap: () {
              widget.onFloorSelected(floorName); // 층 선택 시 호출
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0), // 내부 여백 유지
              child: GraphCard(
                floorName: floorName, // 층 이름 전달
                currentPeople: currentPeople, // 해당 층의 현재 인원수
                totalPeople: totalPeople, // 전체 인원수
                isSelected: widget.selectedFloor == floorName, // 선택 여부 전달
                ratio: currentPeople / (totalPeople > 0 ? totalPeople : 1), // 그래프 비율 계산
              ),
            ),
          );
        },
      ),
    );
  }
}