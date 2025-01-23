import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:short_time_app/models/auth_models.dart';

class LoginResponse {
  final bool success;
  final String? accessToken;
  final String? error;

  LoginResponse({
    required this.success,
    this.accessToken,
    this.error,
  });
}
class StApiService {
  static const String baseUrl = 'http://producti-myserviceloadba-519714058.us-east-1.elb.amazonaws.com';

  static Future<bool> registerUser(RegisterDto user) async {
    try {
      final String fullURL = '$baseUrl/auth/register';

      final Map<String, dynamic> requestBody = user.toJson();

      print('enviando datos: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(fullURL),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Status Code: ${response.statusCode}');
      print('Respones Body ${response.body}');

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

  static Future<LoginResponse> loginUser(String email, String password) async {
    try {
      final String fullUrl = '$baseUrl/auth/login';
      print('Intentando login con URL: $fullUrl');

      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      print('Enviando datos de login: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Formated response data

        final accessToken = responseData['access_token'];
        if (accessToken != null) {
          // Si tenemos un token válido, retornamos éxito
          return LoginResponse(
            success: true,
            accessToken: accessToken,
          );
        }
      }

      // Si no obtuvimos un código 200 o no hay token, retornamos error
      return LoginResponse(
        success: false,
        error: 'Credenciales inválidas',
      );
    } catch (e) {
      print('Error durante el login: $e');
      return LoginResponse(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Método para verificar si el token es válido
  static Future<bool> verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error verificando token: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> createService({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    required int serviceDuration,
    required int clientId
  }) async {
    try {
      final String fullURL = '$baseUrl/service';

      final Map<String, dynamic> requestBody = {
        'client_id': clientId,
        'name': name,
        'description': description,
        'price': price,
        'category_id': categoryId,
        'rating': 0,
        'service_duration': serviceDuration
      };
      print('Enviando datos de servicio: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(fullURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Error al crear servicio');
      }
    } catch (e) {
      print('Error durante createService: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<bool> createAvailability({
    required int serviceId,
    required String day,
    required String openingTime,
    required String closingTime,

  }) async {
    try {
      final String fullURL = '$baseUrl/availability';
      final Map<String, dynamic> requestBody = {
        'service_id': serviceId,
        'day': day,
        'opening_time': openingTime,
        'closing_time': closingTime,
      };
      print('Enviando datos de disponibilidad: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(fullURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('Error durante createAvailability: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getClientInfo(int clientId) async {
    try {
      final String fullURL = '$baseUrl/clients/$clientId';

      final response = await http.get(
        Uri.parse(fullURL),
        headers: {
          'Accept': 'application/json',
        },
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener información del cliente');
      }
    } catch (e) {
      print('Error obteniendo info del cliente: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getClientServices(
      int clientId) async {
    try {
      final String fullURL = '$baseUrl/services/client/$clientId';

      final response = await http.get(
        Uri.parse(fullURL),
        headers: {
          'Accept': 'application/json',
        },
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> services = jsonDecode(response.body);
        return services.map((service) => Map<String, dynamic>.from(service))
            .toList();
      } else {
        throw Exception('Error al obtener servicios del cliente');
      }
    } catch (e) {
      print('Error obteniendo servicios: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}