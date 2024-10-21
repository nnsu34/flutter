import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://anyonethere.kro.kr:8080';

  // 사용자 기록을 가져오는 함수
  static Future<List<dynamic>> fetchUserLogs(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/logs'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load user logs');
    }
  }

  // 사용자 정보를 가져오는 함수
  static Future<Map<String, dynamic>> fetchUserData(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // 건물 층별 인원 데이터를 가져오는 함수 (필요 시)
  static Future<Map<String, dynamic>> fetchOccupancyData(int floor) async {
    final response = await http.get(Uri.parse('$baseUrl/zones/floor/$floor'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load occupancy data');
    }
  }

  // 특정 층의 사용자 데이터를 가져오는 함수 (필요 시)
  static Future<List<dynamic>> fetchOccupantsData(int floor) async {
    final response =
    await http.get(Uri.parse('$baseUrl/zones/floor/$floor/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load occupants data');
    }
  }
}
