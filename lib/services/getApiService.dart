import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_version_of_recycle_app/Constants/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      Globals.baseUrl;
  // register user
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String address,
    required String email,
    required String password,
    required String phone,
    required String role
  }) async {
    final url = Uri.parse('$baseUrl/api/UserControler/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "name": name,
        "address": address,
        "userRole": role,
        "email": email,
        "password": password,
        "phoneNumber": phone
      }),
    );
    return jsonDecode(response.body);
  }

  //Login
  Future<http.Response> login({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/UserControler/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phoneNumber': phone,
        'password': password,
      }),
    );

    return response;
  }
  // fetch user data
  Future<Map<String, dynamic>> fetchUserData(String token) async {
    final url = Uri.parse('$baseUrl/UserControler?id={{id}}');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return {'success': true, 'data': responseBody['data']}; // إرجاع البيانات عند النجاح
    } else {
      return {'success': false, 'message': 'Failed to fetch user data'}; // إرجاع رسالة خطأ عند الفشل
    }
  }

  //Is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return false; // No token saved

    // Optional: Validate token with API
    final response = await http.get(
      Uri.parse('$baseUrl/UserControler'),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }

  //Logout
  Future<Map<String, dynamic>> logout(String token) async {
    final url = Uri.parse('$baseUrl/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  // عرض قائمة من الـ Waste Types
  Future<List<dynamic>> getWasteTypes() async {
    final url = Uri.parse('$baseUrl/WasteType');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      // استخراج أسماء النفايات فقط
      return data.map((item) => item['wasteName'] as String).toList();
    } else {
      throw Exception('Failed to fetch waste types');
    }
  }

  // عرض آخر نشاط للمستخدم
  Future<List<dynamic>> getUserLastActivity(String token) async {
    final url = Uri.parse('$baseUrl/user/last-activity');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch last activity');
    }
  }

  // عرض قائمة المستخدمين (Admin)
  Future<List<dynamic>> getUsers(String token) async {
    final url = Uri.parse('$baseUrl/admin/users');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  // إضافة نوع جديد من الـ Waste وتحديد السعر (Admin)
  Future<Map<String, dynamic>> addWasteType({
    required String token,
    required String wasteTypeName,
    required String wasteDescription,
    required double price,

  }) async {
    final url = Uri.parse('$baseUrl/WasteType');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'wasteName': wasteTypeName,
        'description':wasteDescription,
        'price': price,
      }),
    );

    return _handleResponse(response);
  }

  // إحصائيات للكميات التي تم بيعها
  Future<Map<String, dynamic>> getStatistics(String token) async {
    final url = Uri.parse('$baseUrl/admin/statistics');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  //addWasteRequest
  Future<http.Response> addWasteRequest({
    required String userPhone,
    required String quantity,
    required String location,
    required String wasteName,
    required String totalPrice,
    required String requestDate
  }) async {
    final url = Uri.parse('$baseUrl/api/RecyclingRequest');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userPhone': userPhone,
        'quantity': quantity,
        'location': location, // Default role
        'wasteName': wasteName,
        'totalPrice': totalPrice,
        'requestDate': DateTime.now().toIso8601String(),
      }),
    );
    return response;
  }





  // Save login token
  Future<void> saveLogin(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token); // Store the token
  }

  // handle responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseBody = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': responseBody};
    } else {
      return {
        'success': false,
        'message': responseBody['message'] ?? 'An error occurred',
      };
    }
  }
}
