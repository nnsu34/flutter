import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/occupant_dialog.dart';
import '../widgets/building_card.dart';
import '../widgets/floor_list.dart';
import '../models/facility_model.dart';
import '../services/api_service.dart';

class BuildingListScreen extends StatefulWidget {
  final Facility facility;

  const BuildingListScreen({super.key, required this.facility});

  @override
  _BuildingListScreenState createState() => _BuildingListScreenState();
}

class _BuildingListScreenState extends State<BuildingListScreen> {
  bool isExpandedBuilding1 = true; // 기본 열림 상태
  bool isExpandedBuilding2 = true; // 기본 열림 상태

  List<String> floorsBuilding1 = ['AI소프트웨어과', '자동화시스템과'];
  List<int> peopleCountsBuilding1 = [0, 0, 0]; // FastAPI 데이터로 업데이트
  Map<String, List<Map<String, dynamic>>> occupantsData = {}; // 사용자 데이터 저장

  @override
  void initState() {
    super.initState();
    fetchOccupancyData(); // FastAPI로부터 데이터를 가져옴
  }

  // 인원 데이터를 가져오는 함수 (ApiService 사용)
  Future<void> fetchOccupancyData() async {
    try {
      // ApiService를 사용하여 각 층의 인원 데이터를 가져옴
      final data1 = await ApiService.fetchOccupancyData(1); // 1층 인원수
      final data2 = await ApiService.fetchOccupancyData(2); // 2층 인원수

      setState(() {
        peopleCountsBuilding1[0] = data1['occupancy']; // 1층 인원수 업데이트
        peopleCountsBuilding1[1] = data2['occupancy']; // 2층 인원수 업데이트
      });
    } catch (e) {
      print('Error fetching data: $e'); // 에러 출력
    }
  }

  // 특정 층의 사용자 데이터를 가져오는 함수 (ApiService 사용)
  Future<void> fetchOccupantsData(int floor) async {
    try {
      // ApiService를 사용하여 사용자 데이터를 가져옴
      final occupants = await ApiService.fetchOccupantsData(floor);
      setState(() {
        occupantsData['${floor}F'] = occupants.map((user) {
          return {
            'user_id': user['user_id'].toString(),
            'name': user['name'] ?? 'Unknown',
            'role': user['status'] == 'IN' ? '입장 중' : '퇴장 중',
            'phone': '010-1234-5678', // 예시 데이터
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching occupants data: $e'); // 에러 출력
    }
  }

  void _showBottomSheet(
      BuildContext context, String floorName, int floorIndex) async {
    // 특정 층에 있는 사용자 정보를 가져옴
    await fetchOccupantsData(floorIndex + 1);

    // occupantsData에서 String 타입으로 변환
    List<Map<String, String?>> occupants =
        occupantsData['${floorIndex + 1}F']?.map((occupant) {
          return {
            'name': occupant['name'] as String?,
            'role': occupant['role'] as String?,
            'profileImage': null,
            'phone': occupant['phone'] as String?,
          };
        }).toList() ??
            [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return OccupantDialog(
          floorName: floorName,
          occupants: occupants,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F7FA), Color(0xFFE6E9F0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),

                // 타이틀 텍스트
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '건물 목록',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'manru', // 폰트 지정
                      color: const Color(0xFF121212).withOpacity(0.85),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 캠퍼스 이름
                Padding(
                  padding: const EdgeInsets.only(left: 14.0), // 왼쪽 여백 추가
                  child: Opacity(
                    opacity: 0.85,
                    child: Text(
                      '한국폴리텍대학 진주캠퍼스',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF121212).withOpacity(0.5),
                        fontFamily: 'manru', // 폰트 지정
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

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
                            ? const Color(0xFF4B4F87)
                            : Colors.white,
                        textColor: isExpandedBuilding1
                            ? Colors.white
                            : const Color(0xFF121212).withOpacity(0.85),
                        elevation: 4.0,
                        onTap: () {}, // 열림 상태로 고정
                      ),
                      if (isExpandedBuilding1)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: FloorList(
                            floors: floorsBuilding1,
                            peopleCounts:
                            peopleCountsBuilding1, // FastAPI로부터 받은 데이터 사용
                            onFloorTap: (context, floorName) {
                              _showBottomSheet(context, floorName,
                                  floorsBuilding1.indexOf(floorName));
                            },
                          ),
                        ),

                      // 여백 추가
                      const SizedBox(height: 20),

                      // 창의공학관 카드
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