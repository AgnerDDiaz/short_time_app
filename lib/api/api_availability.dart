import 'dart:async';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/models/api.dart';
import 'package:short_time_app/models/availability.dart';


class AvailabilityService {
  final ShortTimeApiClient _apiClient;

  AvailabilityService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;

  Future<CreateAvailabilityResponseDto> createAvailability(CreateAvailabilityDto createAvailabilityDto) async {
    try {
      return await _apiClient.makeRequest<CreateAvailabilityResponseDto>(
        'POST',
        '/avalability',
        body: createAvailabilityDto.toJson(),
        fromJson: CreateAvailabilityResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }



  Future<GetAvailabilityByIdResponseDto> getAvailabilityById(num id) async {
    try {
      return await _apiClient.makeRequest<GetAvailabilityByIdResponseDto>(
        'GET',
        '/avalability/$id',
        fromJson: GetAvailabilityByIdResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetAvailabilityOfDateResponseDto> getAvailabilityOfDate(GetAvailabilityOfDateDto getAvailabilityOfDateDto) async {
    try {
      return await _apiClient.makeRequest<GetAvailabilityOfDateResponseDto>(
        'POST',
        '/avalability/availability-of-date',
        body: getAvailabilityOfDateDto.toJson(),
        fromJson: GetAvailabilityOfDateResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> updateAvailabilityById(num id, UpdateAvailabilityDto updateAvailabilityDto) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'PUT',
        '/avalability/$id',
        body: updateAvailabilityDto.toJson(),
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> deleteAvailability(num id) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'DELETE',
        '/avalability/$id',
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }
}