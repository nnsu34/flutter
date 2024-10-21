import 'package:flutter/material.dart';
import 'building_list_screen.dart';
import '../models/facility_model.dart';

class FacilityListScreen extends StatefulWidget {
  @override
  _FacilityListScreenState createState() => _FacilityListScreenState();
}

class _FacilityListScreenState extends State<FacilityListScreen> {
  final List<Facility> facilities = [
    Facility(name: '한국폴리텍대학 진주캠퍼스', buildings: ['본관', '교육1관', '교육2관', '기숙사']),
    Facility(name: '한국폴리텍대학 항공캠퍼스', buildings: []),
  ];

  String searchText = '';
  List<Facility> filteredFacilities = [];

  @override
  void initState() {
    super.initState();
    // 시설 목록을 이름순으로 정렬
    facilities.sort((a, b) => a.name.compareTo(b.name));
    filteredFacilities = facilities;
  }

  // 검색어에 따라 시설 목록 필터링
  void filterFacilities(String query) {
    setState(() {
      filteredFacilities = query.isEmpty
          ? facilities
          : facilities.where((facility) => facility.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  // 검색창 위젯 빌드
  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        onChanged: (value) {
          filterFacilities(value);  // 입력값에 따라 필터 적용
        },
        decoration: InputDecoration(
          hintText: '원하는 시설을 검색하세요',
          hintStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFF121212).withOpacity(0.5),
            fontFamily: 'manru',
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B4F87), width: 4.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B4F87), width: 4.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B4F87), width: 4.0),
          ),
          suffixIcon: Icon(Icons.search, size: 28, color: Color(0xFF4B4F87)),
        ),
        style: TextStyle(
          fontFamily: 'manru',
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Color(0xFF121212).withOpacity(0.7),
        ),
        cursorColor: Color(0xFF4B4F87),
      ),
    );
  }

  // 필터링된 시설 목록을 빌드
  Widget buildFacilityList() {
    return ListView.builder(
      itemCount: filteredFacilities.length,
      itemBuilder: (context, index) {
        return buildFacilityCard(filteredFacilities[index]);  // 시설 카드 빌드
      },
    );
  }

  // 개별 시설 카드 위젯 빌드
  Widget buildFacilityCard(Facility facility) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: GestureDetector(
        onTap: () {
          // 카드 클릭 시 건물 목록 화면으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuildingListScreen(facility: facility)),
          );
        },
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // 학교 아이콘
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F0F7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.school, size: 45, color: Color(0xFF4B4F87)),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 시설 이름
                      Text(
                        facility.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'manru',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF121212).withOpacity(0.85),
                        ),
                      ),
                      SizedBox(height: 4),
                      // 주소 정보
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 20, color: Color(0xFF121212).withOpacity(0.4)),
                          SizedBox(width: 8),
                          Text(
                            facility.name == '한국폴리텍대학 진주캠퍼스'
                                ? '경남 진주시 모덕로 299'
                                : '경남 사천시 대학길 46',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'manru',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF121212).withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                      // 전화번호 정보
                      Row(
                        children: [
                          Icon(Icons.phone, size: 20, color: Color(0xFF121212).withOpacity(0.4)),
                          SizedBox(width: 8),
                          Text(
                            facility.name == '한국폴리텍대학 진주캠퍼스'
                                ? '055-752-9901'
                                : '055-830-3400',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'manru',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF121212).withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                // 상단 네비게이션 아이콘
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                    IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FacilityListScreen()))),
                    IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {}),
                  ],
                ),
                SizedBox(height: 16),
                // 상단 "시설 목록" 텍스트
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '시설 목록',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'manru',
                      color: Color(0xFF121212).withOpacity(0.85),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                buildSearchBar(),
                SizedBox(height: 16),
                Expanded(child: buildFacilityList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
