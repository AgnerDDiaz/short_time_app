import 'dart:async';

import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/models/api.dart';
import 'package:short_time_app/models/reservation.dart';

class ReservationService {
  final ShortTimeApiClient _apiClient;

  ReservationService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;

  Future<SearchReservationResponseDto> searchReservation() async {
    try {
      return await _apiClient.makeRequest<SearchReservationResponseDto>(
        'GET',
        '/reservations/all',
        fromJson: SearchReservationResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<CreateReservationResponseDto> createReservation(CreateReservationDto createReservationDto) async {
    try {
      return await _apiClient.makeRequest<CreateReservationResponseDto>(
        'POST',
        '/reservations',
        body: createReservationDto.toJson(),
        fromJson: CreateReservationResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetReservationResponseDto> getReservationById(num id) async {
    try {
      return await _apiClient.makeRequest<GetReservationResponseDto>(
        'GET',
        '/reservations/$id',
        fromJson: GetReservationResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> updateReservation(num id, UpdateReservationDto updateReservationDto) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'PUT',
        '/reservations/$id',
        body: updateReservationDto.toJson(),
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> deleteReservation(num id) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'DELETE',
        '/reservations/$id',
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }
}