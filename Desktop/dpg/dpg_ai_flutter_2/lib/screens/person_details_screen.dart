import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import'../services/api_service.dart'; // API 호출을 위해 ApiService를 import

class PersonDetailsScreen extends StatefulWidget {
  final String studentName;
  final String studentRole;
  final String phoneNumber;
  final int userId; // 추가된 사용자 ID 필드

  const PersonDetailsScreen({
    super.key,
    required this.studentName,
    required this.studentRole,
    required this.phoneNumber,
    required this.userId, // userId 매개변수 추가
  });

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  List<Map<String, String>> logs = [];

  @override
  void initState() {
    super.initState();
    _fetchUserLogs();
  }

  Future<void> _fetchUserLogs() async {
    try {
      final fetchedLogs = await ApiService.fetchUserLogs(widget.userId);

      // dynamic 데이터를 String으로 변환하는 로직 추가
      setState(() {
        logs = fetchedLogs.map((log) => {
          'date': log['entry_time'] != null
              ? log['entry_time'].split('T')[0].toString()
              : '',
          'time': log['entry_time'] != null
              ? log['entry_time'].split('T')[1].substring(0, 5).toString()
              : '',
          'location': 'Zone ${log['zone_id'].toString()}',
          'action': log['exit_time'] == null ? '입장' : '퇴장',
        }).toList().cast<Map<String, String>>(); // String 타입으로 캐스팅
      });
    } catch (e) {
      print('Error fetching logs: $e');
    }
  }

  // getSortedLogs 메서드 추가
  List<Map<String, String>> getSortedLogs() {
    // logs를 복사하여 수정 가능한 리스트로 변환
    List<Map<String, String>> sortedLogs = List<Map<String, String>>.from(logs);

    sortedLogs.sort((a, b) {
      String dateTimeA = '${a['date']} ${a['time']}';
      String dateTimeB = '${b['date']} ${b['time']}';
      return dateTimeB.compareTo(dateTimeA);
    });

    // 최근 날짜의 로그만 필터링 (예: 가장 최근 날짜만 필터링)
    String recentDate = sortedLogs.isNotEmpty ? sortedLogs.first['date']! : '';
    return sortedLogs
        .where((log) => log['date'] == recentDate)
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // 정렬된 최근 로그를 가져옴
    List<Map<String, String>> recentLogs = getSortedLogs();
    String recentFormattedDate = recentLogs.isNotEmpty
        ? '${recentLogs.first['date']!.substring(5, 7)}.${recentLogs.first['date']!.substring(8, 10)}'
        : '';

    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopNavigation(context),
                const SizedBox(height: 16),
                _buildTitle('사용자 정보'),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildProfileCardWithTimeline(recentLogs, recentFormattedDate),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // 배경 그라디언트 설정
  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF5F7FA), Color(0xFFE6E9F0)],
      ),
    );
  }

  // 상단 네비게이션 바 (뒤로가기 버튼만)
  Row _buildTopNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // 페이지 제목
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          fontFamily: 'manru',
          color: const Color(0xFF121212).withOpacity(0.85),
        ),
      ),
    );
  }

  // 프로필 카드 + 타임라인
  Widget _buildProfileCardWithTimeline(
      List<Map<String, String>> recentLogs, String recentFormattedDate) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildProfilePicture(),
              const SizedBox(width: 24.0),
              _buildProfileText(),
            ],
          ),
          const SizedBox(height: 16.0),
          Divider(color: Colors.grey.shade300, thickness: 1.0),
          const SizedBox(height: 16.0),
          _buildContactInfo(),
          const SizedBox(height: 16.0),
          Divider(color: Colors.grey.shade300, thickness: 1.0), // 프로필과 로그 구분
          _buildRecentLogsHeader(recentFormattedDate),
          const SizedBox(height: 8.0),
          Flexible(
            child: _buildScrollableTimeline(recentLogs),
          ),
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
        color: const Color(0xFFF1F0F7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Icon(Icons.person, size: 40.0, color: Color(0xFF4B4F87)),
    );
  }

  // 프로필 텍스트 (이름 및 역할)
  Widget _buildProfileText() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Text(
            widget.studentName,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'manru',
              color: const Color(0xFF121212).withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              widget.studentRole,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'manru',
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
                fontFamily: 'manru',
                color: const Color(0xFF121212).withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              widget.studentRole == '게스트' ? '미확인' : 'AI소프트웨어과', // 게스트는 미확인
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'manru',
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildIcon(Icons.phone, widget.phoneNumber), // 전화번호 매개변수 전달
            const SizedBox(width: 12.0),
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
          color: const Color(0xFFF1F0F7),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: const Color(0xFF4B4F87),
          onPressed: () {}, // GestureDetector에 의해 처리됨
        ),
      ),
    );
  }

  // 최근 기록 헤더
  Widget _buildRecentLogsHeader(String recentFormattedDate) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 2.0), // 좌측 여백을 줄임
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Row(
            children: [
              Text(
                '최근 기록',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'manru',
                  color: const Color(0xFF121212).withOpacity(0.85), // 텍스트 색상
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F0F7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    recentFormattedDate,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'manru',
                      color: Color(0xFF4B4F87),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
        ],
      ),
    );
  }

  // 스크롤 가능한 타임라인
  Widget _buildScrollableTimeline(List<Map<String, String>> recentLogs) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 10.0, right: 14.0),
      itemCount: recentLogs.length,
      itemBuilder: (context, index) {
        final log = recentLogs[index];
        final isEntry = log['action'] == '입장';
        final isMostRecent = index == 0; // 가장 최근 로그

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  log['time']!,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'manru',
                    color: isMostRecent
                        ? (isEntry
                        ? const Color(0xFF4B4F87).withOpacity(0.8)
                        : const Color(0xFFFFD38C).withOpacity(0.9))
                        : Colors.grey.withOpacity(0.6),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Column(
              children: [
                const SizedBox(height: 20.0),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isMostRecent
                          ? const Color(0xFF4B4F87).withOpacity(0.9)
                          : Colors.grey.withOpacity(0.6),
                      width: 4.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                if (index != recentLogs.length - 1)
                  DashedLine(
                    color: Colors.grey.withOpacity(0.6),
                    height: 45,
                  ),
              ],
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log['location']!,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'manru',
                        color: const Color(0xFF121212).withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      log['action'] == '입장' ? '입실' : '퇴실',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'manru',
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
    );
  }

  // 활동 로그가 없을 때 표시되는 메시지
  Widget _buildNoLogsMessage() {
    return Center(
      child: Text(
        '활동 기록이 없습니다.',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: 'manru',
          color: Colors.grey.withOpacity(0.6),
        ),
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
    super.key,
    this.color = Colors.grey,
    this.height = 45,
    this.dashHeight = 5.0,
    this.dashWidth = 2.0,
  });

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
