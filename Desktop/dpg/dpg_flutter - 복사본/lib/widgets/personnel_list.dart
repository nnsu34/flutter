import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../screens/person_details_screen.dart';

class PersonnelList extends StatefulWidget {
  final String floorName;
  final int building;

  PersonnelList({required this.floorName, required this.building});

  @override
  _PersonnelListState createState() => _PersonnelListState();
}

class _PersonnelListState extends State<PersonnelList> {
  List<Map<String, dynamic>> personnelList = [];

  @override
  void initState() {
    super.initState();
    fetchPersonnelData(); // 초기 데이터를 가져옴
  }

  @override
  void didUpdateWidget(PersonnelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.floorName != oldWidget.floorName) {
      fetchPersonnelData(); // 층이 변경되면 데이터를 다시 가져옴
    }
  }

  Future<void> fetchPersonnelData() async {
    int floorNumber = int.parse(widget.floorName.replaceAll('F', ''));
    final users = await fetchUsers(floorNumber);
    setState(() {
      personnelList = users;
    });
  }

  Future<List<Map<String, dynamic>>> fetchUsers(int floorNumber) async {
    final url = 'http://192.168.10.23:8000/zones/floor/$floorNumber/users';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // 전화 연결 함수
  void _makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20.0), // 바깥쪽 여백
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 20.0, bottom: 8.0),
            child: Text(
              "LIST",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'sans',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: personnelList.length,
              itemBuilder: (context, index) {
                final user = personnelList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetailsScreen(
                          userId: user['user_id'], // 사용자 ID를 전달
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0), // 내부 여백
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7), // 배경색 #F7F7F7
                            borderRadius: BorderRadius.circular(10), // 테두리 둥글게 (10)
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.black, // 아이콘을 검정색으로 설정
                            size: 26,
                          ),
                        ),
                        SizedBox(width: 24), // 좌우 여백 확대
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'manru',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: Text(
                                  user['role'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                    fontFamily: 'sans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall(user['phone'] ?? ''); // 전화번호로 연결
                          },
                          child: Transform.translate(
                            offset: Offset(3, -5), // X축은 3, Y축은 -5로 위로 약간 이동
                            child: Icon(
                              Icons.call,
                              color: Colors.black,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20), // 하단 여백 추가
        ],
      ),
    );
  }
}
