import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceApi {

  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://prod2-myserviceloadbalan-71978353.us-east-1.elb.amazonaws.com';

  // Singleton instance
  static final ServiceApi _instance = ServiceApi._internal();

  factory ServiceApi() => _instance;

  ServiceApi._internal();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'access_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
  }

  Future<Map<String, dynamic>> createService(Map<String, dynamic> serviceData) async {
    try {
      final response = await _dio.post(
          '$baseUrl/services',
          data: serviceData,
          options: Options(headers: await _getHeaders())
      );
      return response.data;
    } catch (e) {
      throw ApiException(500, 'Error creating service: $e');
    }
  }
  Future<List<Map<String, dynamic>>> getClientServices(int clientId) async {
    try {
      final response = await _dio.get(
          '$baseUrl/services/all',
          queryParameters: {'client_id': clientId},
          options: Options(headers: await _getHeaders())
      );
      return List<Map<String, dynamic>>.from(response.data['results']);
    } catch (e) {
      throw ApiException(500, 'Error fetching services: $e');
    }
  }


  Future<Map<String, dynamic>> getServiceById(int id) async {
    try {
      final response = await _dio.get(
          '$baseUrl/services/$id',
          options: Options(headers: await _getHeaders())
      );
      return response.data;
    } catch (e) {
      throw ApiException(500, 'Error fetching service: $e');
    }
  }

  Future<void> updateService(int id, Map<String, dynamic> serviceData) async {
    try {
      await _dio.put(
          '$baseUrl/services/$id',
          data: serviceData,
          options: Options(headers: await _getHeaders())
      );
    } catch (e) {
      throw ApiException(500, 'Error updating service: $e');
    }
  }


  Future<void> deleteService(int id) async {
    try {
      await _dio.delete(
          '$baseUrl/services/$id',
          options: Options(headers: await _getHeaders())
      );
    } catch (e) {
      throw ApiException(500, 'Error deleting service: $e');
    }
  }




  Future<void> uploadServiceImage(int id, File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: fileName)
      });

      await _dio.post(
          '$baseUrl/services/$id/upload-image',
          data: formData,
          options: Options(
              headers: await _getHeaders(),
              contentType: 'multipart/form-data'
          )
      );
    } catch (e) {
      throw ApiException(500, 'Error uploading image: $e');
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic errorData;

  ApiException(this.statusCode, this.message, {this.errorData});

  @override
  String toString() {
    return 'ApiException: $statusCode - $message${errorData != null ? '\nError Data: $errorData' : ''}';
  }
}
