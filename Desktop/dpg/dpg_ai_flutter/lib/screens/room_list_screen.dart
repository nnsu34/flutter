import 'package:flutter/material.dart';
import 'facility_list_screen.dart';
import 'person_details_screen.dart';

class RoomListScreen extends StatefulWidget {
  final String floorName;

  RoomListScreen({required this.floorName});

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<String> rooms = ['AI LAB실', 'AI 프로그래밍실', '교수실', '탕비실', '로비'];

  // 방별 인원 및 로그 추가
  Map<String, List<Map<String, String?>>> roomOccupants = {
    'AI LAB실': [
      {'name': '박지운', 'role': '학생', 'profileImage': null},
      {'name': '곽지훈', 'role': '학생', 'profileImage': null},
      {'name': '게스트', 'role': '미확인', 'profileImage': null},
    ],
    'AI 프로그래밍실': [
      {'name': '박다운', 'role': '학생', 'profileImage': null},
      {'name': '문병현', 'role': '학생', 'profileImage': null},
      {'name': '정영도', 'role': '학생', 'profileImage': null},
      {'name': '게스트', 'role': '미확인', 'profileImage': null},
    ],
    '교수실': [
      {'name': '김정헌', 'role': '교수', 'profileImage': null},
    ],
    '탕비실': [],
    '로비': [
      {'name': '신수현', 'role': '학생', 'profileImage': null},
      {'name': '게스트', 'role': '미확인', 'profileImage': null},
    ],
  };

  // 학생별 활동 로그
  Map<String, List<Map<String, String>>> studentLogs = {
    '박지운': [
      {
        'date': '2024-10-03',
        'action': '입장',
        'location': 'AI 프로그래밍실',
        'time': '10:48'
      },
      {
        'date': '2024-10-03',
        'action': '퇴장',
        'location': 'AI 프로그래밍실',
        'time': '11:52'
      },
      {'date': '2024-10-03', 'action': '입장', 'location': '로비', 'time': '12:50'},
      {'date': '2024-10-03', 'action': '퇴장', 'location': '로비', 'time': '12:10'},
      {
        'date': '2024-10-03',
        'action': '입장',
        'location': 'AI LAB실',
        'time': '13:12'
      },
    ],
    '곽지훈': [
      {
        'date': '2024-10-03',
        'action': '입장',
        'location': 'AI LAB실',
        'time': '10:48'
      },
      {
        'date': '2024-10-03',
        'action': '퇴장',
        'location': 'AI LAB실',
        'time': '10:48'
      },
    ],
    '박다운': [
      {
        'date': '2024-10-03',
        'action': '입장',
        'location': 'AI 프로그래밍실',
        'time': '12:50'
      },
      {
        'date': '2024-10-03',
        'action': '퇴장',
        'location': 'AI 프로그래밍실',
        'time': '12:50'
      },
    ],
  };

  String? selectedRoom;

  // 하단 다이얼로그 표시 함수
  void _showBottomSheet(BuildContext context, String roomName) {
    List<Map<String, String?>> occupants = roomOccupants[roomName] ?? [];
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45, // 하단 다이얼로그 크기 설정
          decoration: BoxDecoration(
            color: Color(0xFFEAEAEC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          padding: const EdgeInsets.all(24.0), // 내부 여백 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$roomName 인원 목록',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'manru',
                ),
              ),
              SizedBox(height: 16),
              occupants.isNotEmpty
                  ? Flexible(
                // 인원 목록이 길 경우 스크롤 가능하게 설정
                child: ListView.builder(
                  itemCount: occupants.length,
                  itemBuilder: (context, index) {
                    final occupant = occupants[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0), // 학생 리스트 간 여백
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0), // 내부 여백 설정
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.only(left: 8.0, right: 16.0),
                            leading: Container(
                              width: 56.0, // 프로필 사진 크기
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F0F7),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 32.0,
                                color: Color(0xFF4B4F87),
                              ),
                            ),
                            title: Text(
                              occupant['name']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'manru',
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                occupant['role'] == '미확인'
                                    ? '미확인' // 게스트는 미확인으로 표시
                                    : occupant['role']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'manru',
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonDetailsScreen(
                                    studentName: occupant['name']!,
                                    studentRole: occupant['role']!,
                                    logs: studentLogs[occupant['name']] ?? [],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
                  : Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    '인원이 없습니다.',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'manru',
                      color: Colors.grey.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

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
                      onPressed: () {
                        Navigator.pop(context); // 이전 화면으로 돌아가기
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FacilityListScreen()), // 홈 화면으로 이동
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

                // 강의실 목록 제목
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '강의실 목록',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'manru',
                      color: Color(0xFF121212).withOpacity(0.85),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // 층 이름 표시
                Opacity(
                  opacity: 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.floorName,
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

                // 강의실 목록
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2개의 열로 표시
                      crossAxisSpacing: 12.0, // 열 간 간격 설정
                      mainAxisSpacing: 12.0, // 행 간 간격 설정
                      childAspectRatio: 1.0, // 아이템의 가로세로 비율 1:1로 설정
                    ),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                        ),
                        color: selectedRoom == rooms[index]
                            ? Color(0xFF4B4F87) // 선택된 강의실 배경색
                            : Colors.white, // 선택되지 않은 강의실 배경색
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedRoom = rooms[index]; // 선택된 강의실 상태 업데이트
                            });
                            _showBottomSheet(
                                context, rooms[index]); // 하단 다이얼로그 표시
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0), // 카드 내부 여백 설정
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 강의실 이름 표시
                                Text(
                                  rooms[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'manru',
                                    fontWeight: FontWeight.bold,
                                    color: selectedRoom == rooms[index]
                                        ? Colors.white // 선택된 경우 흰색 텍스트
                                        : Color(0xFF121212).withOpacity(
                                        0.85), // 선택되지 않은 경우 기본 텍스트 색상
                                  ),
                                ),
                                Spacer(),
                                // 강의실 인원수 표시
                                Text(
                                  '${roomOccupants[rooms[index]]!.length}',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'manru',
                                    color: selectedRoom == rooms[index]
                                        ? Colors.white // 선택된 경우 흰색
                                        : Color(0xFF4B4F87), // 선택되지 않은 경우 기본 색상
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
