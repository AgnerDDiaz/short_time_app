import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/api.dart';
import 'api_client.dart';

class ProfileService {
  final ShortTimeApiClient _apiClient;

  ProfileService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;

  Future<MessageResponseDto> uploadProfilePicture(http.MultipartFile file) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'POST',
        '/profile/upload-profile-picture',
        body: {'file': file},
        fromJson: MessageResponseDto.fromJson,
        isMultipart: true,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }
}