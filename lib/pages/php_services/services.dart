import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }
}