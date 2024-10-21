import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지 임포트
import 'dart:convert'; // jsonDecode 및 utf8 사용을 위한 임포트
import 'package:url_launcher/url_launcher.dart'; // 전화 기능을 위한 패키지

class PersonDetailsScreen extends StatefulWidget {
  final int userId; // userId를 전달받음

  PersonDetailsScreen({required this.userId});

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // 사용자 정보 및 로그를 가져옴
  }

  Future<void> fetchUserData() async {
    try {
      // 사용자 정보 API 호출
      final userResponse = await http.get(Uri.parse('http://192.168.10.23:8000/users/${widget.userId}'));

      if (userResponse.statusCode == 200) {
        setState(() {
          userData = jsonDecode(utf8.decode(userResponse.bodyBytes));
        });
      } else {
        throw Exception('Failed to load user data');
      }

      // 사용자 로그 API 호출
      final logsResponse = await http.get(Uri.parse('http://192.168.10.23:8000/users/${widget.userId}/logs'));

      if (logsResponse.statusCode == 200) {
        setState(() {
          logs = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(logsResponse.bodyBytes)));
        });
      } else {
        throw Exception('Failed to load user logs');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 로딩 애니메이션 표시
          : userData != null
          ? _buildContent() // 데이터 로드 후 화면 구성
          : Center(child: Text('데이터를 불러올 수 없습니다.')),
    );
  }

  Widget _buildContent() {
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopNavigation(context), // 뒤로가기 버튼
              SizedBox(height: 16),
              Expanded(
                child: _buildProfileCardWithTimeline(), // 프로필 카드와 타임라인
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 상단 네비게이션 바 (뒤로가기 버튼)
  Row _buildTopNavigation(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // 프로필 카드 + 타임라인
  Widget _buildProfileCardWithTimeline() {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(20), // 테두리 둥글게 설정 (10)
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildProfilePicture(),
              SizedBox(width: 24.0),
              _buildProfileText(),
            ],
          ),
          SizedBox(height: 16.0),
          Divider(color: Colors.grey.shade300, thickness: 1.0),
          SizedBox(height: 16.0),
          _buildContactInfo(),
          SizedBox(height: 16.0),
          Divider(color: Colors.grey.shade300, thickness: 1.0), // 프로필과 로그 구분
          SizedBox(height: 16.0), // '최근 기록' 텍스트 위에 여백 추가
          _buildRecentLogsHeader(),
          SizedBox(height: 8.0),
          _buildScrollableTimeline(), // 최근 기록 타임라인 추가
        ],
      ),
    );
  }

  // 프로필 사진
  Widget _buildProfilePicture() {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7), // 배경 색상 #F7F7F7
        borderRadius: BorderRadius.circular(10), // 테두리 둥글게 (10)
      ),
      child: Icon(Icons.person, size: 40.0, color: Colors.black), // 아이콘 검정색
    );
  }

  // 프로필 텍스트 (이름 및 역할)
  Widget _buildProfileText() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Text(
            userData!['name'] ?? 'Unknown',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'sans',
              color: Color(0xFF121212).withOpacity(0.85),
            ),
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              userData!['role'] ?? 'Unknown Role',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'sans',
                color: Colors.grey.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 연락처 및 이메일 아이콘
  Widget _buildContactInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '소속',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'sans',
                color: Color(0xFF121212).withOpacity(0.85),
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              userData!['role'] == '게스트' ? '미확인' : userData!['department'] ?? 'AI소프트웨어과',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'sans',
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildIcon(Icons.phone, userData!['phone']),
            SizedBox(width: 12.0),
            _buildIcon(Icons.email), // 이메일 아이콘은 필요 시 추가
          ],
        ),
      ],
    );
  }

  // 연락처 및 이메일 아이콘 빌드 함수
  Widget _buildIcon(IconData icon, [String? phoneNumber]) {
    return GestureDetector(
      onTap: () {
        if (icon == Icons.phone && phoneNumber != null) {
          launchUrl(Uri(scheme: 'tel', path: phoneNumber)); // 전화 걸기
        } else if (icon == Icons.email) {
          // 이메일 기능 추가 (필요 시)
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7), // 배경색 #F7F7F7
          borderRadius: BorderRadius.circular(10), // 테두리 둥글게 (10)
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Colors.black, // 아이콘 검정색
          onPressed: () {}, // GestureDetector에 의해 처리됨
        ),
      ),
    );
  }

  // 최근 기록 헤더
  Widget _buildRecentLogsHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 2.0),
      child: Text(
        '최근 기록',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'sans',
          color: Color(0xFF121212).withOpacity(0.85),
        ),
      ),
    );
  }

  // 스크롤 가능한 타임라인
  Widget _buildScrollableTimeline() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 10.0, right: 14.0),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          final isEntry = log['status'] == 'IN';
          final isMostRecent = index == 0; // 가장 최근 로그

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 시간 표시
              SizedBox(
                width: 80.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    log['entry_time'] != null ? log['entry_time'].substring(11, 16) : '',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sans',
                      color: isMostRecent
                          ? (isEntry
                          ? Colors.black.withOpacity(0.8)
                          : Color(0xFFFFD38C).withOpacity(0.9))
                          : Colors.grey.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              // 동그라미 및 선
              Column(
                children: [
                  SizedBox(height: 20.0),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isMostRecent
                            ? Colors.black.withOpacity(0.9)
                            : Colors.grey.withOpacity(0.6),
                        width: 4.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  if (index != logs.length - 1)
                    DashedLine(
                      color: Colors.grey.withOpacity(0.6), // 회색 점선
                      height: 45,
                    ),
                ],
              ),
              SizedBox(width: 20.0),
              // 로그 내용 표시
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log['zone_id'] != null ? 'Zone ${log['zone_id']}' : 'Unknown Zone',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sans',
                          color: Color(0xFF121212).withOpacity(0.85),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        isEntry ? '입실' : '퇴실',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'sans',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// DashedLine 커스텀 위젯
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
