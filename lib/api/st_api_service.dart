import 'dart:convert';
import 'package:http/http.dart' as http;

class StApiService {
  static const String baseUrl = 'http://producti-myserviceloadba-519714058.us-east-1.elb.amazonaws.com/api';

  static Future<bool> registerUser(
      String role,
      String name,
      String email,
      String password,
      String profilePicture,
      String city,
      String businessAddress,
      String phoneNumber
      ) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'role': role,
          'name': name,
          'email': email,
          'password': password,
          'profile_picture': profilePicture,
          'city': city,
          'business_address': businessAddress,
          'phone_numbre': phoneNumber

        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en el registro: $e');
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
