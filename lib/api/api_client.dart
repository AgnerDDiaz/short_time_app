import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic errorData; // Include error data from the API

  ApiException(this.statusCode, this.message, {this.errorData});

  @override
  String toString() {
    return 'ApiException: $statusCode - $message${errorData != null ? '\nError Data: $errorData' : ''}';
  }
}

class ShortTimeApiClient {

  String baseUrl;
  static final ShortTimeApiClient _singleton = ShortTimeApiClient._internal();
  final _storage = const FlutterSecureStorage();
  factory ShortTimeApiClient() {
    return _singleton;
  }
  ShortTimeApiClient._internal() : baseUrl = 'http://producti-myserviceloadba-519714058.us-east-1.elb.amazonaws.com';

  Future<Map<String, String>> getHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<T> makeRequest<T>(String method, String path,
      {Map<String, dynamic>? queryParams, dynamic body, T Function(dynamic)? fromJson, bool isMultipart = false}) async {
    final uri = Uri.parse('$baseUrl$path');
    final finalUri = queryParams != null ? uri.replace(queryParameters: queryParams) : uri;
    http.Response response;

    try {
      if (isMultipart) {
        var request = http.MultipartRequest(method, finalUri);
        request.headers.addAll(await getHeaders());
          if (body is Map<String, dynamic>) {
            body.forEach((key, value) {
              if (value is http.MultipartFile) {
                request.files.add(value);
              } else if (value != null){
                request.fields[key] = value.toString();
              }
            });
          }
        response = await http.Response.fromStream(await request.send());

      } else {
        switch (method) {
          case 'GET':
            response = await http.get(finalUri, headers: await getHeaders());
            break;
          case 'POST':
            response = await http.post(finalUri, headers: await getHeaders(), body: body != null ? jsonEncode(body) : null);
            break;
          case 'PUT':
            response = await http.put(finalUri, headers: await getHeaders(), body: body != null ? jsonEncode(body) : null);
            break;
          case 'DELETE':
            response = await http.delete(finalUri, headers: await getHeaders());
            break;
          default:
            throw ArgumentError('Invalid HTTP method: $method');
        }
      }
    } catch (e) {
      throw ApiException(500, 'Network error: $e');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (fromJson != null) {
        try {
          return fromJson(jsonDecode(response.body));
        } on FormatException catch (e) {
          throw ApiException(500, 'Invalid JSON format: $e - ${response.body}');
        }
      } else {
        return response.body as T; // For String responses
      }
    } else {
      dynamic errorData;
      try {
        errorData = jsonDecode(response.body);
      } catch (_) {
        // Ignore JSON decoding errors for error responses
      }
      throw ApiException(response.statusCode, response.body, errorData: errorData);
    }
  }
}