import 'dart:async';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/models/api.dart';
import 'package:short_time_app/models/service.dart';


class ServiceService {
  final ShortTimeApiClient _apiClient;

  ServiceService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;

  Future<CreateServiceResponseDto> createService(CreateServiceDto createServiceDto) async {
    try {
      return await _apiClient.makeRequest<CreateServiceResponseDto>('POST', '/services',
          body: createServiceDto.toJson(), fromJson: CreateServiceResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetServiceByIdResponseDto> getServiceById(num id) async {
    try {
      return await _apiClient.makeRequest<GetServiceByIdResponseDto>('GET', '/services/$id', fromJson: GetServiceByIdResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> updateService(num id, UpdateServiceDto updateServiceDto) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>('PUT', '/services/$id',
          body: updateServiceDto.toJson(), fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> deleteService(num id) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>('DELETE', '/services/$id', fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetAllServicesResponseDto> getAllServices(num clientId) async {
    try {
      final queryParams = {
        'client_id': clientId.toString(),
      };
      return await _apiClient.makeRequest<GetAllServicesResponseDto>('GET', '/services/all', queryParams: queryParams, fromJson: GetAllServicesResponseDto.fromJson);
    } on ApiException catch (e) {
      print("Es aquí");
      rethrow;
    }
  }
}