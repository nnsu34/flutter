import 'package:flutter/material.dart';

// 사용자 정보 화면
class PersonDetailsScreen extends StatefulWidget {
  final String studentName;
  final String studentRole;
  final List<Map<String, String>> logs;

  PersonDetailsScreen({
    required this.studentName,
    required this.studentRole,
    required this.logs,
  });

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  // 로그 데이터를 최신 5개로 정렬
  List<Map<String, String>> getSortedLogs() {
    List<Map<String, String>> sortedLogs = widget.logs;
    sortedLogs.sort((a, b) {
      String dateTimeA = '${a['date']} ${a['time']}';
      String dateTimeB = '${b['date']} ${b['time']}';
      return dateTimeB.compareTo(dateTimeA);
    });

    String recentDate = sortedLogs.isNotEmpty ? sortedLogs.first['date']! : '';
    return sortedLogs
        .where((log) => log['date'] == recentDate)
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 16),
                _buildTitle('사용자 정보'),
                SizedBox(height: 16),
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
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF5F7FA), Color(0xFFE6E9F0)],
      ),
    );
  }

  // 상단 네비게이션 바
  Row _buildTopNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {}, // 추가 기능을 위한 버튼
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
          color: Color(0xFF121212).withOpacity(0.85),
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
            offset: Offset(0, 5),
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
          _buildRecentLogsHeader(recentFormattedDate),
          SizedBox(height: 8.0),
          Flexible( // 여기서 Flexible 사용
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
        color: Color(0xFFF1F0F7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(Icons.person, size: 40.0, color: Color(0xFF4B4F87)),
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
            widget.studentName,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'manru',
              color: Color(0xFF121212).withOpacity(0.85),
            ),
          ),
          SizedBox(height: 4.0),
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
                color: Color(0xFF121212).withOpacity(0.85),
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              widget.studentRole == '게스트' ? '미확인' : 'AI소프트웨어과', // 게스트는 미확인
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'manru',
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildIcon(Icons.phone),
            SizedBox(width: 12.0),
            _buildIcon(Icons.email),
          ],
        ),
      ],
    );
  }

  // 연락처 및 이메일 아이콘 빌드 함수
  Widget _buildIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F0F7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Color(0xFF4B4F87),
        onPressed: () {},
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
          SizedBox(height: 16.0),
          Row(
            children: [
              Text(
                '최근 기록',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'manru',
                  color: Color(0xFF121212).withOpacity(0.85), // 텍스트 색상
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F0F7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    recentFormattedDate,
                    style: TextStyle(
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
          SizedBox(height: 2.0),
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
            // 시간 표시
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
                        ? Color(0xFF4B4F87).withOpacity(0.8)
                        : Color(0xFFFFD38C).withOpacity(0.9))
                        : Colors.grey.withOpacity(0.6), // 회색 설정
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
                          ? Color(0xFF4B4F87).withOpacity(0.9)
                          : Colors.grey.withOpacity(0.6), // 회색 동그라미
                      width: 4.0,
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                if (index != recentLogs.length - 1)
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
                      log['location']!,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'manru',
                        color: Color(0xFF121212).withOpacity(0.85),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      log['action'] == '입장' ? '입실' : '퇴실',
                      style: TextStyle(
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
