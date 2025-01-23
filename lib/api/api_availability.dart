import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AvailabilityApi {
  final Dio dio = Dio();
  final storage = const FlutterSecureStorage();
  final String baseUrl = 'http://producti-myserviceloadba-519714058.us-east-1.elb.amazonaws.com';

  Future<Map<String, String>> getHeaders() async {
    final token = await storage.read(key: 'access_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
  }

  Future<Map<String, dynamic>> getServiceAvailability(int serviceId, String date) async {
    try {
      final response = await dio.get(
          '$baseUrl/services/$serviceId/availability',
          queryParameters: {'date': date},
          options: Options(headers: await getHeaders())
      );

      if(response.statusCode != 200) {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Error fetching availability'
        );
      }

      return response.data;

    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> createReservation({
    required int serviceId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final response = await dio.post(
          '$baseUrl/reservations',
          data: {
            'service_id': serviceId,
            'date': date,
            'start_time': startTime,
            'end_time': endTime
          },
          options: Options(headers: await getHeaders())
      );

      if(response.statusCode != 201) {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Error creating reservation'
        );
      }

    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}