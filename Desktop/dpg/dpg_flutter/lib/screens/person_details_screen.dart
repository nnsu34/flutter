import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PersonDetailsScreen extends StatefulWidget {
  final int userId;

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
    fetchUserData();
    fetchUserLogs();
  }

  Future<void> fetchUserData() async {
    try {
      final userResponse = await http.get(Uri.parse('http://anyonethere.kro.kr:8080/users/${widget.userId}'));

      if (userResponse.statusCode == 200) {
        setState(() {
          userData = jsonDecode(utf8.decode(userResponse.bodyBytes));
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserLogs() async {
    try {
      final logsResponse = await http.get(Uri.parse('http://anyonethere.kro.kr:8080/users/${widget.userId}/logs'));

      if (logsResponse.statusCode == 200) {
        setState(() {
          logs = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(logsResponse.bodyBytes)).map((log) => {
            'zone_id': log['zone_id'],
            'entry_time': log['entry_time'],
            'exit_time': log['exit_time'],
            'status': log['status'],
          }));
        });
      } else {
        throw Exception('Failed to load user logs');
      }
    } catch (e) {
      print('Error fetching logs: $e');
    }
  }

  String formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.grey.withOpacity(0.3), // 회색에 투명도 적용
          ),
        ),
      )
          : userData != null
          ? _buildContent()
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
            Color(0xFFF5F5F5),
            Color(0xFFE8E8E8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopNavigation(context),
              SizedBox(height: 16),
              Expanded(
                child: _buildProfileCardWithTimeline(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTopNavigation(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF121212).withOpacity(0.85)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildProfileCardWithTimeline() {
    return Container(
      margin: const EdgeInsets.all(12.0),
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
          SizedBox(height: 14.0),
          Divider(color: Colors.grey.shade300, thickness: 1.0),
          SizedBox(height: 14.0),
          _buildContactInfo(),
          SizedBox(height: 14.0),
          Divider(color: Colors.grey.shade300, thickness: 1.0),
          SizedBox(height: 14.0),
          _buildRecentLogsHeaderWithDate(),
          SizedBox(height: 6.0),
          _buildScrollableTimeline(),
        ],
      ),
    );
  }

  Widget _buildRecentLogsHeaderWithDate() {
    String formattedDate = userData != null && userData!['created_at'] != null
        ? "${DateTime.parse(userData!['created_at']).month.toString().padLeft(2, '0')}.${DateTime.parse(userData!['created_at']).day.toString().padLeft(2, '0')}"
        : 'Unknown';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '최근 기록',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'sans',
            color: Color(0xFF121212).withOpacity(0.85),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            formattedDate, // API에서 받은 월.일 데이터를 표시
            style: TextStyle(
              fontSize: 15.0, // 이 부분은 크기를 유지
              fontWeight: FontWeight.bold,
              fontFamily: 'sans',
              color: Color(0xFF121212).withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 70.0,
      height: 70.0,
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7).withOpacity(0.85),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(Icons.person, size: 35.0, color: Color(0xFF121212).withOpacity(0.85)),
    );
  }

  Widget _buildProfileText() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Text(
            userData!['name'] ?? 'Unknown',
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'sans',
              color: Color(0xFF121212).withOpacity(0.85),
            ),
          ),
          SizedBox(height: 0.0),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              userData!['role'] ?? 'Unknown Role',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'sans',
                color: Colors.grey.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                fontSize: 16.0,
                fontFamily: 'sans',
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildPhoneIcon(Icons.phone, userData!['phone']), // 전화만 연결
            SizedBox(width: 8.0),
            _buildMessageIcon(Icons.message), // 메시지 아이콘은 표시만
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneIcon(IconData icon, [String? phone]) {
    return GestureDetector(
      onTap: () {
        if (phone != null && phone.isNotEmpty) {
          _makePhoneCall(phone); // 전화 앱으로 연결
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Color(0xFF121212).withOpacity(0.85),
          iconSize: 24,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildMessageIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Color(0xFF121212).withOpacity(0.85),
        iconSize: 24,
        onPressed: () {}, // 메시지 기능 없음
      ),
    );
  }

  Future<void> _makePhoneCall(String phone) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phone);
    if (await launchUrl(launchUri)) {
      print('Launching phone: $phone');
    } else {
      print('Could not launch phone: $phone');
    }
  }

  Widget _buildScrollableTimeline() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 10.0, right: 14.0),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[logs.length - index - 1]; // 로그를 역순으로 표시
          final isMostRecent = index == 0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    formatTime(log['entry_time'] ?? ''),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sans',
                      color: isMostRecent
                          ? Color(0xFF121212).withOpacity(0.85)
                          : Colors.grey.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Column(
                children: [
                  SizedBox(height: 20.0),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isMostRecent
                            ? Color(0xFF121212).withOpacity(0.85)
                            : Colors.grey.withOpacity(0.6),
                        width: 3.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  if (index != logs.length - 1)
                    DashedLine(
                      color: Colors.grey.withOpacity(0.6),
                      height: 45,
                    ),
                ],
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    getZoneLabel(log['zone_id']),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sans',
                      color: Color(0xFF121212).withOpacity(0.85),
                    ),
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