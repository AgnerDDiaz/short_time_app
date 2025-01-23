import 'dart:async';
import 'api_client.dart';
import '../models/user.dart'; // Import your user DTOs
import '../models/api.dart';

class UserService {
  final ShortTimeApiClient _apiClient;

  UserService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;


  Future<GetAllClientsResponseDto> getClients() async {
    try {
      return await _apiClient.makeRequest<GetAllClientsResponseDto>('GET', '/users/clients', fromJson: GetAllClientsResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetUserByIdResponseDto> getUserById(num id) async {
    try {
      return await _apiClient.makeRequest<GetUserByIdResponseDto>('GET', '/users/$id', fromJson: GetUserByIdResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> updateUser(num id, UpdateUserDto updateUserDto) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>('PUT', '/users/$id',
          body: updateUserDto.toJson(), fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> deleteUser(num id) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>('DELETE', '/users/$id', fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }
}