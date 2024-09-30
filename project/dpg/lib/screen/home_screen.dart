import 'package:dpg/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard_card.dart';  // DashboardCard 위젯 임포트
import 'zone_details_screen.dart';  // ZoneDetailsScreen 임포트
import 'alert_history_screen.dart';  // AlertHistoryScreen 임포트
import 'login_page.dart';  // LoginPage 임포트

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),  // #F7F7F7
      appBar: AppBar(
        title: Text(
          'Fire Safety Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.black,
            onPressed: () {
              // 로그아웃: LoginPage로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Safety Monitoring', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  DashboardCard(zone: 'Zone 1', occupancy: 5),
                  DashboardCard(zone: 'Zone 2', occupancy: 3),
                  DashboardCard(zone: 'Zone 3', occupancy: 8),
                  DashboardCard(zone: 'Zone 4', occupancy: 6),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),  // 좌우 여백을 넓힘
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                color: Colors.grey,
                onPressed: () {
                  // 알림 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlertHistoryScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.home),
                color: Color(0xFFE43022),  // #E43022
                onPressed: () {
                  // 홈 화면으로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                color: Colors.grey,
                onPressed: () {
                  // 설정 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
