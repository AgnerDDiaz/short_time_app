import 'dart:convert';
import 'package:http/http.dart' as http;

class StApiService {
  static const String baseUrl = 'http://localhost:8000/api'; // Cambia esto

  static Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }
}
