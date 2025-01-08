import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthManager with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userType;
  String? _accessToken;
  String? _refreshToken;

  bool get isAuthenticated => _isAuthenticated;
  String? get userType => _userType;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/login/");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"username": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access'];
        _refreshToken = data['refresh'];
        _userType = data['userType'];
        _isAuthenticated = true;

        notifyListeners(); // Notifica a la aplicación del cambio de estado
        return true;
      } else if (response.statusCode == 401) {
        // Credenciales incorrectas
        throw Exception('Invalid credentials. Please check your email and password.');
      } else {
        // Otro tipo de error
        throw Exception('An error occurred. Please try again later.');
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _userType = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
}
