import 'dart:async';

import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/models/api.dart';
import 'package:short_time_app/models/rating.dart';

class RatingService {
  final ShortTimeApiClient _apiClient;

  RatingService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;

  Future<CreateRatingResponseDto> createRating(CreateRatingDto createRatingDto) async {
    try {
      return await _apiClient.makeRequest<CreateRatingResponseDto>(
        'POST',
        '/ratings',
        body: createRatingDto.toJson(),
        fromJson: CreateRatingResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetAllRatingsDto> getAllRatings(num id) async {
    try {
      return await _apiClient.makeRequest<GetAllRatingsDto>(
        'GET',
        '/ratings/$id/all',
        fromJson: GetAllRatingsDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetAllRatingsDto> getClientRatings(num id) async {
    try {
      return await _apiClient.makeRequest<GetAllRatingsDto>(
        'GET',
        '/ratings/client/$id',
        fromJson: GetAllRatingsDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<RatingDto> getRatingById(num id) async {
    try {
      return await _apiClient.makeRequest<RatingDto>(
        'GET',
        '/ratings/$id',
        fromJson: RatingDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> updateRating(num id, UpdateRatingDto updateRatingDto) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'PUT',
        '/ratings/$id',
        body: updateRatingDto.toJson(),
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> deleteRating(num id) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'DELETE',
        '/ratings/$id',
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }
}