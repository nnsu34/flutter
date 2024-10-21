import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PersonnelList extends StatefulWidget {
  final String floorName;

  PersonnelList({required this.floorName});

  @override
  _PersonnelListState createState() => _PersonnelListState();
}

class _PersonnelListState extends State<PersonnelList> {
  List<dynamic> personnelList = []; // 인원 목록 저장
  List<Map<String, dynamic>> userLogs = []; // 사용자 로그 저장
  int? expandedUserId; // 확장된 사용자 ID 저장
  bool isLoading = true; // 로딩 상태 플래그
  bool isLogsLoading = false; // 로그 로딩 상태 플래그

  @override
  void initState() {
    super.initState();
    fetchPersonnelData(); // 위젯 초기화 시 인원 데이터를 가져옴
  }

  @override
  void didUpdateWidget(covariant PersonnelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.floorName != widget.floorName) {
      expandedUserId = null; // 층 변경 시 확장된 사용자 초기화
      fetchPersonnelData(); // 새로운 층의 인원 데이터를 가져옴
    }
  }

  // 인원 데이터를 API로부터 가져오는 함수
  Future<void> fetchPersonnelData() async {
    setState(() {
      isLoading = true; // 로딩 상태 시작
    });
    try {
      int floorNumber = _getFloorNumber(widget.floorName); // 층 이름에 따른 번호 가져옴
      final response = await http.get(
          Uri.parse('http://192.168.10.23:8000/zones/floor/$floorNumber/users'));
      if (response.statusCode == 200) {
        setState(() {
          personnelList = jsonDecode(utf8.decode(response.bodyBytes)); // JSON 데이터를 리스트로 변환
          isLoading = false; // 로딩 상태 종료
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("층 ${widget.floorName}의 데이터를 불러오는 데 실패했습니다.");
      }
    } catch (error) {
      print("사용자 데이터를 가져오는 중 오류 발생: $error");
      setState(() {
        isLoading = false; // 오류 발생 시 로딩 상태 종료
      });
    }
  }

  // 사용자 로그 데이터를 API로부터 가져오는 함수
  Future<void> fetchUserLogs(int userId) async {
    setState(() {
      isLogsLoading = true; // 로그 로딩 상태 시작
    });
    try {
      final logsResponse = await http.get(
          Uri.parse('http://192.168.10.23:8000/users/$userId/logs'));
      if (logsResponse.statusCode == 200) {
        setState(() {
          userLogs = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(logsResponse.bodyBytes)).map((log) => {
            'zone_id': log['zone_id'],
            'entry_time': log['entry_time'],
            'exit_time': log['exit_time'],
            'status': log['status'],
          }));
          isLogsLoading = false; // 로그 로딩 상태 종료
        });
      } else {
        setState(() {
          isLogsLoading = false;
        });
        print("사용자 $userId의 로그 데이터를 불러오는 데 실패했습니다.");
      }
    } catch (error) {
      print("사용자 로그 데이터를 가져오는 중 오류 발생: $error");
      setState(() {
        isLogsLoading = false; // 오류 발생 시 로그 로딩 상태 종료
      });
    }
  }

  // 층 이름에 따른 번호 반환
  int _getFloorNumber(String floorName) {
    switch (floorName) {
      case '1F':
        return 1;
      case '2F':
        return 2;
      default:
        return 0;
    }
  }

  // 날짜 문자열을 시간 형식으로 변환
  String formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}"; // "00:00" 형식으로 포맷팅
  }

  // zone ID에 따른 구역 라벨 반환
  String getZoneLabel(int zoneId) {
    switch (zoneId) {
      case 1:
        return '1F';
      case 2:
        return '2F';
      default:
        return 'Unknown Zone';
    }
  }

  // 전화 걸기 기능
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launch(launchUri.toString());
    }
  }

  // 메시지 보내기 기능
  Future<void> _sendMessage(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      final Uri messageUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
      );
      await launch(messageUri.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? Center(
            child: CircularProgressIndicator( // 로딩 스피너 표시
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.grey.withOpacity(0.3),
              ),
            ),
          )
              : ListView.builder( // 인원 리스트 빌더
            itemCount: personnelList.length,
            itemBuilder: (context, index) {
              final user = personnelList[index];
              final isExpanded = user['user_id'] == expandedUserId; // 확장된 사용자 여부

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedUserId = null; // 이미 열려있으면 닫기
                        } else {
                          expandedUserId = user['user_id']; // 새로운 사용자 열기
                          fetchUserLogs(user['user_id']); // 로그 데이터 가져오기
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container( // 사용자 아이콘
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 26.0,
                              color: Color(0xFF121212).withOpacity(0.75),
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: Column( // 사용자 이름 및 부서/역할 표시
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF121212)
                                        .withOpacity(0.85),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'manru', // 글씨체 지정
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 1.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        user['department'] ?? '미확인', // 부서 정보 표시
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[500],
                                          fontFamily: 'sans',
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        user['role'] ?? '', // 역할 정보 표시
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[500],
                                          fontFamily: 'sans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row( // 전화 및 메시지 아이콘
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _makePhoneCall(user['phone'] ?? ''); // 전화 걸기
                                },
                                child: Icon(
                                  Icons.call,
                                  color: Color(0xFF121212).withOpacity(0.75),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  _sendMessage(user['phone'] ?? ''); // 메시지 보내기
                                },
                                child: Icon(
                                  Icons.message,
                                  color: Color(0xFF121212).withOpacity(0.75),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded) _buildScrollableTimeline(), // 확장 시 타임라인 표시
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // 타임라인 위젯 생성
  Widget _buildScrollableTimeline() {
    // 가장 최근 로그의 월일과 시간
    String formattedDate = userLogs.isNotEmpty
        ? "${DateTime.parse(userLogs.last['entry_time']).month.toString().padLeft(2, '0')}.${DateTime.parse(userLogs.last['entry_time']).day.toString().padLeft(2, '0')}"
        : '알수없음';

    // 최근 로그 3개만 표시
    List<Map<String, dynamic>> recentLogs = List<Map<String, dynamic>>.from(userLogs)
        .where((log) => getZoneLabel(log['zone_id']) != 'Unknown Zone') // Unknown Zone 제외
        .toList()
        .reversed
        .take(3)
        .toList();

    return Container(
      height: 180, // 타임라인 높이
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 여백 추가
      child: Column(
        children: [
          Expanded(
            child: isLogsLoading
                ? Center(
              child: CircularProgressIndicator( // 로그 로딩 스피너
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.grey.withOpacity(0.3),
                ),
              ),
            )
                : recentLogs.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('기록이 없습니다', // 로그 없을 때 메시지
                  style: TextStyle(fontFamily: 'sans')),
            )
                : ListView.builder( // 로그 리스트 빌더
              padding: const EdgeInsets.only(left: 20.0, right: 14.0),
              itemCount: recentLogs.length,
              itemBuilder: (context, index) {
                final log = recentLogs[index];

                // 로그별 스타일 적용
                Color timeColor = (index == 0)
                    ? Color(0xFF121212).withOpacity(0.85)
                    : Colors.grey.withOpacity(0.6);
                Color dotColor = (index == 0)
                    ? Color(0xFF121212).withOpacity(0.85)
                    : Colors.grey.withOpacity(0.6);
                Color zoneColor = (index == 0)
                    ? Color(0xFF121212).withOpacity(0.85)
                    : Colors.grey.withOpacity(0.6);

                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70.0, // 시간 표시 영역
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (index == 0) // 첫 번째 로그에만 날짜 표시
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 2.0),
                                    child: Text(
                                      formattedDate, // 로그 날짜 표시
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'sans',
                                        color: Colors.grey
                                            .withOpacity(0.85),
                                      ),
                                    ),
                                  ),
                                Text(
                                  formatTime(log['entry_time'] ?? ''), // 시간 표시
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'sans',
                                    color: timeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          children: [
                            SizedBox(height: 20.0), // 간격 조절
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration( // 타임라인 동그라미
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: dotColor,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            if (index != recentLogs.length - 1)
                              DashedLine( // 점선 연결
                                color: Colors.grey.withOpacity(0.6),
                                height: 40,
                              ),
                          ],
                        ),
                        SizedBox(width: 30.0),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 18.0),
                            child: Text(
                              getZoneLabel(log['zone_id']), // 구역 라벨 표시
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans',
                                color: zoneColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 점선 라인 위젯
class DashedLine extends StatelessWidget {
  final Color color;
  final double height;
  final double dashHeight;
  final double dashWidth;

  const DashedLine({
    Key? key,
    this.color = Colors.grey,
    this.height = 45,
    this.dashHeight = 5.0,
    this.dashWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          (height / (2 * dashHeight)).floor(),
              (index) => Container(
            width: dashWidth,
            height: dashHeight,
            color: color,
            margin: EdgeInsets.only(bottom: dashHeight),
          ),
        ),
      ),
    );
  }
}