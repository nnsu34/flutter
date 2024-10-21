import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // 전화 걸기 기능을 위한 url_launcher 패키지 임포트
import '../screens/person_details_screen.dart'; // PersonDetailsScreen 임포트


class PersonnelList extends StatefulWidget {
  final String floorName;

  PersonnelList({required this.floorName});

  @override
  _PersonnelListState createState() => _PersonnelListState();
}

class _PersonnelListState extends State<PersonnelList> {
  List<dynamic> personnelList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersonnelData(); // 첫 로드 시 데이터 가져오기
  }

  @override
  void didUpdateWidget(covariant PersonnelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.floorName != widget.floorName) {
      fetchPersonnelData(); // floorName이 변경되면 데이터를 다시 로드
    }
  }

  Future<void> fetchPersonnelData() async {
    setState(() {
      isLoading = true;
    });
    try {
      int floorNumber = _getFloorNumber(widget.floorName); // 층 이름을 숫자로 변환
      final response = await http.get(
          Uri.parse('http://anyonethere.kro.kr:8080/zones/floor/$floorNumber/users'));
      if (response.statusCode == 200) {
        setState(() {
          personnelList = jsonDecode(utf8.decode(response.bodyBytes));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to load data for floor ${widget.floorName}");
      }
    } catch (error) {
      print("Error fetching personnel data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

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

  // 전화 걸기 함수
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launch(launchUri.toString()); // launch 사용
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.grey.withOpacity(0.3), // 회색에 0.3 투명도 적용
          ),
        ),
      );
    }

    if (personnelList.isEmpty) {
      return Center(child: Text('인원을 찾을 수 없습니다'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0), // 좌우 여백을 줄임
      child: Column( // Column으로 감싸서 Flex 구조로 수정
        children: [
          Expanded( // Expanded는 Flex 부모 내에서 사용
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
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // 좌우 여백 설정
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경색 흰색
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // 그림자 색상 변경
                          blurRadius: 10, // 그림자의 퍼짐 정도
                          offset: Offset(0, 5), // 그림자의 위치
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20), // 모서리를 둥글게 처리
                    ),
                    padding: const EdgeInsets.all(20.0), // 카드 내부 여백 설정
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7), // 아이콘 배경색
                            borderRadius: BorderRadius.circular(15), // 아이콘 모서리를 둥글게 처리
                          ),
                          child: Icon(
                            Icons.person,
                            size: 26.0, // 아이콘 크기
                            color: Color(0xFF121212).withOpacity(0.85), // 아이콘 색상 변경
                          ),
                        ),
                        SizedBox(width: 24), // 좌우 여백
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xFF121212).withOpacity(0.85), // 이름 색상 변경
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'manru',
                                ),
                              ),
                              SizedBox(height: 2.0), // 이름과 소속 사이 여백 추가
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: Row(
                                  children: [
                                    Text(
                                      user['department'] ?? '미확인', // 소속 정보
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[500],
                                        fontFamily: 'sans',
                                      ),
                                    ),
                                    SizedBox(width: 4), // 소속과 역할 사이 여백
                                    Text(
                                      user['role'] ?? '', // 역할 정보
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
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall(user['phone'] ?? ''); // 전화 걸기
                          },
                          child: Row( // 전화 아이콘에 우측 여백 추가
                            children: [
                              Icon(
                                Icons.call,
                                color: Color(0xFF121212).withOpacity(0.85), // 아이콘 색상 변경
                                size: 26,
                              ),
                              SizedBox(width: 8), // 전화 아이콘과 끝 부분 사이에 여백 추가
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
